//
//  WBSUserCenterController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSUserCenterController.h"
#import "WBSApiInfo.h"
#import "WBSJsonApi.h"
#import "UIImageView+WebCache.h"
#import "WBSJsonRequest.h"

static NSString *kUserInfoCellID = @"userInfoCell";
#define HeaderViewHeight    160
#define footerViewHeight    250
#define portraitHeight      60

@interface WBSUserCenterController ()<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic, readonly, assign) int64_t myID;
@property (nonatomic, strong) NSMutableArray *noticeCounts;
@property (nonatomic, strong) UITableView *mainTableView;  //!< <#属性注释#>
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
    }
    // 初始化用户数据
    [self checkUserData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUserInfoCellID];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_sidebar"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMenuButton)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.navigationItem.title = @"用户中心";
}


/// 初始化用户数据
- (void)checkUserData {
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

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderViewHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return footerViewHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_Width, HeaderViewHeight)];
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
    
    // 作者昵称
    _headerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, HeaderViewHeight -40, KSCREEN_Width-60, 20)];
    _headerNameLabel.font = [UIFont boldSystemFontOfSize:18];
    _headerNameLabel.textColor = [UIColor colorWithHex:0xEEEEEE];
    _headerNameLabel.textAlignment = NSTextAlignmentCenter;
    _headerNameLabel.text = [NSString stringWithFormat:@"%@",self.userModel.displayname]?:@"";
    [HeaderView addSubview:_headerNameLabel];
    
    
    return HeaderView;
    
}

// footerView
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_Width, footerViewHeight)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 20)];
    titleLabel.text = @"个人说明：";
    [footerView addSubview:titleLabel];
    
    // 分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom +10, KSCREEN_Width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:lineView];
    
    // 文字
    UITextView *infotextView = [[UITextView alloc]initWithFrame:CGRectMake(titleLabel.left, lineView.bottom +10, KSCREEN_Width -(titleLabel.left*2), footerViewHeight -titleLabel.font.lineHeight -30)];
    infotextView.userInteractionEnabled = NO;
    infotextView.backgroundColor = [UIColor clearColor];
    infotextView.textAlignment =NSTextAlignmentLeft;
    infotextView.font = [UIFont systemFontOfSize:15];
    infotextView.text = self.userModel.descriptions;
    [footerView addSubview:infotextView];
    
    return footerView;
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
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
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

 /********************* 懒加载 *************************/
-(UITableView *)mainTableView{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}
@end
