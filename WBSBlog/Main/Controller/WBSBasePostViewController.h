//
//  WBSBasePostViewController.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSLastCell.h"
#import "TGMetaWeblogApi.h"
#import "TGBlogJsonApi.h"

@interface WBSBasePostViewController : UITableViewController

@property (nonatomic, copy) NSString * (^generateURL)(NSUInteger page);
@property (nonatomic, copy) void (^tableWillReload)(NSUInteger responseObjectsCount);
@property (nonatomic, copy) void (^didRefreshSucceed)();

//MetaWeblogApi 或者 JSON API
@property(nonatomic,strong) id api;

//刷新分分页数据（需要在子类重写）
- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh;

@property (nonatomic, assign) BOOL shouldFetchDataAfterLoaded;
@property (nonatomic, assign) BOOL needRefreshAnimation;
@property (nonatomic, assign) BOOL needCache;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, assign) int allCount;
@property (nonatomic, strong) WBSLastCell *lastCell;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSUInteger page;

/// 拉取更多数据
- (void)fetchMoreDataOfView;

/// 下拉刷新 当前界面
- (void)refreshCurrentView;

@end
