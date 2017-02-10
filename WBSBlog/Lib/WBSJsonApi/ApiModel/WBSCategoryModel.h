//
//  WBSCategoryModel.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/1.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSCategoryModel : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSString *slug;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *categoryDescription;
@property (nonatomic) NSInteger parent;
@property (nonatomic) NSInteger postsCount;

+ (WBSCategoryModel *)CategoryModelWithDictionary:(NSDictionary *)dictionary;

@end
