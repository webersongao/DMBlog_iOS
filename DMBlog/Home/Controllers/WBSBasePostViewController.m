//
//  WBSBasePostViewController.m
//  DMBlog
//
//  Created by WebersonGao on 2017/2/13.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//

#import "WBSBasePostViewController.h"

@interface WBSBasePostViewController ()

@end

@implementation WBSBasePostViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downToRefreshLatestDataWithHeaderAction];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self upToRefreshLatestDataWithFooterAction];
    }];
    
    if (self.tableView.dataArray.count) {
        
    }else{
        // 首次进入 刷新数据
        [self.tableView.mj_header beginRefreshing];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postCount = 0;
    
}



/// 下拉刷新 最新数据
- (void)downToRefreshLatestDataWithHeaderAction {
    KLog(@"WBSBasePostViewController - 下拉刷新 ");
    
}

/// 上拉加载更多
- (void)upToRefreshLatestDataWithFooterAction {
    KLog(@"WBSBasePostViewController - 上拉加载 ");
    
}


@end














