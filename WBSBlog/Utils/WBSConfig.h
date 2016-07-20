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
 *
 *  @return 是否夜间模式
 */
+ (BOOL)getMode;

/**
 *  获取MetaWeblog API的授权信息
 *
 *  @return ApiInfo
 */
+(WBSApiInfo *)getAuthoizedApiInfo;

/**
 *  是否启用高级API（注意：如果启用了，需要服务端支持，https://github.com/terwer/TGBlogJsonApi）
 *
 *  @return 高级API开启状态
 */
+(BOOL)isJSONAPIEnable;

/**
 *  是否显示页面（默认只显示文章）
 *
 *  @return 是否显示页面
 */
+(BOOL)isShowPage;

/**
 *  是否针对Wordpress优化
 *
 *  @return 是否针对Wordpress优化
 */
+(BOOL)isWordpressOptimization;
@end
