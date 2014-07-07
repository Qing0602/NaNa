//
//  UIAlertView+Block.h
//  NaNa
//
//  Created by dengfang on 13-5-5.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAlertView.h"

@interface UIAlertView(Block)

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showWithCompleteBlock:(void(^)(NSInteger btnIndex))block;

@end

@interface UAlertView(Block)<UAlertViewDelegate>

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showWithCompleteBlock:(void(^)(NSInteger btnIndex))block;

@end
