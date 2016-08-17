//
//  WBSLoginViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSLoginViewController.h"
#import "WBSUtils.h"
#import "WBSRootTabBarController.h"
#import "WBSSideMenuViewController.h"
#import "RESideMenu.h"
#import "AppDelegate.h"
#import "TGMetaWeblogApi.h"
#import "TTTAttributedLabel.h"
#import "WBSSelectBlogViewController.h"
#import "WBSConfig.h"


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
 *  提示框
 */
@property(nonatomic, strong) MBProgressHUD *HUD;
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
        KLog(@"Current baseURL:%@ username:%@ password:%@", apiInfo.baseURL, apiInfo.username, apiInfo.password);
        //已经登录过，跳转到主界面，停止程序继续
        [WBSUtils goToMainViewController];
        return;
    }
    
    //初始化导航栏
    self.navigationItem.title = @"登录";
    
    self.navigationItem.rightBarButtonItem                                                     = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBlog)];
    
    self.view.backgroundColor                                                                  = [UIColor themeColor];
    
    //    //初始化视图和布局
    [self setupSubviews];
    
    // 默认为wordpress博客
    self.footerApi = @"xmlrpc.php";
    
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
    
    _baseURLField.textColor                                                                    = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    _baseURLField.autocapitalizationType                                                       = UITextAutocapitalizationTypeNone;
    _baseURLField.keyboardType                                                                 = UIKeyboardTypeEmailAddress;
    _baseURLField.delegate                                                                     = self;
    _baseURLField.returnKeyType                                                                = UIReturnKeyNext;
    _baseURLField.enablesReturnKeyAutomatically                                                = YES;
    
    _usernameField.textColor                                                                   = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    
    _passwordField.textColor                                                                   = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    
    
    [_usernameField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    _apiTypeSwitch                                                                             = [[UISwitch alloc] init];
    [_apiTypeSwitch addTarget:self action:@selector(doSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_apiTypeSwitch];
    
    
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture                                                            = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired                                                               = 1;
    gesture.delegate                                                                           = self;
    //解决TTTAttributedLabel的代理方法didSelectLinkWithURL不触发的Bug 15-07-29
    gesture.cancelsTouchesInView                                                               = NO;
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
    
    NSString *baseURL                                                                          = [_baseURLField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *username                                                                         = [_usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password                                                                         = [_passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //登陆提示
    _HUD                                                                                       = [WBSUtils createHUD];
    
    //登陆验证
    if ([baseURL isEqualToString:@""]) {
        _HUD.labelText                                                                             = @"博客API地址不能为空！";
        _HUD.mode                                                                                  = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled                                                                = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }
    
    if ([baseURL hasPrefix:@"http"]) {
        _HUD.labelText                                                                             = @"博客地址勿带http";
        _HUD.mode                                                                                  = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled                                                                = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }
    
    if ([username isEqualToString:@""]) {
        _HUD.labelText                                                                             = @"用户名不能为空！";
        _HUD.mode                                                                                  = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled                                                                = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }
    
    if (username.length < 5 || username.length > 20) {
        _HUD.labelText                                                                             = @"用户名只能在5-20之间！";
        _HUD.mode                                                                                  = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled                                                                = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }
    
    if ([password isEqualToString:@""]) {
        _HUD.labelText                                                                             = @"密码不能为空！";
        _HUD.mode                                                                                  = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled                                                                = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }
    
    if (password.length < 5 || password.length > 20) {
        _HUD.labelText                                                                             = @"密码只能在5-20之间！";
        _HUD.mode                                                                                  = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled                                                                = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }
    
    _HUD.labelText                                                                             = @"正在登录";
    _HUD.userInteractionEnabled                                                                = NO;
    
    if (_apiTypeSwitch.on) {
        KLog(@"JSON API");
        [self loginWithJOSNAPI:baseURL username:username password:password];
    } else {
        KLog(@"XMLRPC API");
        //对baseUrl进行包装  暂时不支持Https
        baseURL                                                                                    = [NSString stringWithFormat:@"http://%@/%@",baseURL,self.footerApi];
        KLog(@"最后的地址是%@",baseURL);
        [self loginWithXmlrpc:baseURL username:username password:password];
    }
}

/**
 *  使用XMLRPC API登陆
 *
 *  @param baseURL  baseURL
 *  @param username username
 *  @param pasword  pasword
 */
- (void)loginWithXmlrpc:(NSString *)baseURL username:(NSString *)username password:(NSString *)pasword {
    //登录
    KLog(@"current user Info :===%@---%@---%@==", baseURL, username, pasword);
    [TGMetaWeblogAuthApi signInWithURL:baseURL
                              username:username
                              password:pasword
                               success:^(NSURL *xmlrpcURL) {
                                   KLog(@"登陆成功----success----:%@", xmlrpcURL);
                                   NSUserDefaults *def                                                                        = [NSUserDefaults standardUserDefaults];
                                   [def setObject:[xmlrpcURL absoluteString] forKey:@"baseURL"];
                                   [def setObject:self.usernameField.text forKey:@"mw_username"];
                                   [def setObject:self.passwordField.text forKey:@"mw_password"];
                                   [def synchronize];
                                   //隐藏提示
                                   [_HUD hide:YES afterDelay:1];
                                   //登录成功，跳转到主界面
                                   [WBSUtils goToMainViewController];
                               }
                               failure:^(NSError *error) {
                                   _HUD.mode                                                                                  = MBProgressHUDModeCustomView;
                                   _HUD.customView                                                                            = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                   _HUD.labelText                                                                             = [NSString stringWithFormat:@"错误：%@", [error localizedDescription]];
                                   [_HUD hide:YES afterDelay:1];
                               }];
}

/**
 *  使用JSON API登陆
 *
 *  @param baseURL  baseURL
 *  @param username username
 *  @param password password
 */
- (void)loginWithJOSNAPI:(NSString *)baseURL username:(NSString *)username password:(NSString *)password {
    
    NSString *requestURL                                                                       = [NSString stringWithFormat:@"%@/user/generate_auth_cookie/?username=%@&password=%@", baseURL, username, password];
    
    KLog(@"登陆请求地址：login request URL:%@", requestURL);
    //获取作者数据
    AFHTTPRequestOperationManager *manager                                                     = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 //刷新数据
                 //KLog(@"JSON: %@", responseObject);
                 KLog(@"status:%@", [result objectForKey:@"status"]);
                 NSString *status                                                                           = [result objectForKey:@"status"];
                 if ([status isEqualToString:@"ok"]) {
                     NSString *cookie                                                                           = result[@"cookie"];
                     
                     NSUserDefaults *userDefaults                                                               = [NSUserDefaults standardUserDefaults];
                     [userDefaults setObject:cookie forKey:@"generate_auth_cookie"];
                     [userDefaults synchronize];
                     
                     KLog(@"登陆成功-JSON API login ok");
                     
                     [_HUD hide:YES afterDelay:1];
                     
                     //登陆成功，跳转到主界面
                     [WBSUtils goToMainViewController];
                 } else {
                     KLog(@"登录失败-login error");
                     _HUD.mode                                                                                  = MBProgressHUDModeCustomView;
                     _HUD.customView                                                                            = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                     _HUD.labelText                                                                             = [NSString stringWithFormat:@"错误：%@", result[@"error"]];
                     [_HUD hide:YES afterDelay:1];
                 }
             });
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             KLog(@"Error login with json api: %@", [error localizedDescription]);
             _HUD.mode                                                                                  = MBProgressHUDModeCustomView;
             _HUD.customView                                                                            = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
             _HUD.labelText                                                                             = [NSString stringWithFormat:@"错误：%@", [error localizedDescription]];
             [_HUD hide:YES afterDelay:1];
             
         }];
}

#pragma mark - 超链接代理

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point {
    UIAlertController *confirmCtl                                                              = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否使用Safari打开网页？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction                                                                   = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //调用Safari打开网页
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url absoluteString]]];
    }];
    UIAlertAction *noAction                                                                    = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
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
    NSString *title                                                                            = @"What is MetaWeblog API?";
    if ([[url absoluteString] isEqualToString:@"https://github.com/webersongao/WBSBlog/blob/master/OtherResource/metaweblog-api-http-sample-data.md"]) {
        title                                                                                      = @"Wordpress JSON API";
    }
    [WBSUtils navigateUrl:self withUrl:url andTitle:title];
}


/********-----------------------------------------***********
 #pragma mark -懒加载
 ********-----------------------------------------***********/
-(TTTAttributedLabel *)messageInfo{
    if (_messageInfo == nil) {
        
        _messageInfo                                                                               = [TTTAttributedLabel new];
        _messageInfo.delegate                                                                      = self;
        _messageInfo.numberOfLines                                                                 = 0;
        _messageInfo.lineBreakMode                                                                 = NSLineBreakByWordWrapping;
        _messageInfo.backgroundColor                                                               = [UIColor themeColor];
        _messageInfo.font                                                                          = [UIFont systemFontOfSize:12];
        NSString *info                                                                             = @"温馨提示：您可以登录任何实现了XML-RPC MetaWeblog API接口的博客。目前已经支持并测试通过的博客：Wordpress、ZBlog、Cnblogs、OSChina、163、51CTO、Sina。\r由于MetaWeblog API接口的限制，暂时只能进行文章的显示、查看、新增、修改和删除。\r部分功能有些博客不支持，详情看这里。\r更多功能需要服务端API支持，详情查看：Wordpress JSON API。";
        _messageInfo.text                                                                          = info;
        NSRange range1                                                                             = [info rangeOfString:@"XML-RPC MetaWeblog API"];
        _messageInfo.linkAttributes                                                                = @{
                                                                                                       (NSString *) kCTForegroundColorAttributeName : [UIColor colorWithHex:0x428bd1]
                                                                                                       };
        [_messageInfo addLinkToURL:[NSURL URLWithString:@"https://en.wikipedia.org/wiki/MetaWeblog"] withRange:range1];
        NSRange range2                                                                             = [info rangeOfString:@"详情看这里"];
        [_messageInfo addLinkToURL:[NSURL URLWithString:@"呜呜呜"] withRange:range2];
        [self.view addSubview:_messageInfo];
        NSRange range3                                                                             = [info rangeOfString:@"Wordpress JSON API"];
        [_messageInfo addLinkToURL:[NSURL URLWithString:@"https://github.com/webersongao/WBSBlog/blob/master/OtherResource/wordpress-json-api-http-sample-data.md"] withRange:range3];
    }
    return _messageInfo;
}


@end
