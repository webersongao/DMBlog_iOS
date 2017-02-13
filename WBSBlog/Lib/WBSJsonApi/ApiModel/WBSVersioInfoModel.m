//
//  WBSVersioInfoModel.m
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/10.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSVersioInfoModel.h"

@implementation WBSVersioInfoModel

- (instancetype)initWithDict:(NSDictionary*)dict {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(WBSVersioInfoModel *)VersioInfoModelWithDictionary:(NSDictionary *)dictionary{

    WBSVersioInfoModel *model = [[WBSVersioInfoModel alloc] initWithDict:dictionary];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    //防止崩溃
}

@end
