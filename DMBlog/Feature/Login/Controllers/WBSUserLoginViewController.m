//
//  WBSUserLoginViewController.m
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "WBSUserLoginViewController.h"
#import "WBSSelectBlogViewController.h"
#import "WBSNetRequest.h"
#import "NetworkingCenter.h"
#import "WBSNetworking.h"
#import "WBSPopoverView.h"

@interface WBSUserLoginViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate,scaleViewSelectRowDelegate>

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
 *  是否启用JSON API 默认 JSONAPI
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

@implementation WBSUserLoginViewController

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
    
    // 默认开启 JSONAPI
    [WBSUtils saveBoolforKey:YES forKey:WBSIs_JSONAPI];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBlogAction:)];
    
    self.view.backgroundColor = [UIColor themeColor];
    
    // 默认为wordpress博客
    self.footerApi = @"xmlrpc.php";
    UIView *indexView = [[[NSBundle mainBundle]loadNibNamed:@"WBSLogin" owner:self options:nil] lastObject];
    self.view = indexView;
    
    UIButton *temp = [[UIButton alloc]initWithFrame:CGRectMake(KSCREEN_Width - 60 , 20, 40, 40)];
    temp.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:temp];
    [temp addTarget:self action:@selector(tempButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 选择api接口类型按钮  默认JsonApi
- (IBAction)apiTypeButtonDidClick:(UIButton *)sender {
    
    self.apiTypeButton.selected = !sender.isSelected;
    if (self.apiTypeButton.isSelected) {
        KLog(@"开启XMLRPC API");
        [WBSUtils saveBoolforKey:NO forKey:WBSIs_JSONAPI];
        _baseURLField.placeholder = @"www.jack_blog.com";
    } else {
        KLog(@"开启JSON API");
        [WBSUtils saveBoolforKey:YES forKey:WBSIs_JSONAPI];
        _baseURLField.placeholder = @"请输入JSON API入口地址";
    }
}



#pragma mark 选择博客类型
- (void)selectBlogAction:(UIButton *)button {
    
    CGPoint point = CGPointMake(self.view.width-32,66);
    NSArray *titleArr = @[@"编辑信息",@"博客模式", @"导入资料"];
    NSArray *imagesArr = @[@"home_PopMenu_edit",@"home_PopMenu_list", @"home_PopMenu_Import"];
    WBSPopoverView *popoverView = [[WBSPopoverView alloc] initWithOrigin:point Width:130 Height:40 * 3 Type:WBSScaleDirectionTypeUpRight Color:[UIColor themeColor] titleArray:titleArr imagesArray:imagesArr superView:self.view];
    popoverView.delegate = self;
    [popoverView showScaleView];
    
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
        // 保存登录地址
        [WBSUtils showProgressMessage:@"登录中..."];
        NSString *jsonUrl = [NSString stringWithFormat:@"http://%@",baseURL];
        NSString *xmlRpcUrl = [NSString stringWithFormat:@"http://%@/xmlrpc.php",baseURL];
        [WBSUtils saveObjectforKey:jsonUrl forKey:WBSSiteBaseURL];
        [WBSUtils saveObjectforKey:xmlRpcUrl forKey:WBSSiteXmlrpcURL];
    }else{
        [WBSUtils showErrorMessage:@"账号异常,请稍后再试"];
        return;
    }
    [[WBSNetRequest sharedRequest] userLoginWithSiteBaseUrlStr:baseURL successBlock:^(BOOL isLoginSuccess, NSString *errorMsg) {
        // 登录结果
        if (isLoginSuccess) {
            [WBSUtils showSuccessMessage:@"登录成功"];
            [WBSUtils saveBoolforKey:NO forKey:WBSGuestLoginMode];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [WBSUtils goToMainViewController];
            });
        }else{
            [WBSUtils showErrorMessage:errorMsg];
        }
    } userNameStr:username PassWordStr:password isJsonAPi:!self.apiTypeButton.isSelected];
    
    
    
}

-(void)scaleView:(WBSPopoverView *)scaleView didSelectRow:(NSInteger)rowIndex{
    
    switch (rowIndex) {
        case 0:
        {
            NSLog(@"编辑信息");
        }
            break;
        case 1:
        {
            NSLog(@"博客模式");
        }
            break;
        case 2:
        {
            NSLog(@"导入资料");
        }
            break;
            
        default:
            break;
    }
}









/// 游客登录
- (IBAction)guestLogin:(UIButton *)button {
    
    [WBSUtils saveBoolforKey:YES forKey:WBSGuestLoginMode];
    [SingleObject shareSingleObject].isGuest = YES;
    [WBSUtils goToMainViewController];
    
}




-(void)tempButtonAction{
    [SingleObject shareSingleObject].isGuest = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
