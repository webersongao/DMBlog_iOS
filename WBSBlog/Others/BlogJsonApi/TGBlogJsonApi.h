//
//  TGBlogJsonApi.h
//  TGBlogJsonApi
//
//  Created by Terwer Green Dobrincu on 17/07/14.
//  Copyright (c) 2014 Terwer Green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "TGPost.h"
#import "TGCategory.h"
#import "TGTag.h"
#import "TGComment.h"

@interface TGBlogJsonApi : NSObject

- (void)parseURL:(NSString*)urlString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock;

@property (nonatomic) NSInteger postsCount;
@property (nonatomic) NSArray *postsArray;
@property (nonatomic) NSInteger pagesCount;

@end
