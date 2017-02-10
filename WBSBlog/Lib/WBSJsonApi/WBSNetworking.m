//
//  WBSNetworking.m
//  WBSBlog
//
//  Created by Weberson on 2017/2/9.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSNetworking.h"

@implementation WBSClient

+ (instancetype)sharedClient {
    static WBSClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WBSClient alloc] initWithBaseURL:nil];
        //告诉AFN，下载下来的数据是JSON，直接解析返回给我们
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", nil];
    });
    
    return _sharedClient;
}
@end


@implementation WBSNetworking


/// 常用
+ (NSURLSessionDataTask *)GETRequest:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionDataTask * sessionDataTask = [[WBSClient sharedClient] GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        @try {
            success(responseObject);
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
    
    return sessionDataTask;
    
}


/// 常用
+ (NSURLSessionDataTask *)POSTRequest:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *URLStr = [NSString stringWithFormat:@""];
    NSURLSessionDataTask *sessionDataTask = [[WBSClient sharedClient] POST:URLStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        @try {
            // 将成功请求请求的数据 返回
            success(responseObject);
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
    
    return sessionDataTask;
}

@end
