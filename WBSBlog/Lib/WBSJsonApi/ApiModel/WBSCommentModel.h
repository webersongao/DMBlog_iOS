//
//  WBSPostComment.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/1.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSCommentModel : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *date;
@property (nonatomic) NSString *content;
@property (nonatomic) NSInteger parent;

+ (WBSCommentModel *)CommentModelWithDictionary:(NSDictionary *)dictionary;

@end
