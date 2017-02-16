//
//  WBSNetRequest.m
//  WBSBlog
//
//  Created by Weberson on 2017/1/22.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSNetRequest.h"
#import "WBSJsonApi.h"
#import "WordPressApi.h"
#import "NetworkingCenter.h"
#import "WBSPostModel.h"
#import "WBSCategoryModel.h"
#import "WBSTagModel.h"
#import "WBSCommentModel.h"
#import "WBSVersioInfoModel.h"
#import "WBSUserModel.h"


@interface WBSNetRequest ()

@end


@implementation WBSNetRequest

//系统的初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        self.jsonSiteUrl = [WBSUtils getObjectforKey:WBSSiteBaseURL];
        self.xmlSiteUrl = [WBSUtils getObjectforKey:WBSSiteXmlrpcURL];
    }
    return self;
}

//对外接口
+ (instancetype)sharedRequest{
    static WBSNetRequest *instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[self alloc] init];
    });
    return instace;
}

// 获取JSONAPI 插件版本信息
- (void)GetJsonApiVersionInfoWithControllerType:(JSONAPIControllerType)controllerType SuccessBlock:(void (^)(id versioInfo))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    NSString *controllerStr = @"";
    switch (controllerType) {
        case JSONAPIControllerTypeCore:
            controllerStr = @"core";
            break;
        case JSONAPIControllerTypePosts:
            controllerStr = @"posts";
            break;
        case JSONAPIControllerTypeRespond:
            controllerStr = @"respond";
            break;
        case JSONAPIControllerTypeWidgets:
            controllerStr = @"widgets";
            break;
        case JSONAPIControllerTypeUser:
            controllerStr = @"user";
            break;
        default:
            break;
    }
    [WBSJsonApi get_JsonApi_Info_WithSiteURLStr:self.jsonSiteUrl controllerStr:controllerStr success:^(id versionInfoModel) {
        // success
        successBlock(versionInfoModel);
    } failure:^(NSError *error) {
        // 失败
        failureBlock(error);
    }];
}

/// 用户登录
- (void)userLogin:(void (^) (BOOL isLoginSuccess,NSString * errorMsg)) LoginSuccessblock userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord  isJsonAPi:(BOOL)isJsonApi{
    
    if (isJsonApi) {
        // 使用JSON API登陆
        [WBSJsonApi post_UserLogin_WithSiteUrlStr:self.jsonSiteUrl userNameStr:userName passWordStr:PassWord inSSLSecure:NO success:^(id responseObject, NSString *cookieName, NSString *cookie) {
            // 成功
            //            WBSUserModel *resultDict = (NSDictionary *)responseObject;
            //            NSString *status = [resultDict objectForKey:@"status"];
            //
            //            if ([status isEqualToString:@"ok"]) {
            //                NSString *cookieNameStr = resultDict[@"cookie_name"];
            //                NSString *cookieStr = resultDict[@"cookie"];
            //                [WBSUtils saveObjectforKey:cookieStr forKey:WBSSiteAuthCookie];
            //                [WBSUtils saveObjectforKey:cookieNameStr forKey:WBSSiteAuthCookieName];
            //                [WBSUtils saveObjectforKey:self.jsonSiteUrl forKey:WBSSiteBaseURL];
            //                [WBSUtils saveObjectforKey:userName forKey:WBSUserUserName];
            //                [WBSUtils saveObjectforKey:PassWord forKey:WBSUserPassWord];
            //                [SingleObject shareSingleObject].isLogin = YES;
            //
            //                // 保存用户数据
            //                NSDictionary *userDict = [resultDict objectForKey:@"user"];
            //                WBSUserModel * userModel = [WBSUserModel WBSUserModelWithDic:userDict];
            //                [WBSUtils saveObjectforKey:userModel.uid forKey:WBSUserUID];
            //                NSDictionary *administratorDict = [userDict objectForKey:@"capabilities"];
            //                // 是否是管理员
            //                if ([administratorDict objectForKey:@"administrator"]) {
            //                    userModel.isAdmin = YES;
            //                }else{
            //                    userModel.isAdmin = NO;
            //                }
            //                [SingleObject shareSingleObject].user = userModel;
            //                // 保存用户数据到数据库
            //                [[FMDBManger sharedFMDBManger]insertUserToUserInformationTableWith:userModel];
            
            //                LoginSuccessblock(YES,nil);
            
            //            } else {
            
            //                NSString * errorStr = [NSString stringWithFormat:@"请求错误：%@", resultDict[@"error"]];
            //                [SingleObject shareSingleObject].isLogin = NO;
            //                LoginSuccessblock(NO,errorStr);
            
            //            }
            LoginSuccessblock(NO,nil);
        } failure:^(NSError *error) {
            //失败
            NSString * errorStr = [NSString stringWithFormat:@"请求错误：%@", [error localizedDescription]];
            [SingleObject shareSingleObject].isLogin = NO;
            LoginSuccessblock(NO,errorStr);
        }];
        
    }else{
        // 使用XMLRPC 登陆  暂时不支持Https
        
        [WordPressApi loginInWithURL:self.xmlSiteUrl
                            username:userName
                            password:PassWord
                             success:^(NSURL *xmlrpcURL) {
                                 [WBSUtils saveObjectforKey:self.jsonSiteUrl forKey:WBSSiteBaseURL];
                                 [WBSUtils saveObjectforKey:[xmlrpcURL absoluteString] forKey:WBSSiteXmlrpcURL];
                                 [WBSUtils saveObjectforKey:userName forKey:WBSUserUserName];
                                 [WBSUtils saveObjectforKey:PassWord forKey:WBSUserPassWord];
                                 [SingleObject shareSingleObject].isLogin = YES;
                                 LoginSuccessblock(YES,nil);
                                 
                                 KLog(@"-----登录成功--网址：%@ --",[xmlrpcURL absoluteString]);
                             } failure:^(NSError *error) {
                                 KLog(@"-----登录失败啦----");
                                 NSString * errorStr = [NSString stringWithFormat:@"登录失败：%@", [error localizedDescription]];
                                 [SingleObject shareSingleObject].isLogin = NO;
                                 LoginSuccessblock(NO,errorStr);
                             }];
    }
    
}


/// 获取最近文章 get_recent_posts
- (void)getRecentPosts_WithCount:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType success:(void (^)(NSArray *postsModelArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    [WBSJsonApi get_recent_posts_WithSiteUrlStr:self.jsonSiteUrl count:count page:page postType:postType success:^(NSArray *postsModelArray, NSInteger postsCount) {
        // 成功
        successBlock(postsModelArray,postsCount);
    }failure:^(NSError *error) {
        // 失败
        //Trigger failure block
        failureBlock(error);
        
    }];
}


/// 获取文章 get_posts
- (void)getPosts_WithCount:(NSInteger)count page:(NSInteger)page postType:(NSString *)postType IgnoreStickyPosts:(BOOL)isIgnoreStickyPosts success:(void (^)(NSArray *postsArray, NSInteger postsCount ,BOOL isIgnoreStickyPosts))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    [WBSJsonApi get_Posts_WithSiteUrlStr:self.jsonSiteUrl count:count page:page postType:postType IgnoreStickyPosts:isIgnoreStickyPosts success:^(NSArray *postsModelArray, NSInteger postsCount, BOOL isIgnoreStickyPosts) {
        // 成功
        successBlock(postsModelArray,postsCount,isIgnoreStickyPosts);
    } failure:^(NSError *error) {
        // 失败
        //Trigger failure block
        failureBlock(error);
    }];
    
}


/// 获取文章 get_post
- (void)getPost_WithPostId:(NSInteger)postId postSlug:(NSString *)postSlug postType:(NSString *)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    [WBSJsonApi get_post_WithSiteUrlStr:self.jsonSiteUrl postId:postId postSlug:postSlug postType:postType success:^(NSArray *postsArray, NSInteger postsCount) {
        //
        successBlock(postsArray,postsCount);
    } failure:^(NSError *error) {
        // 失败
        failureBlock(error);
    }];
}

















/// 网络请求
- (void)postToRequestPostTextData:(void (^) (id obj,id msg, NSError *err))block andSiteUrlStr:(NSString *)siteUrl userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord{
    
}


@end
