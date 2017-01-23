//
//  UserModel.h
//  webTest
//
//  Created by weberson on 15/12/3.
//  Copyright (c) 2015年 weberson. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}



- (void)clearUSerinfoValue{
    self.uid = nil;
    self.headIconVersion = nil;
    self.nickname = nil;
    self.signature = nil;
    self.gender = nil;
    self.birthday = nil;
    self.username = nil;
    self.lastLoginDate = nil;
    self.role = nil;
    self.cityId = nil;
    self.channelCode = nil;
    self.createDate = nil;
}


@end
