//
//  NetworkingCenter.m
//  WBSBlog
//
//  Created by Weberson on 15/11/18.
//  Copyright (c) 2015年 Weberson. All rights reserved.
//

#import "NetworkingCenter.h"
#import "CustomAlertView_Runtime.h"



@implementation NetworkingCenter

/*-------------------- 加header的 get OR post请求 -----------------*/
+ (AFHTTPRequestOperation *)GetWithHeader:(NSString *)urlString parameters:(id)parameters isShowHUB:(BOOL)show success:(void (^)(id responseObject))success noLogin:(void(^)())noLigin failure:(void (^)(NSError *error))failure{
    
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
    NSString *sk = [[NSUserDefaults standardUserDefaults]objectForKey:@"sk"];
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
    AFHTTPRequestOperation *httpRequestOperation =[manger GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        @try {
            success(responseObject);
        }
        @catch (NSException *exception) {
            KLog(@"--%@",exception);
        }
        @finally {
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
    
    return httpRequestOperation;
}


+ (AFHTTPRequestOperation *)PostWithHeader:(NSString *)urlString parameters:(id)parameters isShowHUB:(BOOL)show success:(void (^)(id responseObject))success noLogin:(void(^)())noLigin failure:(void (^)(NSError *error))failure{
    
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
    NSString *sk = [[NSUserDefaults standardUserDefaults]objectForKey:@"sk"];
    
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
    
    AFHTTPRequestOperation *httpRequestOperation = [manger POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (show) {
            [WBSUtils dismissHUD];
        }
        failure(error);
    }];
    return httpRequestOperation;
}

/*------------------ 不加header HTTP -----------------*/
/// 常用
+ (AFHTTPRequestOperation *)GETRequest:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
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
    AFHTTPRequestOperation *httpRequestOperation = [manger GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        @try {
            success(responseObject);
        }
        @catch (NSException *exception) {
            KLog(@"--%@",exception);
        }
        @finally {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        KLog(@"网络错误%@",error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
    return httpRequestOperation;
}


/// 常用
+ (AFHTTPRequestOperation *)POSTRequest:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
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
    AFHTTPRequestOperation *httpRequestOperation = [manger POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WBSUtils dismissHUD];
        KLog(@"网络错误%@",error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
    return httpRequestOperation;
}

/*************** 方便取消下载任务 ******************/
+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;{
    KLog(@"这个网络的URL是: %@ ",URLString);
    return [[NetworkingCenter manager] GET:URLString parameters:parameters success:success failure:failure];
}

+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    KLog(@"这个网络的URL是: %@ ",URLString);
    return [[NetworkingCenter manager] POST:URLString parameters:parameters success:success failure:failure];
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
