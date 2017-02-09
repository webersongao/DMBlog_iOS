//
//  WBSLoginViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSLoginViewController.h"
#import "WBSSelectBlogViewController.h"
#import "WBSNetRequest.h"
#import "UIView+Util.h"



@interface WBSLoginViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

/**
 *  xmlrpcURL
 */

@property (weak, nonatomic) IBOutlet UITextField *baseURLField;
/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
/**
 *  是否启用JSON API
 */
@property (weak, nonatomic) IBOutlet UIButton* apiTypeButton;

/**
 *  网址api博客类型尾巴
 */
@property(nonatomic, copy) NSString *footerPrefix;
/**
 *  网址尾巴api
 */
@property(nonatomic, copy) NSString *footerApi;


@end

@implementation WBSLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //判断登录状态
    WBSApiInfo *apiInfo = [WBSConfig getAuthoizedApiInfo];
    if (apiInfo) {
        // 已经登录
        KLog(@"Current baseURL:%@ username:%@ password:%@-- 已经登录！", apiInfo.siteURL, apiInfo.username, apiInfo.password);
        [SingleObject shareSingleObject].isLogin = YES;
        // 解档 赋值用户数据
        NSString *userUID = [WBSUtils getObjectforKey:WBSUserUID];
        WBSUserModel *userModel = [[FMDBManger sharedFMDBManger]getUserModelInfoWithUid:userUID];
        [SingleObject shareSingleObject].user = userModel;
        //已经登录过，跳转到博文主界面，程序继续
        [WBSUtils goToMainViewController];
        return;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化导航栏
    self.navigationItem.title = @"登录";
    [WBSUtils saveDataWithBool:NO forKey:WBSIs_JSONAPI];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBlogAction:)];
    
    self.view.backgroundColor = [UIColor themeColor];
    
    // 默认为wordpress博客
    self.footerApi = @"xmlrpc.php";
    UIView *indexView = [[[NSBundle mainBundle]loadNibNamed:@"WBSLogin" owner:self options:nil]lastObject];
    self.view = indexView;
    
    
}

#pragma mark 选择api接口类型按钮
- (IBAction)apiTypeButtonDidClick:(UIButton *)sender {
    
    self.baseURLField.text = @"";
    if (!self.apiTypeButton.isSelected) {
        KLog(@"开启JSON API");
        [WBSUtils saveDataWithBool:YES forKey:WBSIs_JSONAPI];
        self.apiTypeButton.selected = YES;
        _baseURLField.placeholder = @"请输入JSON API入口地址";
    } else {
        KLog(@"开启XMLRPC API");
        [WBSUtils saveDataWithBool:NO forKey:WBSIs_JSONAPI];
        self.apiTypeButton.selected = NO;
        _baseURLField.placeholder = @"www.jack_blog.com";
    }
}



#pragma mark 选择博客类型
- (void)selectBlogAction:(UIButton *)button {
    
    WBSSelectBlogViewController *selectBlogController = [[WBSSelectBlogViewController alloc] init];
    [self.navigationController pushViewController:selectBlogController animated:YES];
    
}

#pragma mark 登录相关
- (IBAction)loginButtonDidClick:(UIButton *)sender {
    
    // 临时添加默认账号
    _baseURLField.text = KbaseUrl;
    _usernameField.text = KuserName;
    _passwordField.text = KpassWord;
    
    NSString *baseURL = [_baseURLField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *username = [_usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 验证账号密码 格式
    if ([WBSUtils checkUrlString:baseURL userNameStr:username passWord:password]) {
       [WBSUtils showStatusMessage:@"登录中..."];
    }else{
        return;
    }
    
    [WBSNetRequest userLogin:^(BOOL isLoginSuccess, NSString * errorMsg) {
        // 登录结果
        if (isLoginSuccess) {
            [WBSUtils saveDataWithBool:NO forKey:WBSGuestLoginMode];
            [WBSUtils goToMainViewController];
        }else{
            [WBSUtils showErrorMessage:errorMsg];
        }
    } SiteUrlStr:baseURL userNameStr:username PassWordStr:password isJsonAPi:self.apiTypeButton.isSelected];
    
    
}
/// 游客登录
- (IBAction)guestLogin:(UIButton *)button {

    [WBSUtils saveDataWithBool:YES forKey:WBSGuestLoginMode];
    [SingleObject shareSingleObject].isGuest = YES;
    [WBSUtils goToMainViewController];
    
}







@end
