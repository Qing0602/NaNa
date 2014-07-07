//
//  UBottomView.m
//  NaNa
//
//  Created by dengfang on 13-8-17.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "UBottomView.h"

@implementation UBottomView
@synthesize finishButton = _finishButton;

- (void)dealloc {
    SAFERELEASE(_finishButton)
    [super dealloc];
}

@end
