//
//  TGBlogJsonApi.m
//  TGBlogJsonApi
//
//  Created by Terwer Green on 17/07/14.
//  Copyright (c) 2014 Terwer Green. All rights reserved.
//

#import "TGBlogJsonApi.h"
#import "TGPost+SDPostFromDictionary.h"
#import "TGCategory+TGCategoryFromDictionary.h"
#import "TGComment+TGCommentFromDictionary.h"
#import "TGTag+TGTagFromDictionary.h"

@implementation TGBlogJsonApi

- (void)parseURL:(NSString*)urlString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
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
                
                TGPost *currentPost = [TGPost SDPostFromDictionary:eachPost];
                
                //Fetch posts category
                NSMutableArray *allCategories = [[NSMutableArray alloc]init];
                NSArray *fetchedCategoriesArray = eachPost[@"categories"];
                for (NSDictionary *eachCategory in fetchedCategoriesArray) {
                    
                    TGCategory *currentCategory = [TGCategory SDCategoryFromDictionary:eachCategory];
                    [allCategories addObject:currentCategory];
                }
                currentPost.categoriesArray = [allCategories copy];
                
                //Fetch posts tags
                NSMutableArray *allTags = [[NSMutableArray alloc]init];
                NSArray *fetchedTagsArray = eachPost[@"tags"];
                for (NSDictionary *eachTag in fetchedTagsArray) {
                    
                    TGTag *currentTag = [TGTag SDTagFromDictionary:eachTag];
                    [allTags addObject:currentTag];
                }
                currentPost.tagsArray = [allTags copy];
                currentPost.authorInfo = eachPost[@"author"];
                
                //Fetch posts comments
                NSMutableArray *allComments = [[NSMutableArray alloc]initWithCapacity:[eachPost[@"comment_count"] integerValue]];
                NSArray *fetchedCommentsArray = eachPost[@"comments"];
                for (NSDictionary *eachComment in fetchedCommentsArray) {
                    
                    TGComment *currentComment = [TGComment SDCommentFromDictionary:eachComment];
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



@end
