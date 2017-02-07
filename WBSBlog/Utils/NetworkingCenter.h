//
//  NetworkingCenter.h
//  WBSBlog
//
//  Created by Weberson on 15/11/18.
//  Copyright (c) 2015年 Weberson. All rights reserved.
//

/**
 *  http请求
 */
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkingCenter : AFHTTPRequestOperationManager

/*-------------------- 加header的 get OR post请求 -----------------*/
/**
 *  带有sk的网络请求(GET方式)
 *
 *  @param urlString  url
 *  @param parameters get方式一般为nil
 *  @param success    网络请求成功
 *  @param noLigin    用户未登录的处理
 *  @param failure    网络请求失败
 */
+ (AFHTTPRequestOperation *)GetWithHeader:(NSString *)urlString parameters:(id)parameters isShowHUB:(BOOL)show success:(void (^)(id responseObject))success noLogin:(void(^)())noLigin failure:(void (^)(NSError *error))failure;

/**
 *  带有sk的网络请求(POST方式)
 *
 *  @param urlString  url
 *  @param parameters post的参数
 *  @param success    网络请求成功
 *  @param noLigin    用户未登录的处理
 *  @param failure    网络请求失败
 */
//+ (AFHTTPRequestOperation *)PostWithHeader:(NSString *)urlString parameters:(id)parameters success:(void (^)(id responseObject))success noLogin:(void(^)())noLigin failure:(void (^)(NSError *error))failure;
+ (AFHTTPRequestOperation *)PostWithHeader:(NSString *)urlString parameters:(id)parameters isShowHUB:(BOOL)show success:(void (^)(id responseObject))success noLogin:(void(^)())noLigin failure:(void (^)(NSError *error))failure;


/*-------------------- 不加header  get OR post请求  -------------------*/
+ (AFHTTPRequestOperation *)GETRequest:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (AFHTTPRequestOperation *)POSTRequest:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/*---------------- 方便取消下载任务 ----------------*/
+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                     parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
