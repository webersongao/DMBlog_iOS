//
//  WBSHorizonalTableViewController.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBSHorizonalTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *controllers;
@property (nonatomic, copy) void (^changeIndex)(NSUInteger index);
@property (nonatomic, copy) void (^scrollView)(CGFloat offsetRatio, NSUInteger focusIndex, NSUInteger animationIndex);
@property (nonatomic, copy) void (^viewDidAppear)(NSInteger index);

- (instancetype)initWithViewControllers:(NSArray *)controllers;

- (void)scrollToViewAtIndex:(NSUInteger)index;

@end
