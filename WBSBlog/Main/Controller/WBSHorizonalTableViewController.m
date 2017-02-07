//
//  WBSHorizonalTableViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSHorizonalTableViewController.h"
#import "UIColor+Config.h"

@interface WBSHorizonalTableViewController ()

@end

static NSString *kHorizonalCellID = @"HorizonalCell";

@implementation WBSHorizonalTableViewController

- (instancetype)initWithViewControllers:(NSArray *)controllers
{
    self = [super init];
    if (self) {
        _controllers = controllers;
        for (UIViewController *controller in controllers) {
            [self addChildViewController:controller];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    /***** 为解决iPhone 6 下的popviewcontroller后的问题而做的无奈之举，这样会引入新的问题，very ugly，亟待解决 *****/
    self.tableView = [UITableView new];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = NO;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.pagingEnabled = YES;
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.bounces = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHorizonalCellID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _controllers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frame.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kHorizonalCellID forIndexPath:indexPath];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    cell.contentView.backgroundColor = [UIColor themeColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIViewController *controller = _controllers[indexPath.row];
    controller.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:controller.view];
    
    return cell;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollStop:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollStop:NO];
}



#pragma mark -

- (void)scrollToViewAtIndex:(NSUInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                          atScrollPosition:UITableViewScrollPositionNone
                                  animated:NO];
    
    if (_viewDidAppear) {
        _viewDidAppear(index);
    }
}

- (void)scrollStop:(BOOL)didScrollStop
{
    CGFloat horizonalOffset = self.tableView.contentOffset.y;
    CGFloat screenWidth = self.tableView.frame.size.width;
    CGFloat offsetRatio = (NSUInteger)horizonalOffset % (NSUInteger)screenWidth / screenWidth;
    NSUInteger focusIndex = (horizonalOffset + screenWidth / 2) / screenWidth;
    
    if (horizonalOffset != focusIndex * screenWidth) {
        NSUInteger animationIndex = horizonalOffset > focusIndex * screenWidth ? focusIndex + 1: focusIndex - 1;
        if (focusIndex > animationIndex) {offsetRatio = 1 - offsetRatio;}
        _scrollView(offsetRatio, focusIndex, animationIndex);
    }
    
    if (didScrollStop) {
        /*
         [_controllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
         if ([vc isKindOfClass:[UITableViewController class]]) {
         ((UITableViewController *)vc).tableView.scrollsToTop = (idx == focusIndex);
         }
         }];
         */
        
        _changeIndex(focusIndex);
    }
}


@end
