//
//  TMDHeading.m
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "TMDHeading.h"

@implementation TMDHeading

- (NSArray *)patterns {
  return @[@"h([1-6])"];
}

- (NSString *)replaceText:(NSString *)text
   withTextCheckingResult:(NSTextCheckingResult *)result {
  if([result numberOfRanges] == 5) {
    NSRange r1 = [result rangeAtIndex:1];
    NSRange r3 = [result rangeAtIndex:3];
    NSString *value = [text substringWithRange:r3];
    NSInteger level = [[text substringWithRange:r1] integerValue];
    NSMutableString *igeta = [NSMutableString string];
    for(NSInteger i=0;i<level;i++) {
      [igeta appendString:@"#"];
    }
    NSString *repl = [NSString stringWithFormat:@"%@ %@", igeta, value];
    return [text stringByReplacingCharactersInRange:[result rangeAtIndex:0] withString:repl];
  }
  return text;
}

@end
