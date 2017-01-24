//
//  WBSBasePostViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSBasePostViewController.h"
#import "WBSLoginViewController.h"
#import "TGBlogJsonApi.h"
#import "AppDelegate.h"

@interface WBSBasePostViewController ()

@property (nonatomic, assign) BOOL refreshInProgress;

@end

@implementation WBSBasePostViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _objects = [NSMutableArray new];
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
        _objects = [NSMutableArray new];
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
    WBSApiInfo *apiInfo = [WBSConfig getAuthoizedApiInfo];
    BOOL isguest = [WBSUtils getBooltforKey:WBSGuestLoginMode];
    if(!apiInfo && !isguest){
        KLog(@"登陆超时，请重新登录。");
        WBSLoginViewController *loginCtrl =[[WBSLoginViewController alloc]init];
        
        [self.navigationController pushViewController:loginCtrl animated:YES];
        
        return;
    }
    
    //===================================
    //如果登陆成功，尝试初始化api
    //===================================
    
    //根据设置确认要选择的api
    if ([WBSConfig isJSONAPIEnable]) {
        _api = [self setupJSONApi:apiInfo];
    }else{
        _api = [self setupApi:apiInfo];
    }

    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.backgroundColor = [UIColor themeColor];
    
    _lastCell = [WBSLastCell new];
    [_lastCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fetchMore)]];
    self.tableView.tableFooterView = _lastCell;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    _label = [UILabel new];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.font = [UIFont boldSystemFontOfSize:14];
    
    if (!_shouldFetchDataAfterLoaded) {return;}
    if (_needRefreshAnimation) {
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
    }
    
    [self fetchObjectsOnPage:0 refresh:NO];
}

#pragma mark - Private
/**
 *  初始化MetaWeblog API
 *
 *  @param apiInfo apiInfo
 *
 *  @return API状态
 */
- (id)setupApi:(WBSApiInfo *)apiInfo {
    NSString *xmlrpc =apiInfo.baseURL;
    if (xmlrpc) {
        NSString *username = apiInfo.username;
        NSString *password = apiInfo.password;
        if (username && password) {
            self.api = [TGMetaWeblogAuthApi apiWithXMLRPCURL:[NSURL URLWithString:xmlrpc] username:username password:password];
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
 *
 *  @param apiInfo apiInfo
 *
 *  @return JSON API实例
 */
-(id)setupJSONApi:(WBSApiInfo *)apiInfo{
    TGBlogJsonApi *feedParser = [[TGBlogJsonApi alloc]init];
    if (feedParser) {
        return feedParser;
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

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



#pragma mark - 刷新

- (void)refresh
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
        [self fetchMore];
    }
}

- (void)fetchMore
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
