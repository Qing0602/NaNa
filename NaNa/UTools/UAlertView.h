//
//  UAlertView.h
//  UBoxOnline
//
//  Created by sun huayu on 13-6-6.
//  Copyright (c) 2013年 ubox. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UAlertView;

@protocol UAlertViewDelegate <NSObject>
@optional
// 0是取消键，1是确定键
- (void)alertView:(UAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface UAlertView : UIControl
{
    UIView          *_alert;
    UILabel         *_titleLabel;
    UILabel         *_messageLabel;
    UIButton        *_cancelButton;
    UIButton        *_defaultButton;
    id<UAlertViewDelegate>              _delegate;
    BOOL            _buttonDown;
}

@property (nonatomic,retain)UILabel           *messageLabel;
@property (nonatomic,readonly)UIButton        *cancelButton;
@property (nonatomic,readonly)UIButton        *defaultButton;
@property (nonatomic,assign)id<UAlertViewDelegate>              delegate;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<UAlertViewDelegate>)delegate
       cancelButton:(NSString *)cancelButton
      defaultButton:(NSString *)defaultButton;

- (void)show;

+ (UAlertView *)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                      delegate:(id<UAlertViewDelegate>)delegate
                  cancelButton:(NSString *)cancelButton
                 defaultButton:(NSString *)defaultButton;


- (id)initWithMessage:(NSString *)message
           delegate:(id<UAlertViewDelegate>)delegate
       cancelButton:(NSString *)cancelButton
      defaultButton:(NSString *)defaultButton;

+ (UAlertView *)showAlertViewWithMessage:(NSString *)message
                              delegate:(id<UAlertViewDelegate>)delegate
                          cancelButton:(NSString *)cancelButton
                         defaultButton:(NSString *)defaultButton;

+ (void)cancelAlertWithDelegate:(id)delegate;

+ (void)bringAlertToFront;

@end
