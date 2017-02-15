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
- (instancetype)initWithPostType:(PostViewType)type
{
    if (self = [super init]) {
        //设置文章类型，仅仅高级API支持
        _postViewType = type;
        _postsModelArray = [[NSMutableArray alloc]initWithCapacity:2];
        _postApiType = APITypeJSON; // 默认JSON API
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置界面
    [self setTableViewWithPostType:self.postViewType];
    // 请求数据
//    [self beginRequestRecentPost];
    
}

// 开始请求最近的文章数据
-(void)beginRequestRecentPost{
    
    [WBSUtils showProgressMessage:@"加载中..."];
    [[WBSNetRequest sharedRequest]getRecentPostsWithQueryString:nil success:^(NSArray *postsModelArray, NSInteger postsCount) {
        //
        self.postsModelArray = [[NSMutableArray alloc]initWithArray:postsModelArray];
        self.tableView.dataArray = self.postsModelArray;
        [self.tableView reloadData];
        [WBSUtils dismissHUD];
    } failure:^(NSError *error) {
        //
        [WBSUtils showErrorMessage:@"数据请求异常"];
    }];
}

// 设置界面要展示的tableView
-(void)setTableViewWithPostType:(PostViewType)type{
    switch (type) {
        case PostResultTypeRecent:
        {
            // 博客文章界面
            WBSPostTableView *postTableView = [[WBSPostTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain withAPiType:self.postApiType];
            postTableView.selectDelegate = self;
            [self.view addSubview:postTableView];
            self.tableView = postTableView;
            break;
        }
            
        case PostResultTypeSearch:
        {
            
            break;
        }
            
        case PostResultTypeTag:
        {
            
            break;
        }
            
        case PostResultTypeCategory:
        {
            
            break;
        }
            
        default:
            break;
    }
    
    
    
}


/// PostTableViewDelegate 点击文章cell的方法
-(void)PostTableViewCellDidSelectWithTableView:(WBSPostTableView *)tableView andPostModel:(WBSPostModel *)postModel{
    
    WBSPostDetailViewController *detailVC = [[WBSPostDetailViewController alloc] initWithPost:postModel];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}



@end










