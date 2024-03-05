//
//  WBSTagModel.h
//  WBSJsonApi
//
//  Created by WebersonGao on 2017/2/1.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSTagModel : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSString *slug;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *tagDescription;
@property (nonatomic) NSInteger postsCount;

+ (WBSTagModel *)TagModelWithDictionary:(NSDictionary *)dictionary;

@end
