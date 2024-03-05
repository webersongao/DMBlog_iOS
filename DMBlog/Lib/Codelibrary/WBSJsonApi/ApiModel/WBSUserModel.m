//
//  WBSUserModel.h
//  WBSJsonApi
//
//  Created by WebersonGao on 15/12/3.
//  Copyright (c) 2015年 WebersonGao. All rights reserved.
//

#import "WBSUserModel.h"

@implementation WBSUserModel


- (instancetype)initWithDict:(NSDictionary*)dict {
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        
        
    }
    return self;
}


+ (WBSUserModel *)WBSUserModelWithDic:(NSDictionary*)dict{
    
    WBSUserModel *model = [[WBSUserModel alloc] initWithDict:dict];
    return model;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        self.uid = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.descriptions = value;
    }
}




@end
