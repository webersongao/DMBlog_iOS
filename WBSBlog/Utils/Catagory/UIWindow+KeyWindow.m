//
//  UIWindow+KeyWindow.m
//  WBSBlog
//
//  Created by Weberson on 2017/1/23.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "UIWindow+KeyWindow.h"
#import "WBSRootTabBarController.h"
#import "RESideMenu.h"
#import "WBSLeftMenuViewController.h"
#import "WBSLoginViewController.h"
#import "WBSLoginNavViewController.h"

@implementation UIWindow (KeyWindow)


- (void)switchToRootViewController{
    
    WBSRootTabBarController *tabBarVC = [[WBSRootTabBarController alloc]init];
    
    RESideMenu *sideMenuTabBarViewController = [[RESideMenu alloc] initWithContentViewController:tabBarVC                                                                          leftMenuViewController:[WBSLeftMenuViewController new]                                                          rightMenuViewController:nil];
    
    //设置样式
    sideMenuTabBarViewController.scaleContentView = YES;
    sideMenuTabBarViewController.contentViewScaleValue = 0.95;
    sideMenuTabBarViewController.scaleMenuView = NO;
    sideMenuTabBarViewController.contentViewShadowEnabled = YES;
    sideMenuTabBarViewController.contentViewShadowRadius = 4.5;
    
    //设置根视图
    self.rootViewController=sideMenuTabBarViewController;
    
}


@end
