//
//  AppDelegate.m
//  NaNa
//
//  Created by dengfang on 13-6-30.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "UBasicViewController.h"
#import "URequestManager.h"
#import "UStaticData.h"
#import "UWindowHud.h"
#import "iConsole.h"
#import "RankingListVC.h"
#import "LoginVC.h"
#import "SignVC.h"
#import "PasswordLockVC.h"
#import "NaNaUIManagement.h"

#import "PasswordLockViewController.h"
#pragma mark - Static Variable
// 用于判断当前是否为iPhone5的屏幕设备
BOOL isIPhone5Screen =  NO;

// 唤醒的ID
NSInteger K_WAKE_UP_ID = 0;

#pragma mark - Implementation

@implementation AppDelegate
@synthesize rootViewController = _rootViewController;
//@synthesize navRootController = _navRootController;


- (void)dealloc
{
    [_window release];
    SAFERELEASE(_rootViewController)
//    SAFERELEASE(_navRootController)
    [super dealloc];
}

- (void)loadMainView {
    
    
    
    // 初始化左右中间视图
    RankingListVC *centerController = [[[RankingListVC alloc] init] autorelease];
    MenuLeftVC *leftController = [[[MenuLeftVC alloc] init] autorelease];
    MenuRightVC *rightContoller = [[[MenuRightVC alloc] init] autorelease];
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:centerController] autorelease];
    navController.navigationBarHidden = YES;
    
    SAFERELEASE(_rootViewController)
    if (!_rootViewController) {
        _rootViewController = [[MMDrawerController alloc] initWithCenterViewController:navController
                                                              leftDrawerViewController:leftController
                                                             rightDrawerViewController:rightContoller];
        
    }

    [_rootViewController setMaximumLeftDrawerWidth:sideWidth];
    [_rootViewController setMaximumRightDrawerWidth:sideWidth];
    [_rootViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_rootViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.window setRootViewController:_rootViewController];
//    if ([UStaticData hasPassword]==Nil) {
//        PasswordLockVC * lock=[[PasswordLockVC alloc] initWithType:0];
//        [self.window addSubview:lock.view];
//    }

}
-(void)loadLoginView
{
    UINavigationController * _navRootController = [UINavigationController alloc];
    LoginVC * loginVc=[[LoginVC alloc] init];
    _navRootController=[_navRootController initWithRootViewController:loginVc];
    _navRootController.navigationBarHidden = YES;
    [self.window setRootViewController:_navRootController];
    SAFERELEASE(_navRootController);
}
-(void)loadSignView
{
    UINavigationController * _navRootController = [UINavigationController alloc];
    if(![[NaNaUIManagement sharedInstance].userAccount.seckey isEqualToString:@""] && [NaNaUIManagement sharedInstance].userAccount.UserID)
    {
        NSDictionary *lockData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
        if (lockData) {
            BOOL needLock = [lockData[PWD_LOCK_STATUS] boolValue];
            if (needLock) {
                PasswordLockViewController *pwdLock = [[PasswordLockViewController alloc] initWithType:VERIFY_TYPE_VERIFY];
                _navRootController=[_navRootController initWithRootViewController:pwdLock];
                [_navRootController setNavigationBarHidden:YES];
                [self.window setRootViewController:_navRootController];
                
                [pwdLock release];
            }else [self loadMainView];
        }else
        {
            [self loadMainView];
        }

        //[self loadMainView];
    }
    else
    {
        LoginVC * loginVc=[[LoginVC alloc] init];
        _navRootController=[_navRootController initWithRootViewController:loginVc];
        _navRootController.navigationBarHidden = YES;
        [self.window setRootViewController:_navRootController];
        SAFERELEASE(_navRootController);
    }

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WeiboSDK registerApp:kAppKey];
    // 首先创建Window
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // 用于初始化全局变量，例如获取系统屏幕大小，是否为IPhone5设备等
    [self initStaticData];
    
    // 创建根界面
//    [self initRootViewController];//稍后添加
    if ([UStaticData firstLaunch]) {
        
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:1];
    
    [self loadSignView];
    self.window.backgroundColor = windowColor;
    [self.window makeKeyAndVisible];
    
    return YES;
}

// 用于初始化根视图等页面
- (void)initRootViewController {
//    // 首先去自动登录
//    [LoginVCLogic autoLogin:^(BOOL isFinish) {
//    }];
    
    UIViewController *logoVC = [[[UIViewController alloc] init] autorelease];
    logoVC.view.backgroundColor = default_color_white;
    UIImageView *logo = [[[UIImageView alloc] initWithImage:isIPhone5Screen ?
                          [UIImage imageNamed:@"Default-568h.png"]:
                          [UIImage imageNamed:@"Default.png"]] autorelease];
    [logoVC.view addSubview:logo];
    [self.window setRootViewController:logoVC];
    
    [self performSelector:@selector(startRootViewController) withObject:nil afterDelay:0.5];
}

- (void)startRootViewController {
    // 用一个渐隐的动画过渡
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = kCATransitionFade;
    [self.window.layer addAnimation:animation forKey:@"CATransition"];
    
//    // 创建根页面
//    SAFERELEASE(_rootViewController)
//    if (!_rootViewController) {
//        _rootViewController = [[UBasicTabController alloc] init];
//        [self.window setRootViewController:_rootViewController];
//    }
}

// 用于初始化全局变量，例如获取系统屏幕大小，是否为IPhone5设备等
- (void)initStaticData {
    // 清除未读消息数目
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 注册当前的token
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    // 初始化HttpManager
    [URequestManager defaultRequestManager];
    
    // 获取当前屏幕的大小
    self.mainWindowBounds = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]),
                                       CGRectGetHeight([[UIScreen mainScreen] bounds]));
    self.screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    // 获取当前是否为iPhone5的屏幕
    if (self.mainWindowBounds.size.height > 480) {
        isIPhone5Screen = YES;
    }
    
    // 初始化数据中心
    [[UStaticData defaultStaticData] getConfigFile];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    ULog(@"didRegisterForRemoteNotificationsWithDeviceToken %@", deviceToken);
    NSMutableString *token = [NSMutableString stringWithString:[deviceToken description]];
    [UStaticData defaultStaticData].pushToken = [token stringByTrimmingCharactersInSet:
                                                 [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [UStaticData saveObject:[UStaticData defaultStaticData].pushToken forKey:DEVICE_TOKEN];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    ULog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    // 保存当前用户的余额(如果用户登陆的情况下)
//    [UStaticData saveUserBalance];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 清除未读消息数目
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // 保存当前用户的余额(如果用户登陆的情况下)
//    [UStaticData saveUserBalance];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}


#pragma mark - 强制升级alert的提示
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    if (alertView.tag == EServerErrorEnforceUpdate || alertView.tag == EServerErrorSuggestUpdate) {
        UIView *view = [alertView.subviews objectAtIndex:2];
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *messageLabel = (UILabel *)view;
            messageLabel.textAlignment = NSTextAlignmentLeft;
        }
    }
}
@end

