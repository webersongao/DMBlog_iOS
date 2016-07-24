//
//  UIImageView+Util.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "UIImageView+Util.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Util)

- (void)loadPortrait:(NSURL *)portraitURL
{
    if (portraitURL.absoluteString.length < 1 ) {
        return;
    }
    [self sd_setImageWithURL:portraitURL placeholderImage:[UIImage imageNamed:@"default-portrait"] options:0]; 
}

@end
