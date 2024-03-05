//
//  WBSBaseCoreApi.m
//  DMBlog
//
//  Created by WebersonGao on 2017/2/9.
//  该API 需要WordPress 的 Json Api  插件支持
//  Copyright © 2017年 WebersonGao. All rights reserved.
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
#import "WBSQueryModel.h"



@interface WBSBaseCoreApi ()

@end


@implementation WBSBaseCoreApi

// 版本信息 info -> Returns information about JSON API or detailed information about a specific controller
+ (void)get_JsonApi_Info_WithSiteURLStr:(NSString *)siteURLStr controllerStr:(NSString *)controllerStr success:(void (^)(id versionInfoModel))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *requestStr = [NSString stringWithFormat:@"%@/%@/%@/?controller=%@",siteURLStr,KBase_Api,KJsonApi_Versioninfo,controllerStr];
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
 *  1、Core  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  1️⃣ Post

/// get_recent_posts -> home page（eg:json=1） or any page by setting json=get_recent_posts
+ (void)get_recent_posts_WithSiteUrlStr:(NSString *)siteUrlString count:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType success:(void (^)(NSArray *postsModelArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getPostsURLStr = [NSString stringWithFormat:@"%@/%@/%@/?json=%@&page=%ld&count=%ld&post_type=%@",siteUrlString,KBase_Api,KBase_Get_recent_posts,KBase_Get_recent_posts,page?page:KPostPage,count?count:KPostCount,postType?postType:KPostType];
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
            NSMutableArray *allPosts = [[NSMutableArray alloc]initWithCapacity:postsCount];
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


/// get_posts   获取文章
+ (void)get_Posts_WithSiteUrlStr:(NSString *)siteUrlString count:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType IgnoreStickyPosts:(BOOL)isIgnoreStickyPosts success:(void (^)(NSArray *postsModelArray, NSInteger postsCount ,BOOL isIgnoreStickyPosts))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getPostsURLStr = [NSString stringWithFormat:@"%@/%@/%@/?count=%ld&page=%ld&post_type=%@&ignore_sticky_posts=%d",siteUrlString,KBase_Api,KBase_Get_posts,count?count:KPostCount,page?page:KPostPage,postType?postType:KPostType,isIgnoreStickyPosts];
    
    [WBSNetworking GETRequest:getPostsURLStr parameters:nil success:^(id responseObject) {
        // 成功
        NSInteger postsTotalCount = 0;
        NSInteger pagesCount = 0;
        NSArray * postsArray = [NSArray array];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            //Get posts count
            postsTotalCount = [responseObject[@"count_total"] integerValue];
            
            //Get pages count
            pagesCount = [responseObject[@"pages"] integerValue];
            
            // Query dict
            NSDictionary *queryDict = [responseObject objectForKey:@"query"];
            WBSQueryModel *queryModel = [WBSQueryModel QueryserModelWithDic:queryDict];
            
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
        if (count > postsTotalCount) {
            // 超过总文章数 返回空数组
            postsArray = [NSArray array];
        }
        successBlock(postsArray, postsArray.count,isIgnoreStickyPosts);
        
    } failure:^(NSError *error) {
        // 失败
        //Trigger failure block
        failureBlock(error);
    }];
    
}


/// get_post    获取指定文章
+ (void)get_post_WithSiteUrlStr:(NSString *)siteUrlString postId:(NSInteger)postId postSlug:(NSString *)postSlug postType:(NSString *)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getPostURLStr = [NSString stringWithFormat:@"%@/%@/%@/?post_id=%ld&post_slug=%@&post_type=%@",siteUrlString,KBase_Api,KBase_Get_post,postId,postSlug,postType?postType:KPostType];
    [WBSNetworking GETRequest:getPostURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
}


/// get_page
+ (void)get_page_WithSiteUrlStr:(NSString *)siteUrlString postId:(NSInteger)postId postSlug:(NSString *)postSlug children:(NSString *)children postType:(NSString *)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getPageURLStr = [NSString stringWithFormat:@"%@/%@/%@/?post_id=%ld&post_slug=%@&children=%@&post_type=%@",siteUrlString,KBase_Api,KBase_Get_page,postId,postSlug,children,postType?postType:KPostType];
    [WBSNetworking GETRequest:getPageURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
}


/// get_date_posts
+ (void)get_date_posts_WithSiteUrlStr:(NSString *)siteUrlString date:(NSString *)date count:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getDatePostsURLStr = [NSString stringWithFormat:@"%@/%@/%@/?date=%@&count=%ld&page=%ld&post_type=%@",siteUrlString,KBase_Api,KBase_Get_post,date,count,page,postType];
    [WBSNetworking GETRequest:getDatePostsURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
}


/// get_category_posts
+ (void)get_category_posts_WithSiteUrlStr:(NSString *)siteUrlString categoryId:(NSInteger)categoryId categorySlug:(NSString *)categorySlug count:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    
    NSString *getCategoryPostsURLStr = [NSString stringWithFormat:@"%@/%@/%@/?category_id=%ld&category_slug=%@&count=%ld&page=%ld&post_type=%@",siteUrlString,KBase_Api,KBase_Get_post,categoryId,categorySlug,count,page,postType];
    [WBSNetworking GETRequest:getCategoryPostsURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
}



/// get_tag_posts
+ (void)get_tag_posts_WithSiteUrlStr:(NSString *)siteUrlString tagId:(NSString *)tagId tagSlug:(NSString *)tagSlug count:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getTagPostsURLStr = [NSString stringWithFormat:@"%@/%@/%@/?tag_id=%@&tag_slug=%@&count=%ld&page=%ld&post_type=%@",siteUrlString,KBase_Api,KBase_Get_post,tagId,tagSlug,count,page,postType];
    [WBSNetworking GETRequest:getTagPostsURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}


/// get_author_posts
+ (void)get_author_posts_WithSiteUrlStr:(NSString *)siteUrlString searchQuery:(NSString *)searchQuery count:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getAuthorPostsURLStr = [NSString stringWithFormat:@"%@/%@/%@/?search=%@&count=%ld&page=%ld&post_type=%@",siteUrlString,KBase_Api,KBase_Get_post,searchQuery,count,page,postType];
    [WBSNetworking GETRequest:getAuthorPostsURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}


/// get_search_results
+ (void)get_search_results_WithSiteUrlStr:(NSString *)siteUrlString authorId:(NSString *)authorId authorSlug:(NSString *)authorSlug count:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getSearchPostsURLStr = [NSString stringWithFormat:@"%@/%@/%@/?author_id=%@&author_slug=%@&count=%ld&page=%ld&post_type=%@",siteUrlString,KBase_Api,KBase_Get_post,authorId,authorSlug,count,page,postType];
    [WBSNetworking GETRequest:getSearchPostsURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
}


/// get_date_index
+ (void)get_date_index_WithSiteUrlStr:(NSString *)siteUrlString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getDateIndexURLStr = [NSString stringWithFormat:@"%@/%@/%@/",siteUrlString,KBase_Api,KBase_Get_date_index];
    [WBSNetworking GETRequest:getDateIndexURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}


/// get_category_index
+ (void)get_category_index_WithSiteUrlStr:(NSString *)siteUrlString parent:(NSInteger)parent success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getCategoryIndexURLStr = [NSString stringWithFormat:@"%@/%@/%@/?parent=%ld",siteUrlString,KBase_Api,KBase_Get_date_index,parent];
    [WBSNetworking GETRequest:getCategoryIndexURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}


/// get_tag_index
+ (void)get_tag_index_WithSiteUrlStr:(NSString *)siteUrlString success:(void (^)(NSArray *tagsArray, NSInteger tagsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getTagIndexURLStr = [NSString stringWithFormat:@"%@/%@/%@/",siteUrlString,KBase_Api,KBase_Get_tag_index];
    [WBSNetworking GETRequest:getTagIndexURLStr parameters:nil success:^(id responseObject) {
        //成功
        NSInteger tagCount = 0;
        NSMutableArray *tagMutableArr = [[NSMutableArray alloc]initWithCapacity:5];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            tagCount = (NSInteger)[responseObject objectForKey:@"count"];
            NSArray *tagDictArr = [responseObject objectForKey:@"tags"];
            for (NSDictionary * tagDict in tagDictArr) {
                
                WBSTagModel *tagModel = [WBSTagModel TagModelWithDictionary:tagDict];
                [tagMutableArr addObject:tagModel];
            }
        }
        successBlock(tagMutableArr,tagCount);
    } failure:^(NSError *error) {
        // 失败
        failureBlock(error);
    }];
    
    
}


/// get_author_index
+ (void)get_author_index_WithSiteUrlStr:(NSString *)siteUrlString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getAuthorIndexURLStr = [NSString stringWithFormat:@"%@/%@/%@/",siteUrlString,KBase_Api,KBase_Get_date_index];
    [WBSNetworking GETRequest:getAuthorIndexURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}

/// get_page_index
+ (void)get_page_index_WithSiteUrlStr:(NSString *)siteUrlString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getPageIndexURLStr = [NSString stringWithFormat:@"%@/%@/%@/",siteUrlString,KBase_Api,KBase_Get_date_index];
    [WBSNetworking GETRequest:getPageIndexURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}


/// get_nonce
+ (void)get_nonce_WithSiteUrlStr:(NSString *)siteUrlString controller:(NSString *)controllerStr method:(NSString *)methodStr success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getNonceURLStr = [NSString stringWithFormat:@"%@/%@/%@/?controller=%@&method=%@",siteUrlString,KBase_Api,KBase_Get_date_index,controllerStr,methodStr];
    [WBSNetworking GETRequest:getNonceURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}


/**
 *  2、 Posts  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  2️⃣ Posts

/// create_post
/***
 @required:
 nonce - available from the "get_nonce" method (call with vars controller=posts and method=create_post)
 @Optional:
 status - sets the post status ("draf"t" or "publish"), default is "draft"
 title - the post title
 content - the post content
 author - the post's author (login name), default is the current logged in user
 categories - a comma-separated list of categories (URL slugs)
 tags - a comma-separated list of tags (URL slugs)
 attachment - a file upload field an attachment to be stored with your new post.
 **/
+ (void)create_post_WithSiteUrlStr:(NSString *)siteUrlString controller:(NSString *)controllerStr method:(NSString *)methodStr success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getNonceURLStr = [NSString stringWithFormat:@"%@/%@/%@/?controller=%@&method=%@",siteUrlString,KBase_Api,KBase_Get_date_index,controllerStr,methodStr];
    [WBSNetworking POSTRequest:getNonceURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}


/// update_post
/***
 @required:
 nonce - available from the get_nonce method (call with vars controller=posts and method=update_post)
 id or post_id - set to the post's ID
 slug or post_slug - set to the post's URL slug
 @Optional:
 status - sets the post status ("draft" or "publish"), default is "draft"
 title - the post title
 content - the post content
 author - the post's author (login name), default is the current logged in user
 categories - a comma-separated list of categories (URL slugs)
 tags - a comma-separated list of tags (URL slugs)
 attachment - a file upload field an attachment to be stored with your new post.
 **/
+ (void)update_post_WithSiteUrlStr:(NSString *)siteUrlString controller:(NSString *)controllerStr method:(NSString *)methodStr success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getNonceURLStr = [NSString stringWithFormat:@"%@/%@/%@/?controller=%@&method=%@",siteUrlString,KBase_Api,KBase_Get_date_index,controllerStr,methodStr];
    [WBSNetworking POSTRequest:getNonceURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}


/// delete_post
/**
 @required:
 nonce - available from the get_nonce method (call with vars controller=posts and method=delete_post)
 @required: One of the following
 id or post_id - set to the post's ID
 slug or post_slug - set to the post's URL slug
 **/
+ (void)delete_post_WithSiteUrlStr:(NSString *)siteUrlString controller:(NSString *)controllerStr method:(NSString *)methodStr success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getNonceURLStr = [NSString stringWithFormat:@"%@/%@/%@/?controller=%@&method=%@",siteUrlString,KBase_Api,KBase_Get_date_index,controllerStr,methodStr];
    [WBSNetworking POSTRequest:getNonceURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}





/**
 *  3、 Respond  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  3️⃣ Respond


/// submit_comment
/**
 @Required:
 post_id - which post to comment on
 name - the commenter's name
 email - the commenter's email address
 content - the comment content
 @Optional:
 redirect - redirect instead of returning a JSON object
 redirect_ok - redirect to a specific URL when the status value is ok
 redirect_error - redirect to a specific URL when the status value is error
 redirect_pending - redirect to a specific URL when the status value is pending
 ---->Notes:
 Custom status values
 pending - assigned if the comment submission is pending moderation
 **/
+ (void)submit_comment_WithSiteUrlStr:(NSString *)siteUrlString controller:(NSString *)controllerStr method:(NSString *)methodStr success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getNonceURLStr = [NSString stringWithFormat:@"%@/%@/%@/?controller=%@&method=%@",siteUrlString,KBase_Api,KBase_Get_date_index,controllerStr,methodStr];
    [WBSNetworking POSTRequest:getNonceURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}






/**
 *  4、 Widgets  需要JsonApi 插件 https://wordpress.org/plugins/json-api/
 */
#pragma mark  4️⃣ Widgets



/// get_sidebar
/**
 @Required:
 sidebar_id - the name or number of the sidebar to retrieve
 **/
+ (void)get_sidebar_WithSiteUrlStr:(NSString *)siteUrlString sidebar_id:(NSString *)sidebarId success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *getSidebarURLStr = [NSString stringWithFormat:@"%@/%@/%@/?sidebar_id=%@",siteUrlString,KBase_Api,KBase_Get_date_index,sidebarId];
    [WBSNetworking GETRequest:getSidebarURLStr parameters:nil success:^(id responseObject) {
        //成功
    } failure:^(NSError *error) {
        // 失败
    }];
    
    
}





@end




































