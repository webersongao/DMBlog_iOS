//
//  DMGUICtrl.h
//  DMBlog
//
//  Created by WebersonGao on 15/8/31.
//  Copyright (c) 2015年 WebersonGao. All rights reserved.
//

/**
 *  数据单例
 */

#import <Foundation/Foundation.h>
#import "WBSUserModel.h"

@interface DMGUICtrl : NSObject

@property (nonatomic ,assign) BOOL isLogin;  //!< 是否登录
@property (nonatomic ,assign) BOOL isGuest;  //!< 是否为游客
@property (nonatomic, strong) WBSUserModel *user;   //!< 用户数据
@property (nonatomic ,copy) NSString * siteBaseUrlStr;  //!< 登录之后 记录的站点地址

/**
 *  初始化
 *
 */
+ (instancetype)sharedCtrl;


-(NSString *)requestUrl;

@end
