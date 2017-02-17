//
//  WBSAuthorModel.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/14.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSAuthorModel : NSObject

@property (nonatomic, copy) NSString *uid;  //!< 用户ID

@property (nonatomic, copy) NSString *first_name;  //!< weberson

@property (nonatomic, copy) NSString *last_name;  //!< gao

@property (nonatomic, copy) NSString *name;  //!< 显示名称

@property (nonatomic, copy) NSString *nickname;  //!< 昵称

@property (nonatomic, copy) NSString *slug;  //!< 无特殊符号的用户账号 521weberson

@property (nonatomic, copy) NSString *descriptions;  //!< <#属性注释#>

+ (WBSAuthorModel *)AuthorModelWithDictionary:(NSDictionary *)dictionary;

@end
