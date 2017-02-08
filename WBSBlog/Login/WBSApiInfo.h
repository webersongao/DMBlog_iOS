//
//  WBSApiInfo.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSApiInfo : NSObject

/**
 *  baseURL（XMLRPC API 时为xmlrpcURL，JSON API时为 JSON URL）
 */
@property (nonatomic,strong) NSString *baseURL;
/**
 *  用户名
 */
@property (nonatomic,strong) NSString *username;
/**
 *  密码
 */
@property (nonatomic,strong) NSString *password;
/**
 *  JSON API才会用到
 */
@property (nonatomic,strong) NSString * generateAauthCookie;

/**
 *  初始化XMLRPC API
 *
 *  @param xmlrpc   xmlrpc链接
 *  @param username 用户名
 *  @param password 密码
 *
 *  @return ApiInfo实例
 */
-(instancetype)initWithXmlrpc:(NSString *)xmlrpc username:(NSString *)username password:(NSString *)password;

/**
 *  初始化JSON API
 *
 *  @param baseURL  baseURL
 *  @param cookie cookie
 *
 *  @return ApiInfo实例
 */
-(instancetype)initWithBaseURL:(NSString *)baseURL andGenerateAuthCookie:(NSString *)cookie;

@end
