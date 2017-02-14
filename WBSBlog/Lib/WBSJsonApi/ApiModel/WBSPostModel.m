//
//  WBSPostModel.m
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/1.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSPostModel.h"
#import "NSString+FormatHTML.h"

@implementation WBSPostModel

+ (WBSPostModel *)PostModelWithDictionary:(NSDictionary *)dictionary
{
    WBSPostModel *PostModel = [[WBSPostModel alloc]init];
    PostModel.postId = [dictionary[@"id"] integerValue];
    PostModel.slug = dictionary[@"slug"];
    PostModel.URL = dictionary[@"url"];
    PostModel.title = [NSString stringByStrippingHTML:dictionary[@"title"]];
    PostModel.plainTitle = dictionary[@"title_plain"];
    PostModel.thumbnailURL = dictionary[@"thumbnail"];
    PostModel.content = dictionary[@"content"];
    
    //Uncomment for plain content, but it may decrease performance
    //newPost.plainContent = [NSString stringByStrippingHTML:dictionary[@"content"]];
    
    NSArray *postsWords = [PostModel.content componentsSeparatedByString:@" "];
    NSInteger readingTime = postsWords.count/230;
    PostModel.contentReadingMinutes = readingTime;
    PostModel.excerpt = dictionary[@"excerpt"];
    PostModel.date = dictionary[@"date"];
    PostModel.lastModifiedDate = dictionary[@"modified"];
    
    return PostModel;
}

@end
