//
//  SingleObject.h
//  web_Product
//
//  Created by weberson on 15/8/31.
//  Copyright (c) 2015年 weberson. All rights reserved.
//

#import "SingleObject.h"

@implementation SingleObject

#pragma mark -
//系统的初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        self.user = [[WBSUserModel alloc] init];
        self.isLogin = NO;
        self.isGuest = NO;
    }
    return self;
}

//对外接口
+ (instancetype)shareSingleObject{
    static SingleObject *instace = nil;
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
        [WBSUtils saveDataWithBool:NO forKey:WBSGuestLoginMode];
        self.isGuest = NO;
    }
    
}

@end
