//
//  WBSOldBasePostViewController.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSLastCell.h"
#import "WordPressApi.h"
#import "WBSJsonApi.h"

@interface WBSOldBasePostViewController : UITableViewController

@property (nonatomic, copy) NSString * (^generateURL)(NSUInteger page);
@property (nonatomic, copy) void (^tableWillReload)(NSUInteger responseObjectsCount);
@property (nonatomic, copy) void (^didRefreshSucceed)();

//XMLRPC API 或者 JSON API
@property(nonatomic,strong) id api;

//刷新分分页数据（需要在子类重写）
- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh;

@property (nonatomic, assign) BOOL shouldFetchDataAfterLoaded;
@property (nonatomic, assign) BOOL needRefreshAnimation;
@property (nonatomic, assign) BOOL needCache;
@property (nonatomic, strong) NSMutableArray *postArray;  /// 内容数组
@property (nonatomic, assign) int allCount;
@property (nonatomic, strong) WBSLastCell *lastCell;
@property (nonatomic, strong) UILabel *desLabel; /// 预览文字
@property (nonatomic, assign) NSUInteger page;

/// 拉取更多数据
- (void)fetchMoreDataOfView;

/// 下拉刷新 当前界面
- (void)refreshCurrentView;

@end
