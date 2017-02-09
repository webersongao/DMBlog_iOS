//
//  WBSApiInfo.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSApiInfo.h"

@implementation WBSApiInfo

-(instancetype)initWithXmlrpc:(NSString *)xmlrpc username:(NSString *)username password:(NSString *)password{
    if (self = [super init]) {
        //确保全部都不能为空
        if (!xmlrpc||!username||!password) {
            return nil;
        }
        _siteURL = xmlrpc;
        _username = username;
        _password = password;
    }
    return self;
}

-(instancetype)initWithBaseURL:baseURL andGenerateAuthCookie:(NSString *)cookie{
    if (self = [super init]) {
        //确保全部都不能为空
        if (!baseURL||!cookie) {
            return nil;
        }
        _siteURL = baseURL;
        _generateAauthCookie = cookie;
    }
    return self;
}
@end
