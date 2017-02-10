//
//  WBSBaseCoreApi.m
//  WBSBlog
//
//  Created by Weberson on 2017/2/9.
//  该API 需要WordPress 的 Json Api  插件支持
//  Copyright © 2017年 Weberson. All rights reserved.
//
// 该文件为 JSON Api 的 Core Widgets Widgets Widgets 四个Controllers的基本api 实现代码
// 关于 JsonApi 的 Controllers的说明参看 https://wordpress.org/plugins/json-api/other_notes/#1.2.-Controllers


#import "WBSBaseCoreApi.h"
#import "WBSPostModel.h"
#import "WBSCategoryModel.h"
#import "WBSTagModel.h"
#import "WBSCommentModel.h"

@interface WBSBaseCoreApi ()

@end


@implementation WBSBaseCoreApi

// 获取JSON API 插件的功能版本信息
-(void)GetJsonApiVersionInfo{
//http://www.swiftartisan.com/api/info/
//    WBSNetworking GETRequest:<#(NSString *)#> parameters:<#(id)#> success:<#^(id responseObject)success#> failure:<#^(NSError *error)failure#>
}




/**
 *  1、Post  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  1️⃣ Post

/// 获取文章 getPosts
- (void)getPostsWithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getPostsURLStr = [NSString stringWithFormat:@"%@/api/get_recent_posts/?%@",siteUrlString,queryString];
    [WBSNetworking GETRequest:getPostsURLStr parameters:nil success:^(id responseObject) {
        // 成功
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            //Get posts count
            _postsCount = [responseObject[@"count_total"] integerValue];
            
            //Get pages count
            _pagesCount = [responseObject[@"pages"] integerValue];
            
            //Fetch posts
            NSMutableArray *allPosts = [[NSMutableArray alloc]initWithCapacity:[responseObject[@"count_total"] integerValue]];
            NSArray *fetchedPostsArray = responseObject[@"posts"];
            for (NSDictionary *eachPost in fetchedPostsArray) {
                
                WBSPostModel *currentPost = [WBSPostModel PostModelWithDictionary:eachPost];
                
                //Fetch posts category
                NSMutableArray *allCategories = [[NSMutableArray alloc]init];
                NSArray *fetchedCategoriesArray = eachPost[@"categories"];
                for (NSDictionary *eachCategory in fetchedCategoriesArray) {
                    
                    WBSCategoryModel *currentCategory = [WBSCategoryModel CategoryModelWithDictionary:eachCategory];
                    [allCategories addObject:currentCategory];
                }
                currentPost.categoriesArray = [allCategories copy];
                
                //Fetch posts tags
                NSMutableArray *allTags = [[NSMutableArray alloc]init];
                NSArray *fetchedTagsArray = eachPost[@"tags"];
                for (NSDictionary *eachTag in fetchedTagsArray) {
                    
                    WBSTagModel *currentTag = [WBSTagModel TagModelWithDictionary:eachTag];
                    [allTags addObject:currentTag];
                }
                currentPost.tagsArray = [allTags copy];
                currentPost.authorInfo = eachPost[@"author"];
                
                //Fetch posts comments
                NSMutableArray *allComments = [[NSMutableArray alloc]initWithCapacity:[eachPost[@"comment_count"] integerValue]];
                NSArray *fetchedCommentsArray = eachPost[@"comments"];
                for (NSDictionary *eachComment in fetchedCommentsArray) {
                    
                    WBSCommentModel *currentComment = [WBSCommentModel CommentModelWithDictionary:eachComment];
                    [allComments addObject:currentComment];
                }
                currentPost.commentsArray = [allComments copy];
                currentPost.commentsCount = [eachPost[@"comment_count"] integerValue];
                currentPost.status = responseObject[@"comment_status"];
                
                [allPosts addObject:currentPost];
            }
            _postsArray = [allPosts copy];
        }
        
        //Trigger success block
        successBlock(self.postsArray, self.postsArray.count);
        
    } failure:^(NSError *error) {
        // 失败
        //Trigger failure block
        failureBlock(error);
    }];
    
}


/**
 *  2、 Setting  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  2️⃣ Setting





@end
