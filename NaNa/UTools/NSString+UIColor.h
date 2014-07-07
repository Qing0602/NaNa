//
//  NSString+UIColor.h
//  NaNa
//
//  Created by dengfang on 13-3-21.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用于扩展NSString,转换UIColor
@interface NSString (UIColor)

// 获取由当前的NSString转换来的UIColor
- (UIColor*)color;

@end
