//
//  TMDAnchor.m
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "TMDAnchor.h"

@implementation TMDAnchor

- (NSArray *)patterns {
  return @[@"a"];
}

- (NSString *)replaceText:(NSString *)text
   withTextCheckingResult:(NSTextCheckingResult *)result {
  if([result numberOfRanges] == 3) {
    NSRange r1 = [result rangeAtIndex:1];
    NSRange r2 = [result rangeAtIndex:2];
    NSString *attrs = [text substringWithRange:r1];
    NSString *value = [text substringWithRange:r2];
    NSString *href  = [self attributeValueWithText:attrs name:@"href"];
    NSString *title = [self attributeValueWithText:attrs name:@"title"];
    NSString *repl = nil;
    if(href && [href length] > 0) {
      if(title && [title length] > 0)
        repl = [NSString stringWithFormat:@"[%@](%@ \"%@\")", value, href, title];
      else
        repl = [NSString stringWithFormat:@"[%@](%@)", value, href];
      text = [text stringByReplacingCharactersInRange:[result rangeAtIndex:0] withString:repl];
    }
  }
  return text;
}

@end
