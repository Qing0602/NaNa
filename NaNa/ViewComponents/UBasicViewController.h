//
//  UBasicViewController.h
//  NaNa
//
//  Created by dengfang on 13-7-8.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import "NaNaUIManagement.h"
#import "MBProgressHUD.h"

@class TTTAttributedLabel;

typedef enum {
    UNavBarBtnTypeHide = 0, // 将按钮隐藏
    UNavBarBtnTypeBack,     // 返回样式
    UNavBarBtnTypeMenu,     // 菜单样式
    UNavBarBtnTypeTa,       // 首页的右菜单-她们
    UNavBarBtnTypeNext,     // 下一步样式
    UNavBarBtnTypeSubmit,
} UNavBarBtnType;

typedef enum {
    ACCOUNT_INFO_TYPE_USERID = 0 , // userID
    
} ACCOUNT_INFO_TYPE;

@interface UBasicViewController : UIViewController<MBProgressHUDDelegate> {
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
@property (nonatomic,strong) MBProgressHUD *progressHUD;

- (void)setTitle:(NSString *)title;
- (void)setNavLeftType:(UNavBarBtnType)leftType navRightType:(UNavBarBtnType)rightType;
- (void)pushPage:(UBasicViewController *)controller;
- (void)setSideMenuController;
- (void)removeSideMenuController;

-(NSString *)getAccountValueByKey : (ACCOUNT_INFO_TYPE)type;


/*! @brief 判断字符串是否是nil或者是@“”
 *
 */
-(BOOL) stringIsNilOrEmpty : (NSString *) str;

#pragma mark -
#pragma mark MBProgressHUD Methods
-(void) showProgressWithText : (NSString *) context;
-(void) showProgressWithText : (NSString *) context dimBackground : (BOOL) isBackground;
/*
 AutoCloseInNetwork方法在网络层调用正确时，自动关闭浮层，UI层如果需要显示完成信息的话使用[showProgressWithText:context withDelayTime:sec] 方法
 当网络访问出错时，错误浮层自动更换，UI层无需实现，如不须显示错误信息，UI层重写[showProgressWithText:context withDelayTime:sec]方法
 */
-(void) showProgressOnwindowsWithText : (NSString *) context withDelayTime : (NSUInteger) sec;
-(void) showProgressWithText : (NSString *) context withDelayTime : (NSUInteger) sec;
// 针对于大数据处理、视频处理、及一些及其消耗时间的本地处理等情况
-(void) showWhileExecuting : (SEL) sel withText : (NSString *) text withDetailText : (NSString *) detailText;
-(void) closeProgress;
@end
