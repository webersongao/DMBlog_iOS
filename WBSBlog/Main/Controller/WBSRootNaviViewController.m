//
//  WBSRootNaviViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/8/17.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSRootNaviViewController.h"
#import "RESideMenu.h"

@interface WBSRootNaviViewController ()

@end

@implementation WBSRootNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_sidebar"] style:UIBarButtonItemStyleDone target:self action:@selector(onClickMenuButton)];
    
}


/**
 *  左侧滑动展开
 */
-(void)onClickMenuButton{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
