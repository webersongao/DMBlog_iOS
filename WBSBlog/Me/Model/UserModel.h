//
//  UserModel.h
//  webTest
//
//  Created by weberson on 15/12/3.
//  Copyright (c) 2015年 weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  当前登录的用户*/

@interface UserModel : NSObject

@property (nonatomic, strong)   NSNumber *uid;  // id
@property (nonatomic, copy)     NSString *name;// 用户昵称
@property (nonatomic, copy)     NSString *first_name;// 名称
@property (nonatomic, copy)     NSString *last_name;// 姓氏
@property (nonatomic, copy)     NSString *email;// 邮箱
@property (nonatomic, copy)     NSString *link;// 作者地址
@property (nonatomic, copy)     NSString *slug;// 登录账号
@property (nonatomic, copy)     NSString *descriptions;// 个性签名


@property (nonatomic, copy) NSString *descrtion;// 签名
@property (nonatomic, copy) NSString *descripion;// 签名
@property (nonatomic, copy) NSString *desription;// 签名
@property (nonatomic, copy) NSString *descrion;// 签名
@property (nonatomic, copy) NSString *dription;// 签名


///置空
- (void)clearUSerinfoValue;
@end
