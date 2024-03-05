//
//  NetworkingCenter.m
//  DMBlog
//
//  Created by WebersonGao on 15/11/18.
//  Copyright (c) 2015年 WebersonGao. All rights reserved.
//

#import "NetworkingCenter.h"
#import "CustomAlertView_Runtime.h"



@implementation NetworkingCenter

/*-------------------- 加header的 get OR post请求 -----------------*/
+ (NSURLSessionDataTask *)GetWithHeader:(NSString *)urlString parameters:(id)parameters isShowHUB:(BOOL)show success:(void (^)(id responseObject))success noLogin:(void(^)())noLigin failure:(void (^)(NSError *error))failure{
    
    if (![WBSUtils connectedToNetwork]) {
        //没网了....就别走了
        [CustomAlertView_Runtime initWithTitle:nil message:@"咿呀~网络连接失败啦" cancleButtonTitle:nil OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonIndex) {
        }];
        NSError *error = nil;
        failure(error);
        return nil;
    }
    KLog(@"这个网络的URL是: %@ ",urlString);
    
    NetworkingCenter *manger = [NetworkingCenter manager];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *sk = [WBSUtils getObjectforKey:@"sk"];
    //是否登录
    if ([WBSUtils isBlankString:sk] || [SingleObject shareSingleObject].isLogin == NO) {
        noLigin();
        return nil;
    }
    
    //sk不为空 开始网络吧
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (show) {
        [WBSUtils showProgressMessage:@"请稍后..."];
    }
    [manger.requestSerializer setValue:sk forHTTPHeaderField:@"sk"];
    NSURLSessionDataTask *sessionDataTask =[manger GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        @try {
            success(responseObject);
        }
        @catch (NSException *exception) {
            KLog(@"--%@",exception);
        }
        @finally {
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
    
    return sessionDataTask;
}


+ (NSURLSessionDataTask *)PostWithHeader:(NSString *)urlString parameters:(id)parameters isShowHUB:(BOOL)show success:(void (^)(id responseObject))success noLogin:(void(^)())noLigin failure:(void (^)(NSError *error))failure{
    
    if (![WBSUtils connectedToNetwork]) {
        //没网了....就别走了
        [CustomAlertView_Runtime initWithTitle:nil message:@"咿呀~网络连接失败啦" cancleButtonTitle:nil OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonIndex) {
        }];
        NSError *error = nil;
        failure(error);
        return nil;
    }
    KLog(@"这个网络的URL是: %@ ",urlString);
    NetworkingCenter *manger = [NetworkingCenter manager];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *sk = [WBSUtils getObjectforKey:@"sk"];
    
    //sk为空
    if ([WBSUtils isBlankString:sk] || [SingleObject shareSingleObject].isLogin == NO) {
        noLigin();
        return nil;
    }
    
    //sk不为空 开始网络吧
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (show) {
        [WBSUtils showProgressMessage:@"请稍后..."];
    }
    
    [manger.requestSerializer setValue:sk forHTTPHeaderField:@"sk"];
    
    NSURLSessionDataTask *sessionDataTask = [manger POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (show) {
            [WBSUtils dismissHUD];
        }
        @try {
            success(responseObject);
        }
        @catch (NSException *exception) {
            KLog(@"--%@",exception);
        }
        @finally {
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (show) {
            [WBSUtils dismissHUD];
        }
        failure(error);
    }];
    return sessionDataTask;
}

/*------------------ 不加header HTTP -----------------*/
/// 常用
+ (NSURLSessionDataTask *)GETRequest:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    if (![WBSUtils connectedToNetwork]) {
        //没网了....就别走了
        [CustomAlertView_Runtime initWithTitle:nil message:@"咿呀~网络连接失败啦" cancleButtonTitle:nil OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonIndex) {
        }];
        // 开启网络监测
        NSError *error = nil;
        failure(error);
        return nil;
    }
    KLog(@"这个网络的URL是: %@ ",URLString);
    NetworkingCenter *manger = [NetworkingCenter manager];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *sessionDataTask = [manger GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        @try {
            success(responseObject);
        }
        @catch (NSException *exception) {
            KLog(@"--%@",exception);
        }
        @finally {
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        KLog(@"网络错误%@",error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
    return sessionDataTask;
}


/// 常用
+ (NSURLSessionDataTask *)POSTRequest:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    if (![WBSUtils connectedToNetwork]) {
        //没网了....就别走了
        [CustomAlertView_Runtime initWithTitle:nil message:@"咿呀~网络连接失败啦" cancleButtonTitle:nil OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonIndex) {
        }];
        NSError *error = nil;
        failure(error);
        return nil;
    }
    KLog(@"这个网络的URL是: %@ ",URLString);
    
    NetworkingCenter *manger = [NetworkingCenter manager];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [WBSUtils showProgressMessage:@"请稍后..."];
    NSURLSessionDataTask *sessionDataTask = [manger POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        KLog(@"注册成功%@",responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [WBSUtils dismissHUD];
        @try {
            // 将成功请求请求的数据 返回
            success(responseObject);
        }
        @catch (NSException *exception) {
            KLog(@"请求用户数据发生异常:--%@",exception);
        }
        @finally {
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WBSUtils dismissHUD];
        KLog(@"网络错误%@",error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
    return sessionDataTask;
}

/*************** 方便取消下载任务 ******************/
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;{
    KLog(@"这个网络的URL是: %@ ",URLString);
    return [[NetworkingCenter manager]GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //进度
    } success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    KLog(@"这个网络的URL是: %@ ",URLString);
    return [[NetworkingCenter manager]POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //进度
    } success:success failure:failure];
}


//[manger.requestSerializer setTimeoutInterval:15];


//AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//manager.responseSerializer = [AFJSONResponseSerializer serializer];
//NSString *sk = [[NSUserDefaults standardUserDefaults]objectForKey:@"sk"];
//[manager.requestSerializer setValue:sk forHTTPHeaderField:@"sk"];


//+(void)addAuthorization:(AFHTTPRequestOperationManager*)manager
//{
//    if (kTokenPlist) {
//        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:kTokenPlist];
//        if (dic) {
//            NSString *tokenStr = [dic objectForKey:@"token"];
//            [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",tokenStr] forHTTPHeaderField:@"Authorization"];
//        }
//    }
//}


@end
