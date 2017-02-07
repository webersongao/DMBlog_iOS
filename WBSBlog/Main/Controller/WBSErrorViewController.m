//
//  WBSErrorViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSErrorViewController.h"
#import "UIColor+Config.h"

@interface WBSErrorViewController ()

@end

@implementation WBSErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view setBackgroundColor:[UIColor themeColor]];
    
    UILabel *labelMessage = [[UILabel alloc]init];
    labelMessage.text = _errorMessage;
    
    [self.view addSubview:labelMessage];
    
    //去除Autoresize
    for (UIView *view in [self.view subviews]) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    
    //水平居中
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:labelMessage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    //上边距
    NSDictionary *views = NSDictionaryOfVariableBindings(labelMessage);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[labelMessage(20)]" options:NSLayoutAttributeCenterX|NSLayoutAttributeCenterY metrics:nil views:views]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

@end
