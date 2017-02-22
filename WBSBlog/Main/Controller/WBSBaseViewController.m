//
//  WBSBaseViewController.m
//  WBSBlog
//
//  Created by Weberson on 2017/2/6.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSBaseViewController.h"
#import "WBSUserLoginViewController.h"


@interface WBSBaseViewController ()

@end

@implementation WBSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
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








