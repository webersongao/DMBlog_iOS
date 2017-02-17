//
//  WBSErrorModel.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/17.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSErrorModel : NSObject
@property (nonatomic, copy) NSString *status;  //!<  请求状态
@property (nonatomic, copy) NSString *error;  //!<  请求状态

+ (WBSErrorModel *)ErrorModelWithDictionary:(NSDictionary *)dictionary;

@end
