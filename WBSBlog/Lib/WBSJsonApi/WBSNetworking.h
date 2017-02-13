//
//  WBSNetworking.h
//  WBSBlog
//
//  Created by Weberson on 2017/2/9.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface WBSClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end




@interface WBSNetworking : NSObject

///  GET 请求
+ (NSURLSessionDataTask *)GETRequest:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

///  POST 请求
+ (NSURLSessionDataTask *)POSTRequest:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
