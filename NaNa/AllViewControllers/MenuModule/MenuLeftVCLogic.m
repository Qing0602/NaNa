//
//  MenuLeftVCLogic.m
//  NaNa
//
//  Created by dengfang on 13-8-7.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "MenuLeftVCLogic.h"


@implementation MenuLeftVCLogic
@synthesize messageArray = _messageArray;


// 初始化方法
- (id)init {
    if (self = [super init]) {
        _messageArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)dealloc {
    SAFERELEASE(_messageArray)
    [super dealloc];
}
@end
