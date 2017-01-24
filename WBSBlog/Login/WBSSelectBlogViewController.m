//
//  WBSSelectBlogViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSSelectBlogViewController.h"

@interface WBSSelectBlogViewController () <UITableViewDelegate, UITableViewDataSource>

/**
 *  博客类型下拉框
 */
@property(nonatomic, strong) UITableView *mainTableView;
/**
 *  选择博客类型数据
 */
@property(nonatomic, strong) NSMutableArray *blogTypeArray;

/**
 *  xmlrpc链接地址  前缀
 */
@property(nonatomic, strong) NSString *xmlrpcURLPrefix;

/**
 *  xmlrpc链接地址  后缀
 */
@property(nonatomic, strong) NSString *xmlrpcURLSuffix;

@end

@implementation WBSSelectBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化导航栏
    self.navigationItem.title = @"选择博客类型";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doSelectBlog)];
    self.view.backgroundColor = [UIColor themeColor];
    
    //初始化视图和布局
    [self initSubviews];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)initSubviews {
    //计算位置
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    
    //设置代理
    [_mainTableView setDataSource:self];
    [_mainTableView setDelegate:self];
    
    //添加控件
    [self.view addSubview:_mainTableView];
}

- (void)setLayout {
    
    
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.blogTypeArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CELL";
    UITableViewCell *blogCell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (blogCell == nil) {
        blogCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    blogCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    blogCell.textLabel.text = [self.blogTypeArray objectAtIndex:indexPath.row];
    
    return blogCell;
    
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KLog(@"You selected this: %@", self.blogTypeArray[indexPath.row]);
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSString stringWithFormat:@"%d", NO] forKey:WBSIs_JSONAPI];
    [def synchronize];
    
    switch (indexPath.row) {
        case 0:
            [WBSUtils showSuccessMessage:@"Wordpress"];
            //            _xmlrpcURLSuffix = @"http://www.webersongao.com/xmlrpc.php";
            _xmlrpcURLPrefix = KWordPress;
            _xmlrpcURLSuffix = @"xmlrpc.php";
            [self doSelectBlog];
            break;
        case 1:
            [WBSUtils showErrorMessage:@"ZBlog"];
            //            _xmlrpcURLSuffix = @"http://www.webersongao.com:8080/xmlrpc";
            _xmlrpcURLPrefix = KZBlog;
            _xmlrpcURLSuffix = @"xmlrpc";
            [self doSelectBlog];
            break;
        case 2:
            [WBSUtils showStatusMessage:@"Cnblogs"];
            //            _xmlrpcURLSuffix = @"http://www.cnblogs.com/weberson/services/metaweblog.aspx";
            _xmlrpcURLPrefix = @"http://www.cnblogs.com";
            _xmlrpcURLSuffix = @"services/metaweblog.aspx";
            [self doSelectBlog];
            break;
        case 3:
            [WBSUtils showSuccessMessage:@"OSChina"];
            _xmlrpcURLPrefix = KOtherBlog;
            _xmlrpcURLSuffix = @"http://my.oschina.net/action/xmlrpc";
            [self doSelectBlog];
            break;
        case 4:
             [WBSUtils showSuccessMessage:@"163博客"];
            _xmlrpcURLPrefix = KOtherBlog;
            _xmlrpcURLSuffix = @"http://os.blog.163.com/api/xmlrpc/metaweblog/";
            [self doSelectBlog];
            break;
        case 5:
             [WBSUtils showSuccessMessage:@"51CTO"];
            _xmlrpcURLPrefix = KOtherBlog;
            _xmlrpcURLSuffix = @"http://weberson.blog.51cto.com/xmlrpc.php";
            [self doSelectBlog];
            break;
        case 6:
             [WBSUtils showSuccessMessage:@"Sina博客"];
            _xmlrpcURLPrefix = KOtherBlog;
            _xmlrpcURLSuffix = @"http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php";
            [self doSelectBlog];
            break;
        case 7: {
             [WBSUtils showSuccessMessage:@"JSON API"];
            // JSON API 的方式 暂时未修改
            _xmlrpcURLSuffix = @"http://www.webersongao.com/api/";
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:[NSString stringWithFormat:@"%d", YES] forKey:WBSIs_JSONAPI];
            [def synchronize];
            [self doSelectBlog];
            break;
        }
            
        default:
            KLog(@"Other");
            _xmlrpcURLSuffix = @"";
            [self doSelectBlog];
            break;
    }
    
}

/**
 *  选中博客类型处理
 */
- (void)doSelectBlog {
    if (!_xmlrpcURLSuffix) {
        [WBSUtils showErrorMessage:@"请选择博客类型"];
        return;
    }
    KLog(@"选择了博客：　%@", _xmlrpcURLSuffix);
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:_xmlrpcURLSuffix forKey:WBSXmlrpcSubffix];
    [def setObject:_xmlrpcURLPrefix forKey:WBSXmlrpcPrefix];
    [def synchronize];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  博客类型数据源懒加载
 *
 *  @return 博客数据源数组
 */
- (NSArray *)blogTypeArray {
    //初始化添加博客类型数据源
    if (!_blogTypeArray) {
        NSArray *tempArray = @[@"Wordpress", @"ZBlog", @"Cnblogs", @"OSChina", @"163博客", @"51CTO", @"新浪博客", @"JSON API", @"Other"];
        _blogTypeArray = [NSMutableArray arrayWithArray:tempArray];
    }
    return _blogTypeArray;
}

@end





