//
//  WBSQRLoginViewController.h
//  WBSBlog
//
//  Created by Weberson on 16/10/16.
//  Copyright © 2016年 Weberson. All rights reserved.
//  摘自mu feng 同学的iUnlocker

#import "WBSQRLoginViewController.h"
#import "sys/utsname.h"
#import "AFNetworking.h"
#import "SAMKeychain.h"
#import "SVProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>

@interface WBSQRLoginViewController ()

@end

@implementation WBSQRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)setupViews {
    [self setBackground];
    [self setDescription];
    [self setButton];
    [self setCancelButton];
}

- (void)setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:(CGRect){(SCREEN_W-147.f)/2, 170.f, 147.f, 100.f}];
    [backgroundView setImage:[UIImage imageNamed:@"connect_alert_mac_mute.png"]];
    
    [self.view addSubview:backgroundView];
}

- (void)setDescription {
    UILabel *description = [[UILabel alloc] initWithFrame:(CGRect){0, 300.f, SCREEN_W, 16.f}];
    [description setTextColor:[UIColor colorWithRed:75/256.f green:75/256.f blue:75/256.f alpha:1.0]];
    [description setText:@"点击按钮获取授权"];
    [description setFont:[UIFont fontWithName:@"Helvetica" size:18.f]];
    [description setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:description];
}

- (void)setButton {
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRect){(SCREEN_W-150.f)/2, 400.f, 150.f, 35.f}];
    [button setTitle:@"登录网站" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:55/256.f green:201/256.f blue:54/256.f alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"greenHL.png"] forState:UIControlStateHighlighted];
    
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 3.0f;
    button.layer.borderColor = [[UIColor colorWithRed:55/256.f green:201/256.f blue:54/256.f alpha:1.0] CGColor];
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(generateUUID) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)setCancelButton {
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRect){(SCREEN_W-150.f)/2, 460.f, 150.f, 35.f}];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [button setTitle:@"取消登录" forState:UIControlStateNormal];
    [button setTitleColor: [UIColor colorWithRed:170/256.f green:170/256.f blue:170/256.f alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor: [UIColor colorWithRed:136/256.f green:136/256.f blue:136/256.f alpha:1.0] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(toRootViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)scaned {
    NSString *adminUrl = [SAMKeychain passwordForService:@"com.puckjs.iUnlocker" account:@"ADMINURL"];
    NSString *UUID = [SAMKeychain passwordForService:@"com.puckjs.iUnlocker" account:@"UUID"];
    
    if (adminUrl == nil || UUID == nil) {
        [SVProgressHUD showErrorWithStatus:@"需要网站授权"];
        [self toRootViewController];
    } else {
        struct utsname systemInfo;
        uname(&systemInfo);
        
        adminUrl = [adminUrl stringByAppendingString:@"?action=iunlocker_login"];
        
        NSString *appkey = [self.url stringByReplacingOccurrencesOfString:@"iunlocker://" withString:@""];
        NSDictionary *params = @{
                                 @"UUID": UUID,
                                 @"appkey": appkey,
                                 @"scaned": @YES,
                                 @"deviceName": [[UIDevice currentDevice] name],
                                 @"systemVersion": [[UIDevice currentDevice] systemVersion],
                                 @"systemInfo": [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]
                                 };
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:adminUrl
           parameters:params
              success:^(NSURLSessionTask *task, id res) {
                  NSLog(@"response:%@", res);
              }
              failure:^(NSURLSessionTask *task, NSError *error) {
                  NSLog(@"error:%@", error);
              }];
    }

}

- (void)generateUUID {
    NSString *adminUrl = [SAMKeychain passwordForService:@"com.puckjs.iUnlocker" account:@"ADMINURL"];
    NSString *UUID = [SAMKeychain passwordForService:@"com.puckjs.iUnlocker" account:@"UUID"];
    
    if (adminUrl == nil || UUID == nil) {
        [SVProgressHUD showErrorWithStatus:@"需要网站授权"];
        [self toRootViewController];
    } else {
        struct utsname systemInfo;
        uname(&systemInfo);
        
        adminUrl = [adminUrl stringByAppendingString:@"?action=iunlocker_login"];
        
        NSString *appkey = [self.url stringByReplacingOccurrencesOfString:@"iunlocker://" withString:@""];
        NSDictionary *params = @{
                                 @"UUID": UUID,
                                 @"appkey": appkey,
                                 @"token": [self md5:[NSString stringWithFormat:@"%@%@", appkey, UUID]],
                                 @"deviceName": [[UIDevice currentDevice] name],
                                 @"systemVersion": [[UIDevice currentDevice] systemVersion],
                                 @"systemInfo": [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]
                                 };
        
        [SVProgressHUD showWithStatus:@"登录中..."];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:adminUrl
           parameters:params
              success:^(NSURLSessionTask *task, id res) {
                  [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                  [self toRootViewController];
                  NSLog(@"response:%@", res);
              }
              failure:^(NSURLSessionTask *task, NSError *error) {
                  [SVProgressHUD showErrorWithStatus:@"登录失败"];
                  NSLog(@"error:%@", error);
              }];
    }
}

-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (void)toRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self scaned];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
