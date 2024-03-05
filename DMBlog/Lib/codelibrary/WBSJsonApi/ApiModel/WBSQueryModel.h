//
//  WBSQueryModel.h
//  WBSJsonApi
//
//  Created by WebersonGao on 2017/2/16.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSQueryModel : NSObject

/// get_posts
@property (nonatomic, assign) NSInteger count;  //!< <#属性注释#>
@property (nonatomic, assign) BOOL ignore_sticky_posts;  //!< <#属性注释#>
@property (nonatomic, assign) NSInteger page;  //!< <#属性注释#>
@property (nonatomic, copy) NSString *post_type;  //!< <#属性注释#>


+ (WBSQueryModel *)QueryserModelWithDic:(NSDictionary*)dictionary;

@end
