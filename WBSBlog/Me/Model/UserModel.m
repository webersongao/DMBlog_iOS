//
//  UserModel.h
//  webTest
//
//  Created by weberson on 15/12/3.
//  Copyright (c) 2015年 weberson. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


- (instancetype)initWithDict:(NSDictionary*)dict {
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        
        
    }
    return self;
}


+ (UserModel *)WBSUserModelWithDic:(NSDictionary*)dict{
    
    UserModel *model = [[UserModel alloc] initWithDict:dict];
    return model;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        self.uid = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.descriptions = value;
    }
    KLog(@"id description 转换完毕");
}



- (void)clearUSerinfoValue{
    self.uid = nil;
}


@end
