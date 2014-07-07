//
//  UBasicViewController.h
//  NaNa
//
//  Created by dengfang on 13-7-8.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"

@class TTTAttributedLabel;

typedef enum {
    UNavBarBtnTypeHide = 0, // 将按钮隐藏
    UNavBarBtnTypeBack,     // 返回样式
    UNavBarBtnTypeMenu,     // 菜单样式
    UNavBarBtnTypeTa,       // 首页的右菜单-她们
    UNavBarBtnTypeNext,     // 下一步样式
    UNavBarBtnTypeSubmit,
} UNavBarBtnType;

@interface UBasicViewController : UIViewController {
    UIView              *_navBarView;   // NavBar
    UIButton            *_leftItem;     // Nav左侧按钮
    UIButton            *_rightItem;    // Nav右侧按钮
    TTTAttributedLabel  *_titleItem;    // Nav中间标题
    UIView              *_defaultView;  // 用于存放子控件的View
    UNavBarBtnType      _leftBtnType;   // 左侧按钮类型
    UNavBarBtnType      _rightBtnType;  // 右侧按钮类型
    
}

// 用于存放子控件的View
@property (nonatomic, retain) UIView *navBarView;
@property (nonatomic, readonly) UIView *defaultView;
@property (nonatomic, retain) UIButton *leftItem;
@property (nonatomic, retain) UIButton *rightItem;
@property (nonatomic, retain) TTTAttributedLabel *titleItem;
@property (nonatomic, assign) BOOL currentDeviceLateriOS7;


- (void)setTitle:(NSString *)title;
- (void)setNavLeftType:(UNavBarBtnType)leftType navRightType:(UNavBarBtnType)rightType;
- (void)pushPage:(UBasicViewController *)controller;
- (void)setSideMenuController;
- (void)removeSideMenuController;
@end
