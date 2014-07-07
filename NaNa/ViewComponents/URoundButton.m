//
//  URoundButton.m
//  NaNa
//
//  Created by dengfang on 13-9-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "URoundButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation URoundButton

@synthesize imageView = _imageView;
@synthesize normalImage = _normalBGImage;
@synthesize highlightImage = _highlightBGImage;
@synthesize normalText = _normalText;
@synthesize highText = _highText;
@synthesize normalTextColor = _normalTextColor;
@synthesize highlightTextColor = _highlightTextColor;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    self.normalImage = nil;
    self.highlightImage = nil;
    self.normalTextColor = nil;
    self.highlightTextColor = nil;
    [_imageView release]  , _imageView = nil;
    [_titleLable release] , _titleLable = nil;
    [_normalText release] , _normalText = nil;
    [_highText release]   , _highText = nil;
    
    [super dealloc];
}

#pragma mark - init
// 初始化控件
- (void)commonInit {
	_imageView = [[UIImageView alloc] init];
	CGRect backgroundImageFrame = [_imageView frame];
	backgroundImageFrame.size = [self bounds].size;
	backgroundImageFrame.origin = CGPointZero;
	[_imageView setFrame:backgroundImageFrame];
    
	[self addSubview:_imageView];
    
    _titleLable = [[UILabel alloc] initWithFrame:self.bounds];
    [_titleLable setTextAlignment:NSTextAlignmentCenter];
    _titleLable.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLable];
}

// 是否在圆内
- (BOOL)isContainPoint:(CGPoint)point {
    /*
     点是否在圆内(在边上也认为在圆内)
     cPoint:    圆心坐标
     cRadius:   圆半径
     point:     当前点
     参考公式：(x - x0)^2 + (y - y0)^2 <= cRadius
     */
    CGFloat width = [self frame].size.width;
	CGFloat height = [self frame].size.height;
    CGPoint cPoint = CGPointMake(width/2, height/2);
    float cRadius = width / 2;
    float distance = sqrtf(powf((abs(point.x - cPoint.x)), 2) + powf(abs(point.y - cPoint.y), 2));
    if (distance <= cRadius) {
        return YES;
    }
    return NO;
}

#pragma mark - touchEvent
// 触屏开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
	CGPoint point = [[touches anyObject] locationInView:self];
    if ([self isContainPoint:point]) {
        _imageView.image = _highlightBGImage;
        if (_highText) {
            _titleLable.text = [NSString stringWithFormat:@"%@",_highText];
            [_titleLable setTextColor:_highlightTextColor];
        }
        
        if (_downControlEvent == UIControlEventTouchDown) {
            [_delegate performSelector:_downAction withObject:self];
        }
    }
}


// 触屏结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _imageView.image = _normalBGImage;
    if (_normalText) {
        _titleLable.text = [NSString stringWithFormat:@"%@",_normalText];
        [_titleLable setTextColor:_normalTextColor];
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self isContainPoint:point] && _upControlEvent == UIControlEventTouchUpInside) {
        [_delegate performSelector:_upAction withObject:self];
    }
}

#pragma mark - set
// 添加事件
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    _delegate = target;
    switch (controlEvents){
        case UIControlEventTouchDown:{
            _downControlEvent = UIControlEventTouchDown;
            _downAction = action;
        }
            break;
        case UIControlEventTouchUpInside:{
            _upControlEvent = UIControlEventTouchUpInside;
            _upAction = action;
        }
            break;
        default:
            break;
    }
}

// 设置各个状态的背景图片
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal: {
            _normalBGImage = image;
            _imageView.image = image;
        }
            break;
        case UIControlStateHighlighted: {
            _highlightBGImage = image;
        }
            break;
        default:
            break;
    }
}

// 设置文字
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal: {
            self.normalText = [NSString stringWithFormat:@"%@",title];
            _titleLable.text = title;
        }
            break;
        case UIControlStateHighlighted: {
            self.highText = [NSString stringWithFormat:@"%@",title];
        }
            break;
        default:
            break;
    }
}

// 设置文字颜色
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    switch (state) {
        case UIControlStateNormal:{
            _normalTextColor = color;
            [_normalTextColor retain];
            [_titleLable setTextColor:_normalTextColor];
        }
            break;
        case UIControlStateHighlighted:{
            _highlightTextColor = color;
            [_highlightTextColor retain];
        }
            break;
        default:
            break;
    }
}
@end
