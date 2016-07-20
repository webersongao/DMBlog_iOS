//
//  TGTag.h
//  TGBlogJsonApi
//
//  Created by Sebastian Dobrincu on 18/07/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGTag : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSString *slug;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *tagDescription;
@property (nonatomic) NSInteger postsCount;

@end
