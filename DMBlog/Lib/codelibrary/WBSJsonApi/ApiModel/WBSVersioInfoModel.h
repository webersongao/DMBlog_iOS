//
//  WBSVersioInfoModel.h
//  WBSJsonApi
//
//  Created by WebersonGao on 2017/2/10.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSVersioInfoModel : NSObject

// JSONAPI 不指定控制器时候的 版本 /info
@property (nonatomic, strong) NSArray *controllers;  //!< <#属性注释#>
@property (nonatomic, copy) NSString *json_api_version;  //!< <#属性注释#>

// 指定 /info?controller = core、user、posts等时候
@property (nonatomic, copy) NSString *name;  //!< <#属性注释#>
@property (nonatomic, copy) NSString *descriptions;  //!< <#属性注释#>
@property (nonatomic, strong) NSArray *methods;  //!< <#属性注释#>


+(WBSVersioInfoModel *)VersioInfoModelWithDictionary:(NSDictionary *)dictionary;

@end
