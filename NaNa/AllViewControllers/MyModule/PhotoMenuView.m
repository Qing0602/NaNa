//
//  PhotoMenuView.m
//  NaNa
//
//  Created by dengfang on 13-8-17.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "PhotoMenuView.h"

@implementation PhotoMenuView
@synthesize photoMenuDelegate = _photoMenuDelegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - ButtonPressed
- (IBAction)albumButtonPressed:(UIButton *)btn {
    ULog(@"albumButtonPressed");
    if (_photoMenuDelegate != nil &&
        [_photoMenuDelegate respondsToSelector:@selector(albumButtonPressed:)]) {
        [_photoMenuDelegate performSelector:@selector(albumButtonPressed:) withObject:btn];
	}
}


- (IBAction)photoButtonPressed:(UIButton *)btn {
    ULog(@"photoButtonPressed");
    if (_photoMenuDelegate != nil &&
        [_photoMenuDelegate respondsToSelector:@selector(photoButtonPressed:)]) {
        [_photoMenuDelegate performSelector:@selector(photoButtonPressed:) withObject:btn];
	}
}


- (IBAction)cartoonButtonPressed:(UIButton *)btn {
    ULog(@"cartoonButtonPressed");
    if (_photoMenuDelegate != nil &&
        [_photoMenuDelegate respondsToSelector:@selector(cartoonButtonPressed:)]) {
        [_photoMenuDelegate performSelector:@selector(cartoonButtonPressed:) withObject:btn];
	}
}


- (IBAction)cancelButtonPressed:(UIButton *)btn {
    ULog(@"cancelButtonPressed");
    if (_photoMenuDelegate != nil &&
        [_photoMenuDelegate respondsToSelector:@selector(cancelButtonPressed:)]) {
        [_photoMenuDelegate performSelector:@selector(cancelButtonPressed:) withObject:btn];
	}
}
@end
