//
//  MD5.h
//  NaNa
//
//  Created by dengfang on 13-3-21.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <Foundation/Foundation.h>

// =========================================== 分割线 =====================================================

// 用于扩展NSString+MD5
@interface NSString (MD5)
// 返回String的MD5
-(NSString*)md5;

@end


// =========================================== 分割线 =====================================================

// 用于扩展NSData+MD5
@interface NSData (MD5)
// 返回Data的MD5
-(NSString*)md5;

@end