//
//  WBSAuthorModel.m
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/14.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSAuthorModel.h"

@implementation WBSAuthorModel

- (instancetype)initWithDict:(NSDictionary*)dict {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (WBSAuthorModel *)AuthorModelWithDictionary:(NSDictionary *)dictionary{
    
    WBSAuthorModel *model = [[WBSAuthorModel alloc] initWithDict:dictionary];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        self.uid = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.descriptions = value;
    }
    
    //防止崩溃
}



@end
