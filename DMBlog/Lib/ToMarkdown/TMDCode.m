//
//  TMDCode.m
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "TMDCode.h"

@implementation TMDCode

- (NSArray *)patterns {
  return @[@"code"];
}

-(NSString *)replaceText:(NSString *)text withTextCheckingResult:(NSTextCheckingResult *)result {
  if([result numberOfRanges] == 3) {
    NSRange range = [result rangeAtIndex:2];
    NSString *value = [text substringWithRange:range];
    NSString *repl = [NSString stringWithFormat:@"`%@`", value];
    text = [text stringByReplacingCharactersInRange:[result rangeAtIndex:0] withString:repl];
  }
  return text;
}

@end
