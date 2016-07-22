//
//  TGTag+SDTagFromDictionary.h
//  TGBlogJsonApi-Demo
//
//  Created by Peter Foti on 9/4/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import "TGTag.h"

@interface TGTag (TGTagFromDictionary)

+ (TGTag *)SDTagFromDictionary:(NSDictionary *)dictionary;

@end
