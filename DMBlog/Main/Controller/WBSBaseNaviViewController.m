//
//  WBSRootNaviViewController.m
//  DMBlog
//
//  Created by WebersonGao on 16/8/17.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "WBSBaseNaviViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

@interface WBSBaseNaviViewController ()

@end

@implementation WBSBaseNaviViewController

+(instancetype)sharedNavigationVC{
    
    static WBSBaseNaviViewController * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });

    return instance;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_Me"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    
}



-(void)leftBtnClick{
    //这里的话是通过遍历循环拿到之前在AppDelegate中声明的那个MMDrawerController属性，然后判断是否为打开状态，如果是就关闭，否就是打开(初略解释，里面还有一些条件)
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
