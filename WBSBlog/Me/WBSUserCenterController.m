//
//  WBSUserCenterController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSUserCenterController.h"
#import "WBSApiInfo.h"
#import "WBSLoginNavViewController.h"
#import "TGBlogJsonApi.h"
#import "WBSErrorViewController.h"
#import "UIImageView+WebCache.h"

static NSString *kUserInfoCellID = @"userInfoCell";
#define HeaderViewHeight    160
#define portraitHeight      60

@interface WBSUserCenterController ()

//@property (nonatomic, readonly, assign) int64_t myID;
@property (nonatomic, strong) NSMutableArray *noticeCounts;

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *headerNameLabel;
@property (nonatomic, strong) UIImageView *myQRCodeButton; //!< 二维码

@property (nonatomic, strong) WBSUserModel *userModel;  //!< <#属性注释#>
@property (nonatomic, strong) NSArray *titleArray;  //!< <#属性注释#>
@property (nonatomic, strong) NSArray *infoArray;  //!< <#属性注释#>

@end

@implementation WBSUserCenterController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.titleArray = @[@"账号：",@"昵称：", @"姓名：", @"主页：", @"邮箱：",@"注册时间："];
    if ([SingleObject shareSingleObject].isLogin) {
        self.userModel = [SingleObject shareSingleObject].user;
    }else if (![SingleObject shareSingleObject].isLogin){
        // 未登录
        [WBSUtils goToLoginViewController];
        return;
    }else{
        // 游客状态
    }
    NSString *registeredTimeStr = checkNull(self.userModel.registered);
    if (registeredTimeStr.length>1) {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* registeredDate = [inputFormatter dateFromString:registeredTimeStr];
        registeredTimeStr = [dateFormatter stringFromDate:registeredDate];
        
    }
    self.infoArray = @[checkNull(self.userModel.username),checkNull(self.userModel.displayname),[NSString stringWithFormat:@"%@·%@",checkNull(self.userModel.firstname),checkNull(self.userModel.lastname)],checkNull(self.userModel.url),checkNull(self.userModel.email),checkNull(registeredTimeStr)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([SingleObject shareSingleObject].isGuest){
        [WBSUtils showErrorMessage:@"请登录!!"];
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUserInfoCellID];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_sidebar"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMenuButton)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.bounces = NO;
    self.navigationItem.title = @"我";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderViewHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_Width, HeaderViewHeight)];
    KLog(@"tableView.tableHeaderView.height is %lf",tableView.tableHeaderView.height);
    HeaderView.backgroundColor = [UIColor infosBackViewColor];
    
    
    UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_Width, HeaderViewHeight)];
    headerImage.clipsToBounds = YES;
    headerImage.userInteractionEnabled = YES;
    headerImage.contentMode = UIViewContentModeScaleAspectFill;
    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);
    NSString *imageName = @"user-background";
    if (screenWidth.intValue < 400) {
        imageName = [NSString stringWithFormat:@"%@-%@", imageName, screenWidth];
    }
    headerImage.image = [UIImage imageNamed:imageName];
    [HeaderView addSubview:headerImage];
    
    
    _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake((KSCREEN_Width-portraitHeight)/2, (HeaderViewHeight-portraitHeight)/2-10, portraitHeight, portraitHeight)];
    _portraitImageView.contentMode = UIViewContentModeScaleAspectFit;
    // 头像写死
    _portraitImageView.image = [UIImage imageNamed:@"default_portrait"];
    [_portraitImageView setCornerRadius:(portraitHeight)/2];
    _portraitImageView.userInteractionEnabled = YES;
    [_portraitImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortraitAction)]];
    [HeaderView addSubview:_portraitImageView];
    
    //取第一个作者
    
    _headerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, HeaderViewHeight -30, KSCREEN_Width-80, 20)];
    _headerNameLabel.font = [UIFont boldSystemFontOfSize:18];
    _headerNameLabel.textColor = [UIColor colorWithHex:0xEEEEEE];
    _headerNameLabel.textAlignment = NSTextAlignmentCenter;
    _headerNameLabel.text = [NSString stringWithFormat:@"%@",self.userModel.displayname]?:@"";
    [HeaderView addSubview:_headerNameLabel];
    
    
    return HeaderView;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *titleAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor]};
    
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.titleArray[indexPath.row]attributes:titleAttributes];
    
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:self.infoArray[indexPath.row]]];
    
    cell.textLabel.attributedText = [attributedText copy];
    cell.textLabel.textColor = [UIColor titleColor];
    cell.backgroundColor = [UIColor cellsColor];
    
    return cell;
    
}

- (void)onClickMenuButton
{
    KLog(@"点击了一个没实现的按钮");
}

// 点击头像
-(void)tapPortraitAction{
    
}


@end
