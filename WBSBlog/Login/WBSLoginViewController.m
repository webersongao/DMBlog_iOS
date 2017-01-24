//
//  WBSLoginViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSLoginViewController.h"
#import "WBSRootTabBarController.h"
#import "WBSSideMenuViewController.h"
#import "RESideMenu.h"
#import "AppDelegate.h"
#import "TGMetaWeblogApi.h"
#import "TTTAttributedLabel.h"
#import "WBSSelectBlogViewController.h"
#import "WBSNetRequest.h"



@interface WBSLoginViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate, TTTAttributedLabelDelegate>

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

@property(nonatomic, strong) UISwitch *apiTypeSwitch;
/**
 *  登陆按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/**
 *  点击温馨提示之后的  提示信息
 */
@property(nonatomic, strong) TTTAttributedLabel *messageInfo;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    //判断登录状态
    WBSApiInfo *apiInfo = [WBSConfig getAuthoizedApiInfo];
    if (apiInfo) {
        // 已经登录
        KLog(@"Current baseURL:%@ username:%@ password:%@-- 已经登录！", apiInfo.baseURL, apiInfo.username, apiInfo.password);
        //已经登录过，跳转到主界面，停止程序继续
        [WBSUtils goToMainViewController];
        return;
    }
    
    //初始化导航栏
    self.navigationItem.title = @"登录";
    
    self.navigationItem.rightBarButtonItem                                                     = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBlog)];
    
    self.view.backgroundColor = [UIColor themeColor];
    
    //    //初始化视图和布局
    [self setupSubviews];
    
    // 默认为wordpress博客
    self.footerApi = @"xmlrpc.php";
    UIView *indexView = [[[NSBundle mainBundle]loadNibNamed:@"WBSLogin" owner:self options:nil]lastObject];
    self.view = indexView;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    //加载登陆数据
    KLog(@"appeared");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - about subviews

- (void)setupSubviews {
    
    _baseURLField.textColor = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    _baseURLField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _baseURLField.keyboardType = UIKeyboardTypeEmailAddress;
    _baseURLField.delegate = self;
    _baseURLField.returnKeyType = UIReturnKeyNext;
    _baseURLField.enablesReturnKeyAutomatically = YES;
    
    _usernameField.textColor = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    
    _passwordField.textColor = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    
    
    [_usernameField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    _apiTypeSwitch                                                                             = [[UISwitch alloc] init];
    [_apiTypeSwitch addTarget:self action:@selector(doSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_apiTypeSwitch];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    //解决TTTAttributedLabel的代理方法didSelectLinkWithURL不触发的Bug 15-07-29
    gesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gesture];
}

#pragma mark - 键盘操作

- (void)hidenKeyboard {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

/// 退回键盘
- (void)returnOnKeyboard:(UITextField *)sender {
    if (sender == _usernameField) {
        [_passwordField becomeFirstResponder];
    } else if (sender == _passwordField) {
        [self hidenKeyboard];
        if (_loginButton.enabled) {
            // 开始登陆
            [self loginButtonDidClick:nil];
        }
    }
}
#pragma mark 温馨提示 按钮
- (IBAction)tipsButtonDidClick:(UIButton *)sender {
    
    // 修改提示文字信息
    KLog(@"修改提示文字信息");
    
}

#pragma mark 选择api接口类型按钮
- (IBAction)apiTypeButtonDidClick:(UIButton *)sender {
    
    self.baseURLField.text = @"";
    if (!self.apiTypeButton.isSelected) {
        KLog(@"开启JSON API");
        self.apiTypeButton.selected = YES;
        _baseURLField.placeholder = @"请输入JSON API入口地址";
    } else {
        KLog(@"开启XMLRPC API");
        self.apiTypeButton.selected = NO;
        _baseURLField.placeholder = @"www.jack_blog.com";
    }
}



#pragma mark 选择博客类型
- (void)selectBlog {
    KLog(@"选择博客。");
    WBSSelectBlogViewController *selectBlogController                                          = [[WBSSelectBlogViewController alloc] init];
    
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
    
    //登陆验证
    if ([baseURL isEqualToString:@""]) {
        [WBSUtils showErrorMessage:@"博客API地址不能为空！"];
        return;
    }
    
    if ([baseURL hasPrefix:@"http"]) {
        [WBSUtils showErrorMessage:@"博客地址勿带http"];
        return;
    }
    
    if ([username isEqualToString:@""]) {
        [WBSUtils showErrorMessage:@"用户名不能为空！"];
        
        return;
    }
    
    if (username.length < 5 || username.length > 20) {
        
        [WBSUtils showErrorMessage:@"用户名只能在5-20之间！"];
        return;
    }
    
    if ([password isEqualToString:@""]) {
        [WBSUtils showErrorMessage:@"密码不能为空!"];
        return;
    }
    
    if (password.length < 5 || password.length > 20) {
        [WBSUtils showErrorMessage:@"密码只能在5-20之间!"];
        return;
    }
    
    [WBSUtils showStatusMessage:@"登录中..."];
    
    BOOL isLoginSuccess = NO;
    if (_apiTypeSwitch.on) {
        KLog(@"JSON API");
       isLoginSuccess =  [WBSNetRequest postToLoginWithSiteUrlStr:baseURL userNameStr:username PassWordStr:password isJsonAPi:YES];
    } else {
        KLog(@"XMLRPC API");
      isLoginSuccess = [WBSNetRequest postToLoginWithSiteUrlStr:baseURL userNameStr:username PassWordStr:password isJsonAPi:NO];
        
    }
    if (isLoginSuccess) {
        [WBSUtils saveDataWithBool:NO forKey:WBSGuestLoginMode];
        [WBSUtils goToMainViewController];
    }
}
/// 游客登录
- (IBAction)guestLogin:(UIButton *)sender {

    [WBSUtils saveDataWithBool:YES forKey:WBSGuestLoginMode];
    [WBSUtils goToMainViewController];
    
}



#pragma mark - 超链接代理

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point {
    UIAlertController *confirmCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否使用Safari打开网页？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction  = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //调用Safari打开网页
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url absoluteString]]];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [confirmCtl addAction:yesAction];
    [confirmCtl addAction:noAction];
    [self presentViewController:confirmCtl animated:YES completion:nil];
}

/**
 *  超链接单击
 *
 *  @param label label
 *  @param url   url
 */
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    KLog(@"Selected url:%@", [url absoluteString]);
    NSString *title = @"What is MetaWeblog API?";
    if ([[url absoluteString] isEqualToString:@"https://github.com/webersongao/WBSBlog/blob/master/OtherResource/metaweblog-api-http-sample-data.md"]) {
        title                                                                                      = @"Wordpress JSON API";
    }
    [WBSUtils navigateUrl:self withUrl:url andTitle:title];
}


/********-----------------------------------------***********
 #pragma mark -懒加载   以下代码暂时可删
 ********-----------------------------------------***********/
-(TTTAttributedLabel *)messageInfo{
    if (_messageInfo == nil) {
        
        _messageInfo = [TTTAttributedLabel new];
        _messageInfo.delegate = self;
        _messageInfo.numberOfLines = 0;
        _messageInfo.lineBreakMode = NSLineBreakByWordWrapping;
        _messageInfo.backgroundColor = [UIColor themeColor];
        _messageInfo.font = [UIFont systemFontOfSize:12];
        NSString *info = @"温馨提示：您可以登录任何实现了XML-RPC MetaWeblog API接口的博客。目前已经支持并测试通过的博客：Wordpress、ZBlog、Cnblogs、OSChina、163、51CTO、Sina。\r由于MetaWeblog API接口的限制，暂时只能进行文章的显示、查看、新增、修改和删除。\r部分功能有些博客不支持，详情看这里。\r更多功能需要服务端API支持，详情查看：Wordpress JSON API。";
        _messageInfo.text = info;
        NSRange range1 = [info rangeOfString:@"XML-RPC MetaWeblog API"];
        _messageInfo.linkAttributes = @{(NSString *) kCTForegroundColorAttributeName : [UIColor colorWithHex:0x428bd1]};
        [_messageInfo addLinkToURL:[NSURL URLWithString:@"https://en.wikipedia.org/wiki/MetaWeblog"] withRange:range1];
        NSRange range2 = [info rangeOfString:@"详情看这里"];
        [_messageInfo addLinkToURL:[NSURL URLWithString:@"呜呜呜"] withRange:range2];
        [self.view addSubview:_messageInfo];
        NSRange range3 = [info rangeOfString:@"Wordpress JSON API"];
        [_messageInfo addLinkToURL:[NSURL URLWithString:@"https://github.com/webersongao/WBSBlog/blob/master/OtherResource/wordpress-json-api-http-sample-data.md"] withRange:range3];
    }
    return _messageInfo;
}


@end
