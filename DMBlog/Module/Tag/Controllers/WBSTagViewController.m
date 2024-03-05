//
//  WBSMessageViewController.m
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "WBSTagViewController.h"
#import "AFNetworking.h"
#import "WBSHomePostViewController.h"
#import "DMNetRequest.h"
#import "WBSTagModel.h"

@interface WBSTagViewController ()
@property (strong, nonatomic) WWTagsCloudView* tagCloudView;
@property (strong, nonatomic) NSArray* tagModelArray;
@property (nonatomic, strong) NSMutableArray *tagsTitleArray;  //!< tagsTitle
@end

@implementation WBSTagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取并生成标签
    [self requestTagsFromSite];
}

- (void) viewDidAppear:(BOOL)animated{
    
    CGRect tagFrame = _tagCloudView.frame;
    KLog(@"%g", tagFrame.origin.y);
    //修复返回时错位问题
    if (tagFrame.origin.y == 20) {
        tagFrame.origin.y -= 60;
    }
    _tagCloudView.frame = tagFrame;
    self.tagsTitleArray = [[NSMutableArray alloc]initWithCapacity:5];
    self.tagModelArray = [NSArray array];
}


/**
 *  标签点击事件
 *
 *  @param tagIndex 点击的索引
 */
-(void)tagClickAtIndex:(NSInteger)tagIndex
{
//    NSInteger tagID = [self getIDByTag:self.tagModelArray[tagIndex]];
//    KLog(@"%ld",tagID);
    
    //    WBSHomePostViewController *postCtl = [[WBSHomePostViewController alloc]initWithPostType:PostTypePost];
    //    postCtl.title = [NSString stringWithFormat:@"当前标签:%@",_tags[tagIndex]];
    //    //设置结果类型为标签文章，并且设置标签ID
    //    postCtl.postResultType = PostResultTypeTag;
    //    postCtl.tagId = tagID;
    //    [self.navigationController pushViewController:postCtl animated:YES];
}

- (void)refresh:(id)sender {
    [_tagCloudView reloadAllTags];
}

#pragma 生成标签
/**
 *  生成标签
 */
-(void)showTagsView{
    NSArray* colors = @[[UIColor colorWithRed:0 green:0.63 blue:0.8 alpha:1], [UIColor colorWithRed:1 green:0.2 blue:0.31 alpha:1], [UIColor colorWithRed:0.53 green:0.78 blue:0 alpha:1], [UIColor colorWithRed:1 green:0.55 blue:0 alpha:1]];
    NSArray* fonts = @[[UIFont systemFontOfSize:12], [UIFont systemFontOfSize:16], [UIFont systemFontOfSize:20]];
    //初始化
    _tagCloudView = [[WWTagsCloudView alloc] initWithFrame:CGRectMake(0.0, 20.0, self.view.frame.size.width, self.view.frame.size.height) andTags:self.tagModelArray andTagColors:colors andFonts:fonts andParallaxRate:1.7 andNumOfLine:10];
    _tagCloudView.delegate = self;
    [self.view addSubview:_tagCloudView];
}

# pragma mark 加载标签
/**
 *  加载标签，仅仅JSON API才支持
 */
-(void)requestTagsFromSite{
    
    [DMSUtils showProgressMessage:@"标签加载中..."];
    [[DMNetRequest sharedRequest]getTag_WithSuccess:^(NSArray *tagsArray, NSInteger tagsCount) {
        //成功
        if (tagsArray.count>1) {
            NSMutableArray *tempTitlteArr = [[NSMutableArray alloc]initWithCapacity:tagsCount];
            self.tagModelArray = tagsArray;
            for (WBSTagModel *tagModel in tagsArray) {
                NSString *title = tagModel.title;
                [tempTitlteArr addObject:title];
            }
            self.tagsTitleArray = tempTitlteArr;
            [self showTagsView];
            
            [DMSUtils dismissHUD];
        }else{
            [DMSUtils showErrorMessage:@"数据异常，稍后重试"];
        }
    } failure:^(NSError *error) {
        // 失败
        [DMSUtils dismissHUD];
    }];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *baseURL = [userDefaults objectForKey:WBSSiteBaseURL];
//    
//    NSString *requestURL = [NSString stringWithFormat:@"%@/api/get_tag_index/",baseURL];
//    
//    //创建加载中
//    [DMSUtils showStatusMessage:@"标签加载中..."];
//    KLog(@"tag request URL:%@",requestURL);
//    //获取作者数据
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //刷新数据
//            //KLog(@"JSON: %@", responseObject);
//            KLog(@"status:%@",[result objectForKey:@"status"]);
//            NSString *status = [result objectForKey:@"status"];
//            if ([status isEqualToString:@"ok"]) {
//                //获取数据
//                NSArray *detailedTags = result[@"tags"];
//                //按标签文章倒叙排序
//                _sortedTags = [detailedTags sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
//                    NSInteger count1 = [[obj1 valueForKey:@"post_count"] integerValue];
//                    NSInteger count2 = [[obj2 valueForKey:@"post_count"] integerValue];
//                    if (count1 < count2)
//                        return NSOrderedDescending;
//                    else if (count1 > count2)
//                        return NSOrderedAscending;
//                    else
//                        return NSOrderedSame;
//                }];
//                
//                KLog(@"tags get ok :%lu",(unsigned long)_sortedTags.count);
//                self.tagModelArray = [NSMutableArray array];
//                for (id tempTag in _sortedTags) {
//                    KLog(@"%@",[tempTag valueForKey:@"title"]);
//                    [self.tagArray addObject:[tempTag valueForKey:@"title"]];
//                }
//                //生成标签
//                [self showTagsView];
//                
//                //取消加载中
//                [DMSUtils dismissHUD];
//            }else{
//                KLog(@"tags get error");
//            }
//        });
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [DMSUtils showErrorMessage:[NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]]];
//        KLog(@"Error fetching authors: %@", [error localizedDescription]);
//        
//    }];
    
}



@end
