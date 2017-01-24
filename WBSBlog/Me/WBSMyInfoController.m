//
//  WBSMyInfoController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSMyInfoController.h"
#import "WBSApiInfo.h"
#import "WBSLoginNavViewController.h"
#import "RESideMenu.h"
#import "UIImageView+Util.h"
#import "TGBlogJsonApi.h"
#import "WBSErrorViewController.h"



static NSString *kMyInfoCellID = @"myInfoCell";

@interface WBSMyInfoController ()

//@property (nonatomic, readonly, assign) int64_t myID;
@property (nonatomic, strong) NSMutableArray *noticeCounts;

@property (nonatomic,strong) NSArray *authors;

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *myQRCodeButton;

@property (nonatomic, strong) UIButton *creditsBtn;
@property (nonatomic, strong) UIButton *collectionsBtn;
@property (nonatomic, strong) UIButton *followsBtn;
@property (nonatomic, strong) UIButton *fansBtn;

@property (nonatomic, assign) int badgeValue;

@end

@implementation WBSMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMyInfoCellID];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMenuButton)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.bounces = NO;
    self.navigationItem.title = @"我";
}

- (void) viewDidAppear:(BOOL)animated{
    //非 JSON API不支持
    if (![WBSConfig isJSONAPIEnable]) {
        WBSErrorViewController *errorCtl = [[WBSErrorViewController alloc]init];
        [WBSUtils showApiNotSupported:self redirectTo:errorCtl];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *header = [UIImageView new];
    header.clipsToBounds = YES;
    header.userInteractionEnabled = YES;
    header.contentMode = UIViewContentModeScaleAspectFill;
    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);
    NSString *imageName = @"user-background";
    if (screenWidth.intValue < 400) {
        imageName = [NSString stringWithFormat:@"%@-%@", imageName, screenWidth];
    }
    header.image = [UIImage imageNamed:imageName];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, header.image.size.width, header.image.size.height)];
    view.backgroundColor = [UIColor infosBackViewColor];
    [header addSubview:view];
    
    _portrait = [UIImageView new];
    _portrait.contentMode = UIViewContentModeScaleAspectFit;
    [_portrait setCornerRadius:25];
    // 头像写死
//    [_portrait loadPortrait:[NSURL URLWithString:@"http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=433dd90830fa828bd17695e7c82f6d02/cb8065380cd7912368dec979ae345982b2b78085.jpg"]];
    _portrait.userInteractionEnabled = YES;
    [_portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortrait)]];
    [header addSubview:_portrait];
    
    //取第一个作者
    NSDictionary *author = _authors[0];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    _nameLabel.textColor = [UIColor colorWithHex:0xEEEEEE];
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@",[author objectForKey:@"first_name"],[author objectForKey:@"last_name"]]?:@"";
    [header addSubview:_nameLabel];
    
    for (UIView *view in header.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_portrait, _nameLabel);
    
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_portrait(50)]-8-[_nameLabel]-8-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_portrait(50)]" options:0 metrics:nil views:views]];
    
    [header addConstraint:[NSLayoutConstraint constraintWithItem:_portrait attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                          toItem:header attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    
    return header;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *titleAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor]};
    NSArray *title = @[@"昵称：", @"姓名：", @"主页：", @"描述："];
    
    //取第一个作者
    NSDictionary *author = _authors[0];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:title[indexPath.row]
                                                                                       attributes:titleAttributes];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@[
                                                                                        [author objectForKey:@"nickname"]?:@"",
                                                                                        [NSString stringWithFormat:@"%@ %@",[author objectForKey:@"first_name"],[author objectForKey:@"last_name"]]?:    @"",
                                                                                        [author objectForKey:@"url"]?:@"",
                                                                                        [author objectForKey:@"description"]?:@""
                                                                                        ][indexPath.row]]];
    
    cell.textLabel.attributedText = [attributedText copy];
    cell.textLabel.textColor = [UIColor titleColor];
    cell.backgroundColor = [UIColor cellsColor];
    
    return cell;
    
}

- (void)onClickMenuButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)tapPortrait{
    
}

#pragma mark 获取作者数据

/**
 *  加载列表数据
 *
 *  @param page    page
 *  @param refresh refresh
 */
- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh{
    
    //JSON API不支持
    if (![WBSConfig isJSONAPIEnable]) {
        WBSErrorViewController *errorCtl = [[WBSErrorViewController alloc]init];
        [WBSUtils showApiNotSupported:self redirectTo:errorCtl];
        return;
    }
    
    KLog(@"fetching autoer data...");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userDefaults objectForKey:WBSSiteBaseURL];

    NSString *requestURL = [NSString stringWithFormat:@"%@/get_author_index/",baseURL];
    
    //获取作者数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        
        //刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            //KLog(@"JSON: %@", responseObject);
            KLog(@"status:%@",[result objectForKey:@"status"]);
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"ok"]) {
                KLog(@"authors get ok");
                //处理刷新
                if (refresh) {
                    super.page = 0;
                    if (super.didRefreshSucceed) {
                        super.didRefreshSucceed();
                    }
                }
                
                //获取数据
                self.authors = [result objectForKey:@"authors"];
                
                //刷新数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    super.lastCell.status = LastCellStatusEmpty;
                    
                    if (self.refreshControl.refreshing) {
                        [self.refreshControl endRefreshing];
                    }
                    
                    [self.tableView reloadData];
                });
            }
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        KLog(@"Error fetching authors: %@", [error localizedDescription]);
        
        [WBSUtils showErrorMessage:[NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]]];
        super.lastCell.status = LastCellStatusError;
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        [self.tableView reloadData];
    }];
    
}


@end
