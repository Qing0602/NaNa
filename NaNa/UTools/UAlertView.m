//
//  UAlertView.m
//  UBoxOnline
//
//  Created by sun huayu on 13-6-6.
//  Copyright (c) 2013年 ubox. All rights reserved.
//

#import "UAlertView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+UIColor.h"

static NSMutableArray *__showedAlertView;

@implementation UAlertView
@synthesize messageLabel=_messageLabel,delegate = _delegate;
@synthesize cancelButton = _cancelButton,defaultButton = _defaultButton;

- (void)dealloc
{
    [_alert release];
    [_titleLabel release];
    [_messageLabel release];
    [_cancelButton release];
    [_defaultButton release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (id)initWithMessage:(NSString *)message
             delegate:(id<UAlertViewDelegate>)delegate
         cancelButton:(NSString *)cancelButton
        defaultButton:(NSString *)defaultButton;
{
    if (!__showedAlertView)
    {
        __showedAlertView = [[NSMutableArray alloc] initWithCapacity:0];
    }
    self = [super init];
    if (self)
    {
        _delegate = delegate;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
        layer.frame = CGRectMake(0, 0, 270, 20);
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 230, 400)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = KFontSizeTitleC;
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = KFontColorA;
        _messageLabel.text = message;
        _messageLabel.backgroundColor = [UIColor clearColor];
        [_messageLabel sizeToFit];
        _messageLabel.frame = CGRectMake(20, 40, 230, _messageLabel.frame.size.height);
        _messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        UIColor *normalColor = [UIColor colorWithRed:232/255.0 green:237/255.0 blue:241/255.0 alpha:1.0];
        UIColor *selectColor = [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1.0];
        UIImage *normalImage = [normalColor image];
        UIImage *selectImage = [selectColor image];
        
        if (cancelButton)
        {
            _cancelButton = [[UIButton alloc] init];
            _cancelButton.layer.cornerRadius = 3;
            _cancelButton.layer.borderWidth = 1;
            _cancelButton.layer.borderColor = [selectColor colorWithAlphaComponent:0.5].CGColor;
            [_cancelButton setTitle:cancelButton forState:UIControlStateNormal];
            [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _cancelButton.titleLabel.font = KFontSizeTitleB;
            [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_cancelButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [_cancelButton setBackgroundImage:selectImage forState:UIControlStateHighlighted];
            _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            _cancelButton.clipsToBounds = YES;
        }
        if (defaultButton)
        {
            _defaultButton = [[UIButton alloc] init];
            _defaultButton.layer.cornerRadius = 3;
            _defaultButton.layer.borderWidth = 1;
            _defaultButton.layer.borderColor = [selectColor colorWithAlphaComponent:0.5].CGColor;
            [_defaultButton setTitle:defaultButton forState:UIControlStateNormal];
            [_defaultButton setTitle:cancelButton forState:UIControlStateSelected];
            _defaultButton.titleLabel.font = KFontSizeTitleB;
            [_defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_defaultButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [_defaultButton setBackgroundImage:selectImage forState:UIControlStateHighlighted];
            [_defaultButton addTarget:self action:@selector(defaultButtonClick) forControlEvents:UIControlEventTouchUpInside];
            _defaultButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            _defaultButton.clipsToBounds = YES;
        }
        
        // 判断有几个button

        if (_defaultButton && _cancelButton)
        {
            _cancelButton.frame = CGRectMake(20,CGRectGetMaxY(_messageLabel.frame)+20,110,44);
            _defaultButton.frame = CGRectMake(140,CGRectGetMaxY(_messageLabel.frame)+20,110,44);
        }
        else if (_cancelButton)
        {
            _cancelButton.frame = CGRectMake(20, CGRectGetMaxY(_messageLabel.frame)+20,230,44);
        }
        else if (_defaultButton)
        {
            _defaultButton.frame = CGRectMake(20,CGRectGetMaxY(_messageLabel.frame)+20,230,44);
        }
        else
        {
            assert(@"noButton");
        }
        
        // 根据各文本和按钮的高度确定alert的高度
        _alert = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 270, CGRectGetMaxY(_messageLabel.frame) + 44 + 40)];
        _alert.center = self.center;
        _alert.backgroundColor = [UIColor whiteColor];
        CGRect rect = _alert.bounds;
        rect.size.width = rect.size.width + 1;
        rect.size.height = rect.size.height + 1;
        CGPathRef pathRef = CGPathCreateWithRect(rect, &CGAffineTransformIdentity);
        _alert.layer.shadowPath = pathRef;
        CFRelease(pathRef);
        
        [_alert.layer addSublayer:layer];
        [_alert addSubview:_titleLabel];
        [_alert addSubview:_messageLabel];
        [_alert addSubview:_cancelButton];
        [_alert addSubview:_defaultButton];
        _alert.clipsToBounds = YES;
        [self addSubview:_alert];
    }
    
    [self show];
    return self;

}

+ (UAlertView *)showAlertViewWithMessage:(NSString *)message
                                delegate:(id<UAlertViewDelegate>)delegate
                            cancelButton:(NSString *)cancelButton
                           defaultButton:(NSString *)defaultButton
{
    UAlertView *alert = [[[UAlertView alloc] initWithMessage:message delegate:delegate cancelButton:cancelButton defaultButton:defaultButton] autorelease];
    return alert;
}


- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<UAlertViewDelegate>)delegate
       cancelButton:(NSString *)cancelButton
      defaultButton:(NSString *)defaultButton
    showImmediately:(BOOL)showImmediately
{
    if (!__showedAlertView)
    {
        __showedAlertView = [[NSMutableArray alloc] initWithCapacity:0];
    }
    self = [super init];
    if (self)
    {
        _delegate = delegate;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 230,20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = KFontSizeTitleA_B;
        _titleLabel.textColor = KFontColorA;
        _titleLabel.text = title;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                  _titleLabel.frame.origin.y+_titleLabel.frame.size.height+20,
                                                                  230,
                                                                  400)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = KFontSizeTitleC;
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = KFontColorA;
        _messageLabel.text = message;
        _messageLabel.backgroundColor = [UIColor clearColor];
        [_messageLabel sizeToFit];
        _messageLabel.frame = CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) + 20, 230, _messageLabel.frame.size.height);
        _messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        UILabel *line = [[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_messageLabel.frame) + 20.5f, 270, .5f)] autorelease];
        line.backgroundColor = KLineColorA;
        
        if (cancelButton)
        {
            _cancelButton = [[UIButton alloc] init];
            [_cancelButton setTitle:cancelButton forState:UIControlStateNormal];
            [_cancelButton setTitleColor:KFontColorC forState:UIControlStateNormal];
            [_cancelButton setTitleColor:KFontColorC forState:UIControlStateHighlighted];
            _cancelButton.titleLabel.font = KFontSizeTitleA;
            [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_cancelButton setBackgroundImage:[[UIColor whiteColor]  image] forState:UIControlStateNormal];
            [_cancelButton setBackgroundImage:[[[UIColor grayColor] colorWithAlphaComponent:.3]  image] forState:UIControlStateHighlighted];
            _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        }
        if (defaultButton)
        {
            _defaultButton = [[UIButton alloc] init];
            [_defaultButton setTitle:defaultButton forState:UIControlStateNormal];
            [_defaultButton setTitle:cancelButton forState:UIControlStateSelected];
            _defaultButton.titleLabel.font = KFontSizeTitleA;
            [_defaultButton setTitleColor:KFontColorC forState:UIControlStateNormal];
            [_defaultButton setTitleColor:KFontColorC forState:UIControlStateHighlighted];
            [_defaultButton setBackgroundImage:[[UIColor whiteColor]  image] forState:UIControlStateNormal];
            [_defaultButton setBackgroundImage:[[[UIColor grayColor] colorWithAlphaComponent:.3]  image] forState:UIControlStateHighlighted];
            [_defaultButton addTarget:self action:@selector(defaultButtonClick) forControlEvents:UIControlEventTouchUpInside];
            _defaultButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        }
        
        // 判断有几个button
        UILabel *linea = nil;
        if (_defaultButton && _cancelButton)
        {
            _cancelButton.frame = CGRectMake(0,CGRectGetMaxY(line.frame),135,44);
            _defaultButton.frame = CGRectMake(135,CGRectGetMaxY(line.frame),135,44);
            linea = [[[UILabel alloc]initWithFrame:CGRectMake(135, CGRectGetMaxY(_messageLabel.frame), 1, 44)] autorelease];
            linea.backgroundColor = KLineColorB;
            _defaultButton.titleLabel.font = KFontSizeTitleA_B;
        }
        else if (_cancelButton)
        {
            _cancelButton.frame = CGRectMake(0, CGRectGetMaxY(line.frame),270,44);
        }
        else if (_defaultButton)
        {
            _defaultButton.frame = CGRectMake(0,CGRectGetMaxY(line.frame),270,44);
        }
        else
        {
            assert(@"noButton");
        }
        
        // 根据各文本和按钮的高度确定alert的高度
        _alert = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 270, CGRectGetMaxY(line.frame) + 44)];
        _alert.center = self.center;
        _alert.backgroundColor = [UIColor whiteColor];
        _alert.layer.cornerRadius = 5;
        CGRect rect = _alert.bounds;
        rect.size.width = rect.size.width + 1;
        rect.size.height = rect.size.height + 1;
        CGPathRef pathRef = CGPathCreateWithRect(rect, &CGAffineTransformIdentity);
        _alert.layer.shadowPath = pathRef;
        CFRelease(pathRef);
        [_alert addSubview:line];
        
        [_alert addSubview:_titleLabel];
        [_alert addSubview:_messageLabel];
        [_alert addSubview:_cancelButton];
        [_alert addSubview:_defaultButton];
        [_alert addSubview:linea];
        _alert.clipsToBounds = YES;
        [self addSubview:_alert];
    }
    if (showImmediately)
    {
        [self show];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<UAlertViewDelegate>)delegate
       cancelButton:(NSString *)cancelButton
      defaultButton:(NSString *)defaultButton
{
    return [self initWithTitle:title message:message delegate:delegate cancelButton:cancelButton defaultButton:defaultButton showImmediately:NO];
}

+ (UAlertView *)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                      delegate:(id<UAlertViewDelegate>)delegate
                  cancelButton:(NSString *)cancelButton
                 defaultButton:(NSString *)defaultButton
{
    UAlertView *alert = [[UAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButton:cancelButton defaultButton:defaultButton showImmediately:YES];
    return [alert autorelease];
}

#pragma mark- showAndDismiss
- (void)show
{
     NSTimeInterval delay = __showedAlertView.count * 0.4;
    if ([__showedAlertView containsObject:self])
    {
        return;
    }
    if (__showedAlertView.count > 0)
    {
        if (((UAlertView *)[__showedAlertView lastObject]).tag == EServerErrorEnforceUpdate ||
            ((UAlertView *)[__showedAlertView lastObject]).tag == EServerErrorSignError)
        {
            return;
        }
        [((UAlertView *)[__showedAlertView lastObject]) performSelector:@selector(dismissAnimation) withObject:nil afterDelay:delay];
    }
    [self performSelector:@selector(showAnimation) withObject:nil afterDelay:delay];
    [__showedAlertView addObject:self];
}

- (void)dismiss
{
    [self dismissAnimation];
    [__showedAlertView removeObject:self];
    if (__showedAlertView.count > 0)
    {
        [((UAlertView *)[__showedAlertView lastObject]) performSelector:@selector(showAnimation) withObject:nil afterDelay:0.4];
    }
}

- (void)showAnimation
{
    _alert.userInteractionEnabled = NO;
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.1];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [UIView commitAnimations];
    
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7f, 0.7f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alert.layer addAnimation:popAnimation forKey:@"popAnimation"];
    double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _alert.userInteractionEnabled = YES;
    });
}

- (void)dismissAnimation
{
    _alert.userInteractionEnabled = NO;
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7f, 0.7f, 1.0f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alert.layer addAnimation:hideAnimation forKey:@"hideAnimation"];
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _alert.userInteractionEnabled = YES;
        [self removeFromSuperview];
    });
}

#pragma mark- buttonAction

- (void)cancelButtonClick
{
    if (_buttonDown)
    {
        return;
    }
    _buttonDown = YES;
    [self dismiss];
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
    {
        [_delegate alertView:self clickedButtonAtIndex:0];
    }
}

- (void)defaultButtonClick
{
    if (_buttonDown)
    {
        return;
    }
    _buttonDown = YES;
    [self dismiss];
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
    {
        [_delegate alertView:self clickedButtonAtIndex:1];
    }
}

+ (void)cancelAlertWithDelegate:(id)delegate
{
    for (UAlertView *alert in __showedAlertView)
    {
        if (alert.delegate == delegate)
        {
            alert.delegate = nil;
        }
    }
}

+ (void)bringAlertToFront
{
    for (UAlertView *alert in __showedAlertView)
    {
        [[[[UIApplication sharedApplication] windows] lastObject] bringSubviewToFront:alert];
    }
}

@end
