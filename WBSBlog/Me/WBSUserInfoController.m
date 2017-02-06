//
//  WBSUserInfoController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSUserInfoController.h"
#import "WBSApiInfo.h"
#import "WBSLoginNavViewController.h"
#import "UIImageView+Util.h"
#import "TGBlogJsonApi.h"
#import "WBSErrorViewController.h"

static NSString *kUserInfoCellID = @"userInfoCell";

@interface WBSUserInfoController ()

//@property (nonatomic, readonly, assign) int64_t myID;
@property (nonatomic, strong) NSMutableArray *noticeCounts;

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *myQRCodeButton;

@property (nonatomic, strong) UIButton *creditsBtn;
@property (nonatomic, strong) UIButton *collectionsBtn;
@property (nonatomic, strong) UIButton *followsBtn;
@property (nonatomic, strong) UIButton *fansBtn;

@property (nonatomic, assign) int badgeValue;

@end

@implementation WBSUserInfoController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![SingleObject shareSingleObject].isLogin) {
        [WBSUtils goToLoginViewController];
        return;
    }else if ([SingleObject shareSingleObject].isGuest){
        [WBSUtils showErrorMessage:@"请登录!!"];
    }else{
        
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
    [_portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortraitAction)]];
    [header addSubview:_portrait];
    
    //取第一个作者
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    _nameLabel.textColor = [UIColor colorWithHex:0xEEEEEE];
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.userModel.firstname,self.userModel.lastname]?:@"";
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
//    NSDictionary *author = _authors[0];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:title[indexPath.row]
                                                                                       attributes:titleAttributes];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@[
                                                                                        self.userModel.displayname?:@"",
                                                                                        [NSString stringWithFormat:@"%@ %@",self.userModel.lastname,self.userModel.firstname]?:@"",self.userModel.url?:@"",self.userModel.descriptions?:@""
                                                                                        ][indexPath.row]]];
    
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
