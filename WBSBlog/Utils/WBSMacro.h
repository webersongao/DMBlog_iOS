//
//  WBSAPI.h
//  GoodJob_Weberson
//
//  Created by Weberson on 15/10/27.
//  Copyright (c) 2015年 Weberson. All rights reserved.
//
/**
 *  ***********   放置网络接口  **************
 网站源文件中带有以下标记的WP网站 都可以使用 WP-REST-API
 Link: <http://example.com/wp-json/>; rel="https://api.w.org/">
 */

#ifndef GoodJob_API_h
#define GoodJob_API_h

#define KbaseUrl @"www.weberson.com.cn"
#define KuserName @"xxx"
#define KpassWord @"xxx"



/********************* 公共接口 *************************/
// 线上服务器
//#define WBSBlogCommonAPI @"https://www.swiftartisan.com/wp-json"

// 测试服务器
#define WBSBlogCommonAPI @"http://www.swiftartisan.com/wp-json"

//处理接口的(就是拼接的哈哈)
#define HandleApiWith(argument) [NSString stringWithFormat:@"%@%@",WBSBlogCommonAPI,argument]

//用户登录地址 json api
#define WBSBlogLoginUrl  HandleApiWith(@"/user/generate_auth_cookie")

/********************* 公共 宏 定义 *************************/

/// 站点地址 JSON API 地址
#define WBSSiteBaseURL                  @"KBlogBaseURL"  //示例： http://www.baidu.com

/// 站点 xmlrpc 地址
#define WBSSiteXmlrpcURL                @"KBlogXmlrpcURL"  //示例： http://www.baidu.com/xmlrpc.php

/// 用户UID
#define WBSUserUID                      @"KUserUID"

/// 账号
#define WBSUserUserName                 @"KUserUserName"

/// 密码
#define WBSUserPassWord                 @"KUserPassWord"

/// 授权令牌 nonce
#define WBSSiteAuthNonce                @"KAuthNonce"

/// 登录Cookie名称
#define WBSSiteAuthCookieName           @"KAuthCookie_name"

/// 登录Cookie
#define WBSSiteAuthCookie               @"KAuthCookie"

// 游客登录
#define WBSGuestLoginMode               @"guestLoginMode"

/// 是否启用JsonApi
#define WBSIs_JSONAPI                   @"K_Is_JSONAPI_Enable"

/// 是否显示“页面”类型
#define WBSIs_ShowPage                  @"K_is_ShowPage"

///是否开启WP优化
#define WBSIs_WP_Optimization           @"Kis_Wordpress_Optimization"

///是否夜间模式
#define WBSIs_NightMode                 @"K_is_NightMode"

///xmlrpcURL 前缀
#define WBSXmlrpcPrefix                 @"xmlrpcURLPrefix"

///xmlrpcURL 后缀
#define WBSXmlrpcSubffix                @"xmlrpcURLSuffix"




#endif


















