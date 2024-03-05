//
//  TMDParagraph.m
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "TMDParagraph.h"

@implementation TMDParagraph

- (NSArray *)patterns {
  return @[@"p"];
}

-(NSString *)replaceText:(NSString *)text withTextCheckingResult:(NSTextCheckingResult *)result {
  if([result numberOfRanges] == 3) {
    NSRange range = [result rangeAtIndex:2];
    NSString *value = [text substringWithRange:range];
    NSString *repl = [NSString stringWithFormat:@"%@\n\n", value];
    text = [text stringByReplacingCharactersInRange:[result rangeAtIndex:0] withString:repl];
  }
  return text;
}

@end
