//
//  ULogic.m
//  NaNa
//
//  Created by dengfang on 13-3-1.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "ULogic.h"

@implementation ULogic
@synthesize delegate, needRereshData;

- (void)dealloc {
    self.delegate = nil;
    [URequestManager removeURequestWithDelegate:self];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.needRereshData = NO;
    }
    return self;
}

// 当页面将要显示的时候，会自动的调用此方法
- (void)viewWillAppear {
    // 然后可以在此页面，查看是否需要刷新的状态
}

// 取消掉当前Logic的所有请求
- (void)cancelAllRequest {
    [URequestManager removeURequestWithDelegate:self];
}

@end
