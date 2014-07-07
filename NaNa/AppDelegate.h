//
//  AppDelegate.h
//  NaNa
//
//  Created by dengfang on 13-6-30.
//  Copyright (c) 2013年 dengfang. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "UAlertView.h"
#import "MMDrawerController.h"
#import "MenuLeftVC.h"
#import "MenuRightVC.h"

#define APP_DELEGATE    ((AppDelegate*)[[UIApplication sharedApplication] delegate])  // 当前AppDelegate实例
#define MAIN_BOUNDS     APP_DELEGATE.mainWindowBounds  // 获取当前屏幕的Bounds大小
#define windowHeight    APP_DELEGATE.screenHeight  // 获取当前屏幕的高度

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UAlertViewDelegate> {
    // 根视图
    MMDrawerController *_rootViewController;
    //UINavigationController * _navRootController ;
}

@property (strong, nonatomic) UIWindow *window;  // 主Window
@property (assign, nonatomic) CGRect mainWindowBounds;  // 主屏幕大小
@property (assign, nonatomic) CGFloat screenHeight;  // 主屏幕高度
@property (readonly, nonatomic) MMDrawerController *rootViewController; // 根视图（侧边栏 + 中间视图）
//@property (readonly, nonatomic) UINavigationController * navRootController ; // 根导航器


- (void)loadMainView;
@end
