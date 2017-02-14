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
#import "WBSVersioInfoModel.h"
#import "WBSAuthorModel.h"


@interface WBSBaseCoreApi ()

@end


@implementation WBSBaseCoreApi

// 版本信息 info
+ (void)GetJsonApiVersionInfoWithSiteURLStr:(NSString *)siteURLStr success:(void (^)(id versionInfoModel))successBlock failure:(void (^)(NSError *error))failureBlock{
    //http://www.swiftartisan.com/api/info/
    NSString *requestStr = [NSString stringWithFormat:@"%@/%@/%@",siteURLStr,KAPI_base_URL,KBase_Versioninfo];
    [WBSNetworking GETRequest:requestStr parameters:nil success:^(id responseObject) {
        //成功
        WBSVersioInfoModel *VersioInfoModel = [[WBSVersioInfoModel alloc]init];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            VersioInfoModel = [WBSVersioInfoModel VersioInfoModelWithDictionary:responseObject];
        }
        successBlock(VersioInfoModel);
    } failure:^(NSError *error) {
        // 失败
        failureBlock(error);
    }];
}




/**
 *  1、Post  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  1️⃣ Post

/// get_recent_posts
+ (void)get_recent_posts_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsModelArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getPostsURLStr = [NSString stringWithFormat:@"%@/api/get_recent_posts/?%@",siteUrlString,queryString];
    [WBSNetworking GETRequest:getPostsURLStr parameters:nil success:^(id responseObject) {
        // 成功
        NSInteger postsCount = 0;
        NSInteger pagesCount = 0;
        NSArray * postsArray = [NSArray array];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            //Get posts count
            postsCount = [responseObject[@"count_total"] integerValue];
            
            //Get pages count
            pagesCount = [responseObject[@"pages"] integerValue];
            
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
                
                NSDictionary *authorDict = eachPost[@"author"];
                WBSAuthorModel *authorModel = [WBSAuthorModel AuthorModelWithDictionary:authorDict];
                currentPost.authorModel = authorModel;
                
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
            postsArray = [allPosts copy];
        }
        
        //Trigger success block
        successBlock(postsArray, postsArray.count);
        
    } failure:^(NSError *error) {
        // 失败
        //Trigger failure block
        failureBlock(error);
    }];
    
}


/// 获取文章 get_posts
+ (void)get_Posts_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSArray *postsModelArray, NSInteger postsCount ,BOOL isIgnoreStickyPosts))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getPostsURLStr = [NSString stringWithFormat:@"%@/api/get_recent_posts/?%@",siteUrlString,queryString];
    [WBSNetworking GETRequest:getPostsURLStr parameters:nil success:^(id responseObject) {
        // 成功
        NSInteger postsCount = 0;
        NSInteger pagesCount = 0;
        NSArray * postsArray = [NSArray array];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            //Get posts count
            postsCount = [responseObject[@"count_total"] integerValue];
            
            //Get pages count
            pagesCount = [responseObject[@"pages"] integerValue];
            
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
                
                NSDictionary *authorDict = eachPost[@"author"];
                WBSAuthorModel *authorModel = [WBSAuthorModel AuthorModelWithDictionary:authorDict];
                currentPost.authorModel = authorModel;
                
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
            postsArray = [allPosts copy];
        }
        
        // 是否忽略 置顶文章
        NSDictionary *queryDict = responseObject[@"query"];
        NSString *IgnoreStickyPostsStr = [queryDict objectForKey:@"ignore_sticky_posts"];
        BOOL isIgnoreStickyPosts = YES;
        if (![IgnoreStickyPostsStr isEqualToString:@"true"]) {
            isIgnoreStickyPosts = NO;
        }
        //Trigger success block
        successBlock(postsArray, postsArray.count,isIgnoreStickyPosts);
        
    } failure:^(NSError *error) {
        // 失败
        //Trigger failure block
        failureBlock(error);
    }];
    
}


//// 版本信息 info
//+(void)getVersionInfoWithSiteURLStr:(NSString *)siteURLStr success:(void (^)(NSDictionary * versionInfoDict))successBlock failure:(void (^)(NSError *error))failureBlock{
//    //http://www.swiftartisan.com/api/info/
//    NSString *requestStr = [NSString stringWithFormat:@"%@/%@/%@",siteURLStr,KAPI_base_URL,KBase_Versioninfo];
//    [WBSNetworking GETRequest:requestStr parameters:nil success:^(id responseObject) {
//        //成功
//        NSDictionary *infoDataDict = [NSDictionary dictionary];
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            infoDataDict = (NSDictionary *)responseObject;
//        }
//        //Trigger success block
//        successBlock(infoDataDict);
//    } failure:^(NSError *error) {
//        // 失败
//        failureBlock(error);
//    }];
//}
//
//
//
//
///**
// *  1、Post  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
// */
//#pragma mark  1️⃣ Post
//
///// get_recent_posts
//+ (void)get_recent_posts_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSDictionary * responseDict))successBlock failure:(void (^)(NSError *error))failureBlock{
//    
//    NSString *getPostsURLStr = [NSString stringWithFormat:@"%@/%@/%@/?%@",siteUrlString,KAPI_base_URL,KBase_Get_recent_posts,queryString];
//    [WBSNetworking GETRequest:getPostsURLStr parameters:nil success:^(id responseObject) {
//        
//        NSDictionary *postDataDict = [NSDictionary dictionary];
//        // 成功
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            postDataDict = (NSDictionary *)responseObject;
//        }
//        //Trigger success block
//        successBlock(postDataDict);
//        
//    } failure:^(NSError *error) {
//        // 失败
//        //Trigger failure block
//        failureBlock(error);
//    }];
//    
//}
//
//
///// 获取文章 get_posts
//+ (void)get_Posts_WithSiteUrlStr:(NSString *)siteUrlString queryString:(NSString *)queryString success:(void (^)(NSDictionary * responseDict))successBlock failure:(void (^)(NSError *error))failureBlock{
//    
//    NSString *getPostsURLStr = [NSString stringWithFormat:@"%@/%@/%@/?%@",siteUrlString,KAPI_base_URL,KBase_Get_posts,queryString];
//    
//    [WBSNetworking GETRequest:getPostsURLStr parameters:nil success:^(id responseObject) {
//        
//        NSDictionary *postDataDict = [NSDictionary dictionary];
//        // 成功
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            postDataDict = (NSDictionary *)responseObject;
//        }
//        //Trigger success block
//        successBlock(postDataDict);
//        
//    } failure:^(NSError *error) {
//        // 失败
//        //Trigger failure block
//        failureBlock(error);
//    }];
//    
//}



/**
 *  2、 Setting  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  2️⃣ Setting





@end
