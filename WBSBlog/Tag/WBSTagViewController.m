//
//  WBSMessageViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSTagViewController.h"
#import "AFNetworking.h"
#import "WBSHomePostViewController.h"

@interface WBSTagViewController ()
@property (strong, nonatomic) WWTagsCloudView* tagCloud;
@property (strong, nonatomic) NSMutableArray* tags;
@property (strong, nonatomic) NSArray *sortedTags;
@end

@implementation WBSTagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor themeColor];
    self.navigationItem.title = @"标签";
    
    //JSON API不支持
    if (![WBSConfig isJSONAPIEnable]) {
        [WBSUtils showErrorMessage:@"ApiNotSupport"];
        return;
    }
    
    //获取并生成标签
    [self fetchTags];
}

- (void) viewDidAppear:(BOOL)animated{

    CGRect tagFrame = _tagCloud.frame;
    KLog(@"%g", tagFrame.origin.y);
    //修复返回时错位问题
    if (tagFrame.origin.y == 20) {
        tagFrame.origin.y -= 60;
    }
    _tagCloud.frame = tagFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  标签点击事件
 *
 *  @param tagIndex 点击的索引
 */
-(void)tagClickAtIndex:(NSInteger)tagIndex
{
    NSInteger tagID = [self getIDByTag:_tags[tagIndex]];
    KLog(@"%ld",tagID);
    
    WBSHomePostViewController *postCtl = [[WBSHomePostViewController alloc]initWithPostType:PostTypePost];
    postCtl.title = [NSString stringWithFormat:@"当前标签:%@",_tags[tagIndex]];
    //设置结果类型为标签文章，并且设置标签ID
    postCtl.postResultType = PostResultTypeTag;
    postCtl.tagId = tagID;
    [self.navigationController pushViewController:postCtl animated:YES];
}

/**
 *  根据标签内容获取标签ID
 *
 *  @param tag 标签文本
 *
 *  @return 标签ID
 */
-(NSInteger)getIDByTag:(NSString *)tag{
    NSInteger result;
    for (id tempTag in _sortedTags) {
        if ([[tempTag objectForKey:@"title"] isEqualToString:tag]) {
            result = [[tempTag objectForKey:@"id"]integerValue];
            return result;
        }
    }
    
    return  0;
}

- (void)refresh:(id)sender {
    [_tagCloud reloadAllTags];
}

#pragma 生成标签
/**
 *  生成标签
 */
-(void)drawTags{
    NSArray* colors = @[[UIColor colorWithRed:0 green:0.63 blue:0.8 alpha:1], [UIColor colorWithRed:1 green:0.2 blue:0.31 alpha:1], [UIColor colorWithRed:0.53 green:0.78 blue:0 alpha:1], [UIColor colorWithRed:1 green:0.55 blue:0 alpha:1]];
    NSArray* fonts = @[[UIFont systemFontOfSize:12], [UIFont systemFontOfSize:16], [UIFont systemFontOfSize:20]];
    //初始化
    _tagCloud = [[WWTagsCloudView alloc] initWithFrame:CGRectMake(0.0, 20.0, self.view.frame.size.width, self.view.frame.size.height)
                                               andTags:_tags                                          andTagColors:colors
                                              andFonts:fonts
                                       andParallaxRate:1.7
                                          andNumOfLine:10];
    _tagCloud.delegate = self;
    [self.view addSubview:_tagCloud];
}

# pragma mark 加载标签
/**
 *  加载标签，仅仅JSON API才支持
 */
-(void)fetchTags{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userDefaults objectForKey:WBSSiteBaseURL];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/get_tag_index/",baseURL];
    
    //创建加载中
    [WBSUtils showStatusMessage:@"标签加载中..."];
    KLog(@"category request URL:%@",requestURL);
    //获取作者数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新数据
            //KLog(@"JSON: %@", responseObject);
            KLog(@"status:%@",[result objectForKey:@"status"]);
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"ok"]) {
                //获取数据
                NSArray *detailedTags = result[@"tags"];
                //按标签文章倒叙排序
                _sortedTags = [detailedTags sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSInteger count1 = [[obj1 valueForKey:@"post_count"] integerValue];
                    NSInteger count2 = [[obj2 valueForKey:@"post_count"] integerValue];
                    if (count1 < count2)
                        return NSOrderedDescending;
                    else if (count1 > count2)
                        return NSOrderedAscending;
                    else
                        return NSOrderedSame;
                }];
                
                KLog(@"tags get ok :%lu",(unsigned long)_sortedTags.count);
                _tags = [NSMutableArray array];
                for (id tempTag in _sortedTags) {
                    KLog(@"%@",[tempTag valueForKey:@"title"]);
                    [_tags addObject:[tempTag valueForKey:@"title"]];
                }
                //生成标签
                [self drawTags];
                
                //取消加载中
                [WBSUtils dismissHUD];
            }else{
                KLog(@"tags get error");
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WBSUtils showErrorMessage:[NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]]];
        KLog(@"Error fetching authors: %@", [error localizedDescription]);
        
    }];
}



@end
