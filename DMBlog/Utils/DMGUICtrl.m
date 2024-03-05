//
//  DMGUICtrl.h
//  DMBlog
//
//  Created by WebersonGao on 15/8/31.
//  Copyright (c) 2015年 WebersonGao. All rights reserved.
//

#import "DMGUICtrl.h"

@interface DMGUICtrl ()

@property (nonatomic, strong) NSString *jsonSiteUrl;  //!< JSON API 站点地址
@property (nonatomic, strong) NSString *xmlSiteUrl;   //!< XMLRPC 站点地址

@end

@implementation DMGUICtrl

#pragma mark -
//系统的初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        self.user = [[WBSUserModel alloc] init];
        self.isLogin = NO;
        self.isGuest = NO;
        self.siteBaseUrlStr = DMBlogUrl;
        self.jsonSiteUrl = [NSString stringWithFormat:@"%@/wp-json",DMBlogUrl];
        self.xmlSiteUrl = [NSString stringWithFormat:@"%@/xmlrpc.php",DMBlogUrl];
    }
    return self;
}

//对外接口
+ (instancetype)sharedCtrl{
    static DMGUICtrl *instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[self alloc] init];
    });
    return instace;
}


-(void)setIsLogin:(BOOL)isLogin{
    _isLogin = isLogin;
    if (isLogin == YES) {
        // 登录成功，修改为 非游客模式
        [DMSUtils saveBoolforKey:NO forKey:WBSGuestLoginMode];
        self.siteBaseUrlStr = [DMSUtils getObjectforKey:WBSSiteBaseURL];
        self.isGuest = NO;
    }else{
        self.siteBaseUrlStr = @"";
    }
}


-(NSString *)requestUrl{
    BOOL json = YES;
    return json ? self.jsonSiteUrl : self.xmlSiteUrl;
}

@end
