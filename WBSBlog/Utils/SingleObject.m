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
        self.user = [[UserModel alloc] init];
        self.isLogin = NO;
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

@end
