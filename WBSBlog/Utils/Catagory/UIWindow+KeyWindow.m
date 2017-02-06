//
//  UIWindow+KeyWindow.m
//  WBSBlog
//
//  Created by Weberson on 2017/1/23.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "UIWindow+KeyWindow.h"
#import "WBSRootTabBarController.h"
#import "MMDrawerController.h"
#import "WBSLeftMenuViewController.h"
#import "WBSBaseNaviViewController.h"

#import "WBSLoginViewController.h"


@implementation UIWindow (KeyWindow)


- (void)switchToRootTabbarViewController{

    WBSRootTabBarController *centerVC = [[WBSRootTabBarController alloc]init];
    WBSLeftMenuViewController *leftVC = [[WBSLeftMenuViewController alloc]init];
//    UIViewController *rightVC = [[UIViewController alloc]init];
    //2、初始化导航控制器
    WBSBaseNaviViewController *centerNvaVC = [[WBSBaseNaviViewController alloc]initWithRootViewController:centerVC];
    UINavigationController *leftNvaVC = [[UINavigationController alloc]initWithRootViewController:leftVC];
//    UINavigationController *rightNvaVC = [[UINavigationController alloc]initWithRootViewController:rightVC];
    
    //3、使用MMDrawerController
    MMDrawerController * drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNvaVC leftDrawerViewController:leftNvaVC rightDrawerViewController:nil];
    
    //4、设置打开/关闭抽屉的手势
    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    //5、设置左右两边抽屉显示的多少
    drawerController.maximumLeftDrawerWidth = 200.0;
    drawerController.maximumRightDrawerWidth = 200.0;
    
    
    //6、初始化窗口、设置根控制器、显示窗口
    self.rootViewController = drawerController;
    
    
}


/// 跳转到登录控制器
- (void)switchToLoginViewController{
    
    //初始化程序入口，设置登录界面为首页
    WBSLoginViewController *loginVC = [[WBSLoginViewController alloc]initWithNibName:@"WBSLogin" bundle:nil];
    WBSBaseNaviViewController *loginNavi = [[WBSBaseNaviViewController alloc] initWithRootViewController:loginVC];
    //6、初始化窗口、设置根控制器、显示窗口
    self.rootViewController = loginNavi;
    
    
}

@end
