//
//  WBSNetRequest.h
//  WBSBlog
//
//  Created by Weberson on 2017/1/22.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSNetRequest : NSObject

/// 用户登录
+ (void)postToLogin:(void (^) (BOOL isLoginSuccess,NSString * errorMsg)) LoginSuccessblock SiteUrlStr:(NSString *)siteUrl userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord  isJsonAPi:(BOOL)isJsonApi;



@end