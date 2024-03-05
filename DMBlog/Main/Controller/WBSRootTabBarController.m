//
//  WBSRootTabBarController.m
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "WBSRootTabBarController.h"
#import "WBSOptionButton.h"
#import "WBSHomePostViewController.h"
#import "WBSSearchViewController.h"
#import "WBSTagViewController.h"
#import "WBSUserCenterController.h"
#import "WBSPostEditViewController.h"
#import "WBSBaseNaviViewController.h"

@interface WBSRootTabBarController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, assign) BOOL isPressed;   // 中间的撰写按钮是否点击的状态记录
@property (nonatomic, strong) NSMutableArray *optionButtons;
@property (nonatomic, strong) UIDynamicAnimator *animator;  // 运动对象

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGGlyph length;

@end

@implementation WBSRootTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //博客
    WBSHomePostViewController *blogSVC = [[WBSHomePostViewController alloc]init];
    
    //标签
    WBSTagViewController *tagVC = [[WBSTagViewController alloc]init];
    
    //搜索
    WBSSearchViewController *searchVC = [[WBSSearchViewController alloc]init];
    
    //我
    WBSUserCenterController *myInfoVC = [[WBSUserCenterController alloc]init];
    
    self.tabBar.translucent = NO;
    
    // 添加到底部的tabbar
    [self addChildVC:blogSVC Background:[UIColor whiteColor] title:@"博客" imageName:@"tabbar-news" selectImageName:@"tabbar-news-selected"];
    [self addChildVC:tagVC Background:[UIColor whiteColor] title:@"标签" imageName:@"tabbar-tweet" selectImageName:@"tabbar-tweet-selected"];
    
    [self addChildVC:searchVC Background:[UIColor whiteColor] title:@"搜索" imageName:@"tabbar-discover" selectImageName:@"tabbar-discover-selected"];
    
    [self addChildVC:myInfoVC Background:[UIColor whiteColor] title:@"我" imageName:@"tabbar-me" selectImageName:@"tabbar-me-selected"];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  添加子子控制器
 *
 *  @param vc              控制器
 *  @param Color           控制器背景颜色
 *  @param title           标题
 *  @param imageName       默认显示的图片名字
 *  @param selectImageName 选中显示的图片名字
 */
- (void)addChildVC:(UIViewController *)childVC Background:(UIColor *)Color title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName
{
    childVC.title=title;
    //如果直接复制，tabbar会渲染成灰色
    //UIImageRenderingModeAlwaysOriginal 告诉图片不要渲染
    childVC.tabBarItem.image=[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //如果直接复制，tabbar会渲染成蓝色
    //UIImageRenderingModeAlwaysOriginal 告诉图片不要渲染
    childVC.tabBarItem.selectedImage=[[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 修改文字颜色
    //    NSDictionary *dict=@{
    //                         NSForegroundColorAttributeName:BottomTextColor,
    //                         NSFontAttributeName:[UIFont systemFontOfSize:12.0f]
    //                         };
    //    [childVC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    //    NSDictionary *dictS=@{
    //                          NSForegroundColorAttributeName:BottomTextSelectColor,
    //                          NSFontAttributeName:[UIFont systemFontOfSize:12.0f]
    //                          };
    //    [childVC.tabBarItem setTitleTextAttributes:dictS forState:UIControlStateSelected];
    //将传进来的childVC包装成nav。
    //    WBSBaseNaviViewController *childNav=[[WBSBaseNaviViewController alloc]initWithRootViewController:childVC];
    
    [self addChildViewController:childVC];
}


@end
