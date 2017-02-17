//
//  WBSErrorModel.m
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/17.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSErrorModel.h"

@implementation WBSErrorModel

+ (WBSErrorModel *)ErrorModelWithDictionary:(NSDictionary *)dictionary
{
    WBSErrorModel *ErrorModel = [[WBSErrorModel alloc]init];
    ErrorModel.status = dictionary[@"status"];
    ErrorModel.error = dictionary[@"error"];
    return ErrorModel;
}

@end
