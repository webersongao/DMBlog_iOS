//
//  WBSConfig.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBSApiInfo.h"

@interface WBSConfig : NSObject

/**
 *  获取是否夜间模式
 */
+ (BOOL)getMode;

/**
 *  获取XMLRPC API的授权信息
 */
+(WBSApiInfo *)getAuthoizedApiInfo;

/**
 *  是否启用高级API
 */
+(BOOL)isJSONAPIEnable;

/**
 *  是否显示页面（默认只显示文章）
 */
+(BOOL)isShowPage;

/**
 *  是否针对Wordpress优化
 */
+(BOOL)isWordpressOptimization;

/**
 *  退出登录时 恢复用户设置 到默认设置
 */
+(void)resetUserConfigToDefault;

@end



