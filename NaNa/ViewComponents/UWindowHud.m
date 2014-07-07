//
//  UWindowHud.m
//  NaNa
//
//  Created by dengfang on 12-6-6.
//  Copyright (c) 2012年 dengfang. All rights reserved.
//

#import "UWindowHud.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CGAffineTransform.h>

UWindowHud *currentHud = nil;
NSMutableArray *animationIDArray = nil;
static int contentLableTag = 0xFFCF;

// 用于UI的静态变量
static CGFloat defaultCornerRadius      =   2;
static CGFloat shadowCornerRadius       =   3;

@interface UWindowHud(Private)
+ (void)clearHud;
- (void)setContentString:(NSString*)str;
- (void)setContentString:(NSString *)string headHasImage:(BOOL)hasImage;
@end

@implementation UWindowHud
@synthesize canBeCanceled = _canBeCanceled;
@synthesize currentRequest = _currentRequest;
@synthesize contentView = _contentView;

// 动画的默认ID格式
static NSString *hideAnimationIDForm = @"hideAnimation%d";
//static NSString *beginAnimationIDForm = @"beginAnimation%d";

- (void)setCurrentRequest:(ASIHTTPRequest *)currentRequest {
    _currentRequest = currentRequest;
}

#pragma mark - Static Functions
// 创建Hud
+ (UWindowHud*)hudOnView:(UIView*)view  withType:(HudType)type {
    @synchronized(currentHud) {
        if (!currentHud) {
            currentHud = [[UWindowHud alloc] initWithFrame:view.bounds];
            animationIDArray = [[NSMutableArray alloc] init];
        }
        currentHud.backgroundColor = [UIColor clearColor];
        [currentHud removeFromSuperview];
        [view addSubview:currentHud];
        
        // 为当前的Hud创建一个唯一的ID，防止界面被其他的请求Hide
        NSString *animationID = [NSString stringWithFormat:hideAnimationIDForm, [animationIDArray count]];
        [animationIDArray addObject:animationID];
        
        // 装载控件
        [currentHud loadComponentsWithType:type];
        
        // 还原控件显示的优先等级
        HUD_LEVEL = 0;
        
        return currentHud;
    }
}

+ (UWindowHud*)hudOnView:(UIView*)view  withType:(HudType)type withRequest:(URequest*)request {
    // 根据Http请求和类型创建
    UWindowHud *hud = [UWindowHud hudOnView:view withType:type];
    [hud setCurrentRequest:request];
    return hud;
}

// 创建Hud
+ (UWindowHud*)hudWithType:(HudType)type {
    UIView *window = [APP_DELEGATE window];
    return [UWindowHud hudOnView:window withType:type];
}

// 根据类型和内容创建
+ (UWindowHud*)hudWithType:(HudType)type withContentString:(NSString*)string {
    // 根据Http请求和类型创建
    UWindowHud *hud = [UWindowHud hudWithType:type];
    if (kToastNaNaType == type || kToastHasImageNaNaType == type)
    {
        [hud setContentString:string headHasImage:kToastHasImageNaNaType == type];
    }
    else
    {
      [hud setContentString:string];
    }
    
    return hud;
}

// 根据Http请求和类型创建
+ (UWindowHud*)hudWithType:(HudType)type withRequest:(URequest*)request {
    UIView *window = nil;
    if (HUD_LEVEL > 0) {
        for (UIWindow *subwindow in [[UIApplication sharedApplication] windows]) {
            if ([subwindow.description hasPrefix:@"<UIText"]) {
                window = subwindow;
                break;
            }
        }
    }
    else {
        window = [APP_DELEGATE window];
    }
    return [UWindowHud hudOnView:window withType:type withRequest:request];
}

// 是否动画隐藏Hud
+ (void)hideAnimated:(BOOL)animated {
//    ULog(@"%s %d %p %p animated:%d", __FUNCTION__, __LINE__, currentHud, currentHud.currentRequest, animated);
    if (currentHud) {
        [currentHud setCurrentRequest:nil];
        currentHud->_canBeCanceled = YES;
        if (animated) {
            [UIView beginAnimations:[animationIDArray lastObject] context:NULL];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:currentHud];
            [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
            currentHud->_contentView.transform = CGAffineTransformMakeScale(1.1f, 1.15f);
            currentHud->_contentView.alpha = 0.02f;
            [UIView commitAnimations];
        }
        else {
            [UWindowHud clearHud];
        }
    }
}

// 根据请求完成来隐藏
+ (void)hideAnimated:(BOOL)animated withRequest:(URequest*)request {
    if (nil == currentHud.currentRequest) {
        [UWindowHud hideAnimated:YES];
    }
    else if (currentHud.currentRequest && currentHud.currentRequest == request) {
        [UWindowHud hideAnimated:YES];
    }
}

// 清除动画相关
+ (void)clearHud {
    [animationIDArray removeAllObjects];
    SAFERELEASE(animationIDArray)
    [currentHud removeFromSuperview];
    SAFERELEASE(currentHud);
}

#pragma mark - Life Functions

- (void)dealloc {
    _currentRequest = nil;
    SAFERELEASE(_defaultBGColor)
    SAFERELEASE(_shadowColor)
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _shadowEdgeWith = 2;
        _shadowOpacity = 0.55;
        _shadowOffset = CGSizeMake(-1, -1);
        _defaultBGColor = [[[UIColor blackColor] colorWithAlphaComponent:0.85] retain];
        _shadowColor = [[UIColor blackColor] retain];
    }
    return self;
}

// 根据当前的Hud类型创建对应的控件
- (void)loadComponentsWithType:(HudType)type {
    self.backgroundColor = [UIColor clearColor];
    if (_type == type ) {
        _contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _contentView.alpha = 1.0f;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAnimated:) object:self];
        if (kHttpLodingType != _type) {
            [self performSelector:@selector(hideAnimated:) withObject:self afterDelay:2.0f];
        }
//        ULog(@"%s %d %p %p retrun", __FUNCTION__, __LINE__, currentHud, currentHud.currentRequest);
        return;
    }
    
//    ULog(@"%s %d %p %p type = %d", __FUNCTION__, __LINE__, currentHud, currentHud.currentRequest, type);
    // 将不用的控件清理
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    _contentView = nil;
    _controlBtn = nil;
    // 清理当前的http请求指针
    _currentRequest = nil;
    // 初始化是否可以取消状态
    _canBeCanceled = YES;
    // 初始化动画状态
    _type = type;
    self.alpha = 1.0f;
    self.userInteractionEnabled = YES;
    
    // 重新加载新的控件
    if (kHttpLodingType == type) {
        // 内容View
        _contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 57)] autorelease];
        _contentView.backgroundColor = _defaultBGColor;
        _contentView.layer.cornerRadius = defaultCornerRadius;
        _contentView.layer.shadowRadius = shadowCornerRadius;
        _contentView.layer.shadowOpacity = _shadowOpacity;
        _contentView.layer.shadowOffset = CGSizeMake(-1, -1);
        _contentView.layer.shadowColor = _shadowColor.CGColor;
        CGRect rect = _contentView.bounds;
        rect.size.width = rect.size.width + _shadowEdgeWith;
        rect.size.height = rect.size.height + _shadowEdgeWith;
        CGPathRef pathRef = CGPathCreateWithRect(rect, &CGAffineTransformIdentity);
        _contentView.layer.shadowPath = pathRef;
        CFRelease(pathRef);
        _contentView.center = self.center;
        
        // 正在加载Label
        UILabel *contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 34)] autorelease];
        contentLabel.text = @"加载中...";
        contentLabel.tag = contentLableTag;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:default_font_size_14];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.textAlignment = UITextAlignmentCenter;
        [_contentView addSubview:contentLabel];
        contentLabel.center = CGPointMake(CGRectGetWidth(_contentView.bounds)/2, CGRectGetHeight(_contentView.bounds)/2);
        
        // 菊花~
        UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        indicator.frame = CGRectMake(0, 0, 20, 20);
        [_contentView addSubview:indicator];
        indicator.center = CGPointMake(45, CGRectGetHeight(_contentView.bounds)/2);
        [indicator startAnimating];
    }
    else if (kToastType == type) {
        // 内容View
        _contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 45)] autorelease];
        _contentView.backgroundColor = _defaultBGColor;
        _contentView.layer.cornerRadius = defaultCornerRadius;
        _contentView.layer.shadowRadius = shadowCornerRadius;
        _contentView.layer.shadowOpacity = _shadowOpacity;
        _contentView.layer.shadowOffset = _shadowOffset;
        _contentView.layer.shadowColor = _shadowColor.CGColor;
        CGRect rect = _contentView.bounds;
        rect.size.width = rect.size.width + _shadowEdgeWith;
        rect.size.height = rect.size.height + _shadowEdgeWith;
        CGPathRef pathRef = CGPathCreateWithRect(rect, &CGAffineTransformIdentity);
        _contentView.layer.shadowPath = pathRef;
        CFRelease(pathRef);
        _contentView.center = self.center;
        
        // 内容Label
        UILabel *contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 34)] autorelease];
        contentLabel.tag = contentLableTag;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:default_font_size_14];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.textAlignment = UITextAlignmentCenter;
        contentLabel.numberOfLines = 2;
        [_contentView addSubview:contentLabel];
        contentLabel.center = CGPointMake(CGRectGetWidth(_contentView.bounds)/2, CGRectGetHeight(_contentView.bounds)/2);
        
        [self performSelector:@selector(hideAnimated:) withObject:self afterDelay:2.0f];
    }
    else if (kToastNaNaType == type || type == kToastHasImageNaNaType)
    {
        // 内容View
        _contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 80)] autorelease];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.center = self.center;
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
        layer.frame = CGRectMake(0, 0, 220, 20);
        [_contentView.layer addSublayer:layer];
        
        // 内容Label
        UILabel *contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 34)] autorelease];
        contentLabel.tag = contentLableTag;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:default_font_size_14];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.textAlignment = UITextAlignmentCenter;
        contentLabel.numberOfLines = 2;
        [_contentView addSubview:contentLabel];
        contentLabel.center = CGPointMake(CGRectGetWidth(_contentView.bounds)/2, CGRectGetHeight(_contentView.bounds)/2);
        
        [self performSelector:@selector(hideAnimated:) withObject:self afterDelay:2.0f];
    }
    
    [self addSubview:_contentView];
}

// 设置Toast内容
- (void)setContentString:(NSString*)str {
    UILabel * contantLabel = (UILabel*)[_contentView viewWithTag:contentLableTag];
    contantLabel.text = str;
    
    if ([str sizeWithFont:[UIFont systemFontOfSize:default_font_size_14] constrainedToSize:contantLabel.bounds.size].height > default_font_size_18) {
        _contentView.frame = CGRectMake(0, 0, 220, 64);
        _contentView.center = self.center;
        CGRect rect = _contentView.bounds;
        rect.size.width = rect.size.width + _shadowEdgeWith;
        rect.size.height = rect.size.height + _shadowEdgeWith;
        CGPathRef pathRef = CGPathCreateWithRect(rect, &CGAffineTransformIdentity);
        _contentView.layer.shadowPath = pathRef;
        CFRelease(pathRef);
        contantLabel.center = CGPointMake(CGRectGetWidth(_contentView.bounds)/2, CGRectGetHeight(_contentView.bounds)/2);
    }
    else {
        _contentView.frame = CGRectMake(0, 0, 220, 45);
        _contentView.center = self.center;
        CGRect rect = _contentView.bounds;
        rect.size.width = rect.size.width + _shadowEdgeWith;
        rect.size.height = rect.size.height + _shadowEdgeWith;
        CGPathRef pathRef = CGPathCreateWithRect(rect, &CGAffineTransformIdentity);
        _contentView.layer.shadowPath = pathRef;
        CFRelease(pathRef);
        contantLabel.center =CGPointMake(CGRectGetWidth(_contentView.bounds)/2, CGRectGetHeight(_contentView.bounds)/2);
    }
}

- (void)setContentString:(NSString *)string headHasImage:(BOOL)hasImage
{
    UILabel * contantLabel = (UILabel*)[_contentView viewWithTag:contentLableTag];
    contantLabel.text = string;
    CGSize size = [string sizeWithFont:contantLabel.font constrainedToSize:CGSizeMake(220, 100) lineBreakMode:NSLineBreakByWordWrapping];
    if (hasImage)
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((220 - size.width - 30)/2, 20 +(60-30)/2, 30, 30)];
        image.image = [UIImage imageNamed:@"toast_success.png"];
        [_contentView addSubview:image];
        contantLabel.frame = CGRectMake(CGRectGetMaxX(image.frame), 20 + (60-size.height)/2, size.width, size.height);
        [image release];
    }
    else
    {
        contantLabel.frame = CGRectMake((220 - size.width)/2 , 20 + (60-size.height)/2, size.width, size.height);
    }
}

// Hide动画结束的回调函数
- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
    if ([animationID isEqualToString:[animationIDArray lastObject]]) {
        [UWindowHud clearHud];
    }
}

     
// 取消页面
- (void)hideAnimated:(BOOL)animated {
    [UWindowHud hideAnimated:animated];
}


// 设置是否可被取消
- (void)setCanBeCanceled:(BOOL)canBeCanceled {
//    if (kHttpLodingType == _type) {
//        if (_canBeCanceled != canBeCanceled) {
//            _canBeCanceled = canBeCanceled;
//            if (_canBeCanceled) {
//                _controlBtn.hidden = NO;
//                _contentView.frame = CGRectMake(0, 0, 228, 57);
//                _contentView.center = self.center;
//            }
//            else {
//                _controlBtn.hidden = YES;
//                _contentView.frame = CGRectMake(0, 0, 228-57-2, 57);
//                _contentView.center = self.center;
//            }
//        }
//    }
}

#pragma mark - Cancel Btn Response

- (void)cancelBtnClicked:(id)sender {
    if ([self.currentRequest respondsToSelector:@selector(clearDelegatesAndCancel)]) {
        [self.currentRequest clearDelegatesAndCancel];
        _currentRequest = nil;
    }
    
    [UWindowHud hideAnimated:YES];
}

@end
