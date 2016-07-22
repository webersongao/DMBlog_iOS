//
//  TMDElement.h
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMDElement : NSObject

- (NSArray *)patterns;
- (BOOL)isVoid;
- (NSString *)replaceText:(NSString *)text;
- (NSString *)replaceText:(NSString *)text
   withTextCheckingResult:(NSTextCheckingResult *)result;
- (NSString *)attributeValueWithText:(NSString *)attrText name:(NSString *)name;
- (NSRegularExpression *)regexAtIndex:(NSInteger)index;

@end
