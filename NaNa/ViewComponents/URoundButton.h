//
//  URoundButton.h
//  NaNa
//
//  Created by dengfang on 13-9-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URoundButton : UIView {
    UIImageView           *_imageView;
    UIImage               *_normalBGImage;
    UIImage               *_highlightBGImage;
    UILabel               *_titleLable;
    NSString              *_normalText;
    NSString              *_highText;
    UIColor               *_normalTextColor;
    UIColor               *_highlightTextColor;
    id                    _delegate;
    UIControlEvents       _downControlEvent;
    UIControlEvents       _upcontrolEvent;
    SEL                   _downAction;
    SEL                   _upAction;
}


@property (nonatomic, retain) UIImageView *imageView;       // 设置图片
@property (nonatomic, retain) UIImage *normalImage;         // 正常状态下的Image
@property (nonatomic, retain) UIImage *highlightImage;      // 高亮状态下的Image
@property (nonatomic, retain) UILabel *titleLable;          // 显示lable
@property (nonatomic, copy)   NSString *normalText;         // 正常状态下的文字
@property (nonatomic, copy)   NSString *highText;           // 高亮状态下的文字
@property (nonatomic, retain) UIColor *normalTextColor;     // 正常状态下的TextColor
@property (nonatomic, retain) UIColor *highlightTextColor;  // 高亮状态下的TextColor
@property (nonatomic) UIControlEvents downControlEvent;     // 按下事件
@property (nonatomic) UIControlEvents upControlEvent;       // 抬起事件


// 设置背景
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

// 设置文字
- (void)setTitle:(NSString *)title forState:(UIControlState)state;

// 设置文字颜色
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

// 点击事件
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

