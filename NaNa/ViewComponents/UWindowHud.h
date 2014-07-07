//
//  UWindowHud.h
//  NaNa
//
//  Created by dengfang on 12-6-6.
//  Copyright (c) 2012年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URequest.h"

typedef enum {
    kDefaultType,
    kHttpLodingType,
    kToastType,
    kToastNaNaType,
    kToastHasImageNaNaType
}HudType;

int HUD_LEVEL;

@interface UWindowHud : UIControl {
    HudType         _type;
    BOOL            _canBeCanceled;
    CGFloat         _shadowEdgeWith;
    CGSize          _shadowOffset;
    UIColor         *_defaultBGColor;
    UIColor         *_shadowColor;
    CGFloat         _shadowOpacity;
@private
    UIView          *_contentView;      //不用管理内存
    UIButton        *_controlBtn;       //不用管理内存
    ASIHTTPRequest  *_currentRequest;
}

@property (nonatomic, readonly) ASIHTTPRequest      *currentRequest;
@property (nonatomic, assign)   BOOL                canBeCanceled;
@property (nonatomic, readonly) UIView              *contentView;

// 根据Http请求、页面和类型创建
+ (UWindowHud*)hudOnView:(UIView*)view  withType:(HudType)type withRequest:(URequest*)request;

// 根据父页面和类型创建
+ (UWindowHud*)hudOnView:(UIView*)view  withType:(HudType)type;

// 根据Http请求和类型创建
+ (UWindowHud*)hudWithType:(HudType)type withRequest:(URequest*)request;

// 根据类型创建
+ (UWindowHud*)hudWithType:(HudType)type;

// 根据类型和内容创建
+ (UWindowHud*)hudWithType:(HudType)type withContentString:(NSString*)string;

// 根据请求完成来隐藏
+ (void)hideAnimated:(BOOL)animated withRequest:(URequest*)request;

// 根据是否动画来隐藏
+ (void)hideAnimated:(BOOL)animated;

@end
