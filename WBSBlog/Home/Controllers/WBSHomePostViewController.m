//
//  WBSHomeViewController.m
//  WBSBlog
//
//  Created by Weberson on 2017/2/13.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSHomePostViewController.h"
#import "WBSPostTableView.h"
#import "WBSNetRequest.h"
#import "WBSPostDetailViewController.h"

@interface WBSHomePostViewController ()<PostTableViewDelegate>

@property (nonatomic, assign) PostViewType postViewType;  //!< 文章页面类型
@property (nonatomic, assign) PostAPIType postApiType;  //!< API类型
@property (nonatomic, strong) NSMutableArray *postsModelArray;  //!< 文章数据源

@end

@implementation WBSHomePostViewController


/**
 *  根据文章类型初始化
 *
 *  @param type 文章类型
 *
 *  @return 当前对象
 */
//- (instancetype)initWithPostType:(PostViewType)type
-(instancetype)init{
    self = [super init];
    if (self) {
        _postViewType = PostViewTypePost;
        _postsModelArray = [[NSMutableArray alloc]initWithCapacity:10];
        _postApiType = APITypeJSON; // 默认JSON API
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置界面
    [self setTableViewWithPostType:self.postViewType];
    
}


// 设置界面要展示的tableView
-(void)setTableViewWithPostType:(PostViewType)type{
    switch (type) {
        case PostViewTypePost:
        {
            // 博客文章界面
            WBSPostTableView *postTableView = [[WBSPostTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain withAPiType:self.postApiType];
            postTableView.selectDelegate = self;
            [self.view addSubview:postTableView];
            self.tableView = postTableView;
            break;
        }
            
        case PostViewTypeSearch:
        {
            
            break;
        }
            
        case PostViewTypeTag:
        {
            
            break;
        }
            
        case PostViewTypeCategory:
        {
            
            break;
        }
            
        default:
            break;
    }
    
    
    
}




/// 下拉刷新 最新数据
- (void)downToRefreshLatestDataWithHeaderAction {
    [super downToRefreshLatestDataWithHeaderAction];
    //    [WBSUtils showProgressMessage:@"加载中..."];
    [[WBSNetRequest sharedRequest]getPosts_WithCount:self.postCount+10 page:0 postType:JSONAPIPostTypePost IgnoreStickyPosts:YES success:^(NSArray *postsArray, NSInteger postsCount, BOOL isIgnoreStickyPosts) {
        ////
        if (postsCount) {
            for (WBSPostModel *postModel in [postsArray reverseObjectEnumerator]) {
                [self.postsModelArray insertObject:postModel atIndex:0];
            }
            self.tableView.dataArray = self.postsModelArray;
            [self.tableView reloadData];
            //        [WBSUtils dismissHUD];
            self.postCount+=postsCount;
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        // 失败
        [WBSUtils showErrorMessage:@"数据请求异常"];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

/// 上拉加载更多
- (void)upToRefreshLatestDataWithFooterAction {
    [super upToRefreshLatestDataWithFooterAction];
    KLog(@"002 - 上拉加载 ");
    [WBSUtils showProgressMessage:@"加载中..."];
    [[WBSNetRequest sharedRequest]getPosts_WithCount:self.postCount+10 page:0 postType:JSONAPIPostTypePost IgnoreStickyPosts:YES success:^(NSArray *postsArray, NSInteger postsCount, BOOL isIgnoreStickyPosts) {
        //// 成功
        if (postsCount) {
            self.postsModelArray = [[NSMutableArray alloc]initWithArray:postsArray];
            self.tableView.dataArray = self.postsModelArray;
            [self.tableView reloadData];
            [WBSUtils dismissHUD];
            self.postCount+=postsCount;
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        // 失败
        [WBSUtils showErrorMessage:@"数据请求异常"];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


/// PostTableViewDelegate 点击文章cell的方法
-(void)PostTableViewCellDidSelectWithTableView:(WBSPostTableView *)tableView andPostModel:(WBSPostModel *)postModel{
    
    WBSPostDetailViewController *detailVC = [[WBSPostDetailViewController alloc] initWithPost:postModel];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}









@end










