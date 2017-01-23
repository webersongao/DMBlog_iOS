//
//  WBSQROauthViewController.h
//  WBSBlog
//
//  Created by Weberson on 16/10/16.
//  Copyright © 2016年 Weberson. All rights reserved.
//  摘自mu feng 同学的iUnlocker

#import "WBSQROauthViewController.h"
#import "sys/utsname.h"
#import "AFNetworking.h"
#import "SAMKeychain.h"
#import "SVProgressHUD.h"

@interface WBSQROauthViewController ()

@end

@implementation WBSQROauthViewController

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
    [button setTitle:@"授权网站" forState:UIControlStateNormal];
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
    [button setTitle:@"取消授权" forState:UIControlStateNormal];
    [button setTitleColor: [UIColor colorWithRed:170/256.f green:170/256.f blue:170/256.f alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor: [UIColor colorWithRed:136/256.f green:136/256.f blue:136/256.f alpha:1.0] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(toRootViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)generateUUID {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *result = [self.url stringByReplacingOccurrencesOfString:@"iunlocker-auth://" withString:@""];
    NSArray *resultArray = [result componentsSeparatedByString:@"#"];
    NSString *adminUrl = [NSString stringWithFormat:@"%@?action=iunlocker_oauth", [resultArray objectAtIndex:0]];
    NSString *appkey = [resultArray objectAtIndex:1];
    
    NSString *UUID = [[NSUUID UUID] UUIDString];
    [SAMKeychain setPassword:UUID forService:@"com.puckjs.iUnlocker" account:@"UUID"];
    [SAMKeychain setPassword:[resultArray objectAtIndex:0] forService:@"com.puckjs.iUnlocker" account:@"ADMINURL"];
    
    NSDictionary *params = @{
                             @"UUID": UUID,
                             @"appkey": appkey,
                             @"deviceName": [[UIDevice currentDevice] name],
                             @"systemVersion": [[UIDevice currentDevice] systemVersion],
                             @"systemInfo": [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]
                             };
    
    [SVProgressHUD showWithStatus:@"授权中..."];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:adminUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"授权成功"];
        [self toRootViewController];
        NSLog(@"response:%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"授权失败"];
        NSLog(@"error:%@", error);
    }];
    
}

- (void)toRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
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
