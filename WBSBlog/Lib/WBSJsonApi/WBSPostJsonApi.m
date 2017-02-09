//
//  WBSPostJsonApi.m
//  WBSJsonApi
//
//  Created by Weberson on 2017/1/26.
//  该API 需要 Json Api 插件支持 https://wordpress.org/plugins/json-api/
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSPostJsonApi.h"
#import "WBSPostModel.h"
#import "WBSCategoryModel.h"
#import "WBSTagModel.h"
#import "WBSCommentModel.h"


@implementation WBSPostJsonApi


/**
 *  1、Post
 */
#pragma mark  2️⃣ Post
/// 获取文章 getPosts
- (void)getPostsWithURL:(NSString*)urlString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    //
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //Trigger failure block
        failureBlock(error);
        
    }];
    
}


/**
 *  2、 Setting
 */
#pragma mark  3️⃣ Setting




@end
