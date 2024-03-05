//
//  DMBaseViewController.m
//  DMBlog
//
//  Created by WebersonGao on 2017/2/6.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//

#import "DMBaseViewController.h"
#import "WBSUserLoginViewController.h"


@interface DMBaseViewController ()

@end

@implementation DMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor themeColor];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self checkUserLoginState];
    
}

/// 检车用户登录状态
- (void)checkUserLoginState {
    if (![SingleObject shareSingleObject].isLogin && ![SingleObject shareSingleObject].isGuest){
        // 未登录 非游客模式
        WBSUserLoginViewController *loginVC = [[WBSUserLoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}


@end








