//
//  WBSSwipableViewController.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSTitleBarView.h"
#import "WBSHorizonalTableViewController.h"

@interface WBSSwipableViewController : UIViewController

@property (nonatomic, strong) WBSHorizonalTableViewController *viewPager;
@property (nonatomic, strong) WBSTitleBarView *titleBar;

- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers underTabbar:(BOOL)underTabbar;
- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers;

@end