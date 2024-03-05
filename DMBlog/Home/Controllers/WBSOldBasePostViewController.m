//
//  WBSOldBasePostViewController.m
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "WBSOldBasePostViewController.h"
#import "WBSUserLoginViewController.h"
#import "WBSJsonApi.h"
#import "DMAppDelegate.h"

@interface WBSOldBasePostViewController ()

@property (nonatomic, assign) BOOL refreshInProgress;

@end

@implementation WBSOldBasePostViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _postArray = [[NSMutableArray alloc]initWithCapacity:1];
        _page = 0;
        _needRefreshAnimation = YES;
        _shouldFetchDataAfterLoaded = YES;
    }
    
    return self;
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        _postArray = [[NSMutableArray alloc]initWithCapacity:1];
        _page = 0;
        _needRefreshAnimation = YES;
        _shouldFetchDataAfterLoaded = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    //===================================
    //检测登陆状态
    //===================================
    if(![SingleObject shareSingleObject].isLogin && ![SingleObject shareSingleObject].isGuest){
        KLog(@"未登录 非游客模式 登陆超时，请重新登录。");
        WBSUserLoginViewController *loginVC =[[WBSUserLoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
        
        return;
    }
    
    //===================================
    //如果登陆成功，尝试初始化api
    //===================================
    
    //根据设置确认要选择的api
    WBSApiInfo *apiInfo = [WBSConfig getAuthoizedApiInfo];
    if ([WBSConfig isJSONAPIEnable]) {
        _api = [self setupJSONApi:apiInfo];
    }else{
        _api = [self setupXMLRPCApi:apiInfo];
    }
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.backgroundColor = [UIColor themeColor];
    
    _lastCell = [[WBSLastCell alloc]init];
    [_lastCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fetchMoreDataOfView)]];
    self.tableView.tableFooterView = _lastCell;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshCurrentView) forControlEvents:UIControlEventValueChanged];
    
    _desLabel = [[UILabel alloc]init];
    _desLabel.numberOfLines = 0;
    _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _desLabel.font = [UIFont boldSystemFontOfSize:14];
    
    if (!_shouldFetchDataAfterLoaded) {return;}
    if (_needRefreshAnimation) {
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
    }
    
    [self fetchObjectsOnPage:0 refresh:NO];
}


#pragma mark - Private
/**
 *  初始化 XMLRPC API
 */
- (id)setupXMLRPCApi:(WBSApiInfo *)apiInfo {
    NSString *xmlrpc = apiInfo.siteURL;
    if (xmlrpc) {
        NSString *username = apiInfo.username;
        NSString *password = apiInfo.password;
        if (username && password) {
            self.api = [WordPressApi apiWithXMLRPCURL:[NSURL URLWithString:xmlrpc] username:username password:password];
        }
    }
    
    //api初始化成功
    if (_api) {
        return _api;
    }
    return nil;
}

/**
 *  初始化JSON API
 */
-(id)setupJSONApi:(WBSApiInfo *)apiInfo{
    
    WBSJsonApi *postApi = [[WBSJsonApi alloc]init];
    if (postApi) {
        return postApi;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}



#pragma mark - 刷新

- (void)refreshCurrentView
{
    _refreshInProgress = NO;
    
    if (!_refreshInProgress) {
        _refreshInProgress = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self fetchObjectsOnPage:0 refresh:YES];
            _refreshInProgress = NO;
        });
    }
}

#pragma mark - 上拉加载更多

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        [self fetchMoreDataOfView];
    }
}

- (void)fetchMoreDataOfView
{
    if (!_lastCell.shouldResponseToTouch) {return;}
    
    _lastCell.status = LastCellStatusLoading;
    [self fetchObjectsOnPage:++_page refresh:NO];
}


#pragma mark - 请求数据

- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh
{
    NSAssert(false, @"Over ride in subclasses");
}



@end
