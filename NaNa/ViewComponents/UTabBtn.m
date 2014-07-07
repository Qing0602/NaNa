//
//  UTabBtn.m
//  UBoxOnline
//
//  Created by 苏颖 on 13-3-27.
//  Copyright (c) 2013年 ubox. All rights reserved.
//

#import "UTabBtn.h"
#import <QuartzCore/QuartzCore.h>

@implementation UTabBtn
@synthesize bgImageView = _bgImageView;
@synthesize titleLabel = _titleLabel;


- (void)dealloc {
    self.bgImageView = nil;
    self.titleLabel = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 39, 39)];
        _bgImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bgImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bgImageView.frame) -5, 5,25, 39)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    _bgImageView.highlighted = highlighted;
}


@end
