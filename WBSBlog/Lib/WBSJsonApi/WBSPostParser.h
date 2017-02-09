//
//  WBSPostParser.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/1.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSPostParser : NSObject


/// WBSFeedParser GetRecentPosts 
- (void)getRecentPostsWithURL:(NSString*)urlString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

@property (nonatomic) NSInteger postsCount;
@property (nonatomic) NSArray *postsArray;
@property (nonatomic) NSInteger pagesCount;

@end
