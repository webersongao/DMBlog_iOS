//
//  WBSRootTabBarController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSRootTabBarController.h"
#import "WBSOptionButton.h"
#include "RESideMenu.h"
#import "WBSPostViewController.h"
#import "WBSSwipableViewController.h"
#import "WBSTagViewController.h"
#import "WBSMyInfoController.h"
#import "WBSUtils.h"
#import "WBSPostEditViewController.h"
#import "WBSConfig.h"

@interface WBSRootTabBarController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, assign) BOOL isPressed;
@property (nonatomic, strong) NSMutableArray *optionButtons;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGGlyph length;

@end

@implementation WBSRootTabBarController

//创建博客视图控制器
-(WBSSwipableViewController *)createBlogViewController:(BOOL)isSearch{
    //全部
    WBSPostViewController *postViewCtl = [[WBSPostViewController alloc]initWithPostType:PostTypePost];
    //是否搜索
    if (isSearch) {
        postViewCtl.isSearch = YES;
        postViewCtl.postResultType = PostResultTypeSearch;
    }
    WBSSwipableViewController *blogSVC ;
    //由于metaWeblog api的限制，无法筛选出热门和置顶文章
    //JSON API才有页面，搜索没有页面
    if ([WBSConfig isJSONAPIEnable]&& !isSearch && [WBSConfig isShowPage]) {
        //最新
        UIViewController *pageViewCtl = [[WBSPostViewController alloc]initWithPostType:PostTypePage];
        postViewCtl.postResultType = PostResultTypeRecent;
        
        //博客
        blogSVC = [[WBSSwipableViewController alloc] initWithTitle:@"首页"
                                                      andSubTitles:@[@"文章",@"页面"]
                                                    andControllers:@[ postViewCtl,pageViewCtl]
                                                       underTabbar:YES];
    }else{
        blogSVC = [[WBSSwipableViewController alloc] initWithTitle:@"首页"
                                                      andSubTitles:nil
                                                    andControllers:@[ postViewCtl]
                                                       underTabbar:YES];
    }
    return blogSVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //博客
    WBSSwipableViewController *blogSVC = [self createBlogViewController:NO];
    
    //标签
    WBSTagViewController *tagCtl = [[WBSTagViewController alloc]init];
    
    //搜索
    WBSSwipableViewController *searchTableVC = [self createBlogViewController:YES];
    
    //我
    WBSMyInfoController *myInfoVC = [[WBSMyInfoController alloc]initWithStyle:UITableViewStyleGrouped];
    
    self.tabBar.translucent = NO;
    self.viewControllers = @[[self addNavigationItemForViewController:blogSVC withItembars:YES]];
    self.viewControllers = @[
                             [self addNavigationItemForViewController:blogSVC withItembars:YES],
                             [self addNavigationItemForViewController:tagCtl withItembars:YES],
                             [UIViewController new],
                             [self addNavigationItemForViewController:searchTableVC withItembars:YES],
                             [[UINavigationController alloc] initWithRootViewController:myInfoVC]
                             ];
    
    //底部中间按钮
    NSArray *titles = @[@"博客", @"标签", @"", @"搜索", @"我"];
    NSArray *images = @[@"tabbar-news", @"tabbar-tweet", @"blank", @"tabbar-discover", @"tabbar-me"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        if (!([images[idx] isEqualToString:@"blank"])) {
            [item setImage:[UIImage imageNamed:images[idx]]];
            [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
        }
    }];
    
    //禁用中间标签
    [self.tabBar.items[2] setEnabled:NO];
    //添加中间按钮
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tabbar-more"]];
    
    // 功能键相关
    _optionButtons = [NSMutableArray new];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;
    _length = 60;        // 圆形按钮的直径
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    NSArray *buttonTitles = @[@"文章", @"动态",@"相册", @"拍照", @"语音", @"视频"];
    NSArray *buttonImages = @[@"tweetEditing", @"scan",@"picture", @"shooting", @"sound",  @"search"];
    int buttonColors[] = {0xe69961, 0x0dac6b, 0x24a0c4, 0xe96360, 0x61b644, 0xf1c50e};
    
    for (int i = 0; i < 6; i++) {
        WBSOptionButton *optionButton = [[WBSOptionButton alloc] initWithTitle:buttonTitles[i]
                                                                         image:[UIImage imageNamed:buttonImages[i]]
                                                                      andColor:[UIColor colorWithHex:buttonColors[i]]];
        
        optionButton.frame = CGRectMake((_screenWidth/6 * (i%3*2+1) - (_length+16)/2),
                                        _screenHeight + 150 + i/3*100,
                                        _length + 16,
                                        _length + [UIFont systemFontOfSize:14].lineHeight + 24);
        [optionButton.button setCornerRadius:_length/2];
        
        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];
        
        [self.view addSubview:optionButton];
        [_optionButtons addObject:optionButton];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma nav
/**
 *  添加视图控制器到导航控制器
 *
 *  @param viewController 视图控制器
 *
 *  @param hasItembars    是否有工具项
 *
 *  @return 导航控制器
 */
- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController withItembars:(BOOL)hasItembars
{
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    if(hasItembars){
        viewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"]
                                                                                            style:UIBarButtonItemStylePlain
                                                                                           target:self action:@selector(onClickMenuButton)];
        ;
        
    }
    return navigationController;
}

/**
 *  左侧滑动展开
 */
-(void)onClickMenuButton{
    [self.sideMenuViewController presentLeftMenuViewController];
}

/**
 *  添加中间操作按钮
 *
 *  @param buttonImage 按钮图片
 */
-(void)addCenterButtonWithImage:(UIImage *)buttonImage
{
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 6, self.tabBar.frame.size.height - 4);
    
    _centerButton.frame = CGRectMake(origin.x - buttonSize.height/2, origin.y - buttonSize.height/2, buttonSize.height, buttonSize.height);
    
    [_centerButton setCornerRadius:buttonSize.height/2];
    [_centerButton setBackgroundColor:[UIColor colorWithHex:0x428bd1]];
    [_centerButton setImage:buttonImage forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:_centerButton];
}


/**
 *  中间按钮点击
 */
- (void)buttonPressed
{
    [self changeTheButtonStateAnimatedToOpen:_isPressed];
    
    _isPressed = !_isPressed;
}

/**
 *  中间按钮显示隐藏
 *
 *  @param isPressed 是否按下
 */
- (void)changeTheButtonStateAnimatedToOpen:(BOOL)isPressed
{
    if (isPressed) {
        // 隐藏撰写的按钮
        [self removeBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 6; i++) {
            UIButton *button = _optionButtons[i];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                                      _screenHeight + 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC * (6 - i)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    } else {
        // 显示撰写的按钮
        [self addBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 6; i++) {
            UIButton *button = _optionButtons[i];
            [self.view bringSubviewToFront:button];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                                      _screenHeight - 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC * (i + 1)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    }
}

/**
 *  添加操作按钮
 */
- (void)addBlurView
{
    _centerButton.enabled = NO;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect cropRect = CGRectMake(0, screenSize.height - 270, screenSize.width, screenSize.height);
    
    UIImage *originalImage = [self.view updateBlur];
    UIImage *croppedBlurImage = [originalImage cropToRect:cropRect];
    
    _blurView = [[UIImageView alloc] initWithImage:croppedBlurImage];
    _blurView.frame = cropRect;
    _blurView.userInteractionEnabled = YES;
    [self.view addSubview:_blurView];
    
    _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimView.backgroundColor = [UIColor blackColor];
    _dimView.alpha = 0.4;
    [self.view insertSubview:_dimView belowSubview:self.tabBar];
    
    [_blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    [_dimView  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    
    [UIView animateWithDuration:0.25f
                     animations:nil
                     completion:^(BOOL finished) {
                         if (finished) {_centerButton.enabled = YES;}
                     }];
}

/**
 *  删除操作按钮
 */
- (void)removeBlurView
{
    _centerButton.enabled = NO;
    
    self.view.alpha = 1;
    [UIView animateWithDuration:0.25f
                     animations:nil
                     completion:^(BOOL finished) {
                         if(finished) {
                             [_dimView removeFromSuperview];
                             _dimView = nil;
                             
                             [self.blurView removeFromSuperview];
                             self.blurView = nil;
                             _centerButton.enabled = YES;
                         }
                     }];
}


#pragma mark - 处理发布按钮对应的6个操作的点击事件

/**
 *  发布文章
 *
 *  @param recognizer recognizer
 */
- (void)onTapOptionButton:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.view.tag) {
        case 0: {
            NSLog(@"发布文字文章。");
            WBSPostEditViewController *postEditVC = [[WBSPostEditViewController alloc]init];
            UINavigationController *selectedNavCtl = (UINavigationController *)self.selectedViewController;
            [selectedNavCtl pushViewController:postEditVC animated:NO];
            break;
        }
        case 1: {
            NSLog(@"发布图片。");
            break;
        }
        case 2: {
            NSLog(@"拍照。");
            break;
        }
        case 3: {
            NSLog(@"语音");
            break;
        }
        case 4: {
            NSLog(@"扫一扫");
            break;
        }
        case 5: {
            NSLog(@"搜索");
            break;
        }
        default: break;
    }
    
    [self buttonPressed];
}

#pragma mark 显示隐藏Tabbar
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}

@end