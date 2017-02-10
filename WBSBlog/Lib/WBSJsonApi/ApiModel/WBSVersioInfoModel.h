//
//  WBSVersioInfoModel.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/10.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSVersioInfoModel : NSObject

// JSONAPI Core 控制器info
@property (nonatomic, strong) NSArray *controllers;  //!< <#属性注释#>
@property (nonatomic, copy) NSString *json_api_version;  //!< <#属性注释#>


+(WBSVersioInfoModel *)VersioInfoModelWithDictionary:(NSDictionary *)dictionary;

@end
