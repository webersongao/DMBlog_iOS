//
//  SingleObject.h
//  web_Product
//
//  Created by weberson on 15/8/31.
//  Copyright (c) 2015年 weberson. All rights reserved.
//

/**
 *  数据单例
 */

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface SingleObject : NSObject

@property (nonatomic, strong) UserModel *user;   //!< 用户数据

@property (nonatomic ,assign) BOOL isLogin;  //!< 是否登录


/**
 *  初始化
 *
 */
+ (instancetype)shareSingleObject;


@end
