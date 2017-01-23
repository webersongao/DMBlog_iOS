//
//  UserModel.h
//  webTest
//
//  Created by weberson on 15/12/3.
//  Copyright (c) 2015年 weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  当前登录的用户
*/

@interface UserModel : NSObject

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, copy) NSString *nickname;// 昵称
@property (nonatomic, copy) NSString *headIcon;// 头像的url
@property (nonatomic, strong) NSNumber *gender;// 性别  0男  1女
@property (nonatomic, copy) NSString *birthday;// 年龄
@property (nonatomic, strong) NSNumber *cityId;// 城市id
@property (nonatomic, copy) NSString *signature;// 签名

@property (nonatomic, strong) NSNumber *headIconVersion;//头像版本
@property (nonatomic, copy) NSString *username;//用户名(登录账号)
@property (nonatomic, copy) NSString *lastLoginDate;
@property (nonatomic, strong) NSNumber *role; // 0 未完善资料  1 已完善资料
@property (nonatomic, strong) NSNumber *channelCode;//登录渠道 0自己注册  1微信登录
@property (nonatomic, copy) NSString *createDate;

//完善个人信息 是否 选中
@property (nonatomic, assign) BOOL isSelected;

///置空
- (void)clearUSerinfoValue;
@end
