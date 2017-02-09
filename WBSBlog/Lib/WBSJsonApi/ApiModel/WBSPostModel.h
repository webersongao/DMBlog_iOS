//
//  WBSPostModel.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/1.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSPostModel : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSString *URL;
@property (nonatomic) NSString *slug;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *plainTitle;
@property (nonatomic) NSString *thumbnailURL;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *plainContent;
@property (nonatomic) NSInteger contentReadingMinutes;
@property (nonatomic) NSString *excerpt;
@property (nonatomic) NSString *date;
@property (nonatomic) NSString *lastModifiedDate;
@property (nonatomic) NSArray *categoriesArray;
@property (nonatomic) NSArray *tagsArray;
@property (nonatomic) NSDictionary *authorInfo;
@property (nonatomic) NSArray *commentsArray;
@property (nonatomic) NSInteger commentsCount;
@property (nonatomic) NSString *commentsStatus;

+ (WBSPostModel *)PostModelWithDictionary:(NSDictionary *)dictionary;

@end
