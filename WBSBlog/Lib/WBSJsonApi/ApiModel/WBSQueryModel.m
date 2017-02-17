//
//  WBSQueryModel.m
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/16.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSQueryModel.h"

@implementation WBSQueryModel


- (instancetype)initWithDict:(NSDictionary*)dict {
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        
        
    }
    return self;
}


+ (WBSQueryModel *)QueryserModelWithDic:(NSDictionary*)dictionary{
    
    WBSQueryModel *model = [[WBSQueryModel alloc] initWithDict:dictionary];
    return model;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    

}


@end
