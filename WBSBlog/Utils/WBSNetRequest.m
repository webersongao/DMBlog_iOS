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

@property (nonatomic, strong) NSString *jsonSiteUrl;  //!< JSON API 站点地址
@property (nonatomic, strong) NSString *xmlSiteUrl;   //!< XMLRPC 站点地址

@end


@implementation WBSNetRequest

//系统的初始化
- (instancetype)init{
    self = [super init];
    if (self) {
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
    instace.jsonSiteUrl = [WBSUtils getObjectforKey:WBSSiteBaseURL];
    instace.xmlSiteUrl = [WBSUtils getObjectforKey:WBSSiteXmlrpcURL];
    KLog(@"jsonSiteUrl is %@  == xmlSiteUrl is %@ ",instace.jsonSiteUrl,instace.xmlSiteUrl);
    return instace;
}


// 适配各种发布文章类型
-(NSString *)setPostType:(JSONAPIPostType)postType{
    
    NSString *postTypeStr = @"post";
    switch (postType) {
        case JSONAPIPostTypeDefault:
            postTypeStr = @"post";
            break;
        case JSONAPIPostTypePost:
            postTypeStr = @"post";
            break;
        case JSONAPIPostTypeTemp:
            postTypeStr = @"temp";
            break;
        default:
            break;
    }
    return postTypeStr;
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
- (void)userLoginWithSiteBaseUrlStr:(NSString *)siteBaseUrlStr successBlock:(void (^) (BOOL isLoginSuccess,NSString * errorMsg)) LoginSuccessblock userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord  isJsonAPi:(BOOL)isJsonApi{
    if (isJsonApi) {
        // 使用JSON API登陆
        NSString *jsonUrl = [NSString stringWithFormat:@"http://%@",siteBaseUrlStr];
        [WBSJsonApi post_UserLogin_WithSiteUrlStr:jsonUrl userNameStr:userName passWordStr:PassWord inSSLSecure:NO success:^(id responseObject, NSString *cookieName, NSString *cookie) {
            // 成功
            BOOL isSuccess = NO;
            NSString *errorStr = @"";
            if (![cookie isEqualToString:@""] && ![cookieName isEqualToString:@""]) {
                isSuccess = YES;
                WBSUserModel *userModel = (WBSUserModel *)responseObject;
                [WBSUtils saveObjectforKey:cookie forKey:WBSSiteAuthCookie];
                [WBSUtils saveObjectforKey:cookieName forKey:WBSSiteAuthCookieName];
                [WBSUtils saveObjectforKey:self.jsonSiteUrl forKey:WBSSiteBaseURL];
                [WBSUtils saveObjectforKey:userName forKey:WBSUserUserName];
                [WBSUtils saveObjectforKey:PassWord forKey:WBSUserPassWord];
                [SingleObject shareSingleObject].isLogin = YES;
                // 保存用户数据
                [SingleObject shareSingleObject].user = userModel;
                // 保存用户数据到数据库
                [[FMDBManger sharedFMDBManger]insertUserToUserInformationTableWith:userModel];
                
                LoginSuccessblock(isSuccess,nil);
                
            }else{
                isSuccess = NO;
                errorStr = [responseObject objectForKey:@"error"];
            }
            
            LoginSuccessblock(isSuccess,errorStr);
        } failure:^(NSError *error) {
            //失败
            NSString * errorStr = [NSString stringWithFormat:@"request failure：%@", [error localizedDescription]];
            [SingleObject shareSingleObject].isLogin = NO;
            LoginSuccessblock(NO,errorStr);
        }];
        
    }else{
        // 使用XMLRPC 登陆  暂时不支持Https
        NSString *xmlRpcUrl = [NSString stringWithFormat:@"http://%@/xmlrpc.php",siteBaseUrlStr];
        [WordPressApi loginInWithURL:xmlRpcUrl
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
- (void)getRecentPosts_WithCount:(NSInteger)count page:(NSInteger)page postType:(JSONAPIPostType)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    [WBSJsonApi get_recent_posts_WithSiteUrlStr:self.jsonSiteUrl count:count page:page postType:[self setPostType:postType] success:^(NSArray *postsModelArray, NSInteger postsCount) {
        // 成功
        successBlock(postsModelArray,postsCount);
    }failure:^(NSError *error) {
        // 失败
        //Trigger failure block
        failureBlock(error);
        
    }];
}


/// 获取文章 get_posts
- (void)getPosts_WithCount:(NSInteger)count page:(NSInteger)page postType:(JSONAPIPostType)postType IgnoreStickyPosts:(BOOL)isIgnoreStickyPosts success:(void (^)(NSArray *postsArray, NSInteger postsCount ,BOOL isIgnoreStickyPosts))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    [WBSJsonApi get_Posts_WithSiteUrlStr:self.jsonSiteUrl count:count page:page postType:[self setPostType:postType] IgnoreStickyPosts:isIgnoreStickyPosts success:^(NSArray *postsModelArray, NSInteger postsCount, BOOL isIgnoreStickyPosts) {
        // 成功
        successBlock(postsModelArray,postsCount,isIgnoreStickyPosts);
    } failure:^(NSError *error) {
        // 失败
        //Trigger failure block
        failureBlock(error);
    }];
    
}


/// 获取指定文章 get_post
- (void)getPost_WithPostId:(NSInteger)postId postSlug:(NSString *)postSlug postType:(JSONAPIPostType)postType success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    [WBSJsonApi get_post_WithSiteUrlStr:self.jsonSiteUrl postId:postId postSlug:postSlug postType:[self setPostType:postType] success:^(NSArray *postsArray, NSInteger postsCount) {
        //
        successBlock(postsArray,postsCount);
    } failure:^(NSError *error) {
        // 失败
        failureBlock(error);
    }];
}





/// 获取文章tag get_tag_index
- (void)getTag_WithSuccess:(void (^)(NSArray *tagsArray, NSInteger tagsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    [WBSJsonApi get_tag_index_WithSiteUrlStr:self.jsonSiteUrl success:^(NSArray *tagsArray, NSInteger tagsCount) {
        successBlock(tagsArray,tagsCount);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
    
}














/// 网络请求
- (void)postToRequestPostTextData:(void (^) (id obj,id msg, NSError *err))block andSiteUrlStr:(NSString *)siteUrl userNameStr:(NSString *)userName PassWordStr:(NSString *)PassWord{
    
}


@end
