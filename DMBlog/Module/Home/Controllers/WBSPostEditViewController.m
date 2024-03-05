//
//  WBSPostEditViewController.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "WBSPostEditViewController.h"
#import "WBSPostDetailViewController.h"

@interface WBSPostEditViewController ()<UIScrollViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIScrollView          *scrollView;
@property (nonatomic, strong) UIView                *contentView;
@property (nonatomic, strong) WBSPlaceholderTextView   *edittingArea;

@end

@implementation WBSPostEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //工具栏
    self.navigationItem.title = @"撰写文章";
    //预览
    UIBarButtonItem *preview = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(preview)];
    //发布
    UIBarButtonItem *publish = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(publish)];
    NSArray *rightItems = [NSArray arrayWithObjects:publish,preview,nil];
    self.navigationItem.rightBarButtonItems = rightItems;
    [self initSubViews];
    [self setLayout];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [_edittingArea.delegate textViewDidChange:_edittingArea];
//    
//    [_edittingArea becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark 视图相关
- (void)initSubViews
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator   = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = YES;
    [self.view addSubview:_scrollView];
    
    _contentView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    _contentView.userInteractionEnabled = YES;
    [_scrollView addSubview:_contentView];
    _scrollView.contentSize = _contentView.bounds.size;
    
    _edittingArea = [[WBSPlaceholderTextView alloc] initWithPlaceholder:@"今天你发布博客了吗？"];
    _edittingArea.delegate = self;
    _edittingArea.placeholderFont = [UIFont systemFontOfSize:17];
    _edittingArea.returnKeyType = UIReturnKeySend;
    _edittingArea.enablesReturnKeyAutomatically = YES;
    _edittingArea.scrollEnabled = NO;
    _edittingArea.font = [UIFont systemFontOfSize:18];
    _edittingArea.autocorrectionType = UITextAutocorrectionTypeNo;
    [_contentView addSubview:_edittingArea];
    
    
}

- (void)setLayout
{
    for (UIView *view in _contentView.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    NSDictionary *views = NSDictionaryOfVariableBindings(_edittingArea, _contentView);
    
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_edittingArea]-8-|" options:0 metrics:nil views:views]];
}


/**
 *  预览
 */
-(void)preview{
    KLog(@"文章预览。");
    WBSPostDetailViewController *detailsViewController = [[WBSPostDetailViewController alloc] initWithPost:_post];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

-(void)publish{
    //修改文章
    if (self.post) {
        KLog(@"正在修改文章...");
    }
    else{
        KLog(@"正在发布文章...");
    }
}

@end
