//
//  UStaticData.h
//  NaNa
//
//  Created by dengfang on 13-3-1.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequestDelegate.h"

// =========================================== 分割线 =====================================================

// 用户相关信息类
@interface UBoxUserInfo : NSObject
// 用于标识（UID）
@property (nonatomic, copy) NSString    *identifier;
// 用于的余额
@property (nonatomic, copy) NSString    *balance;
// 用户手机号
@property (nonatomic, copy) NSString    *phone;
// 为取数目
@property (nonatomic, assign)NSInteger  productCount;
// 密码锁
@property (nonatomic, copy)NSString   *password;
@end

// =========================================== 分割线 =====================================================

typedef enum {
    UStaticDataRequestConfig = 1,
    UStaticDataRequestUPlusAPP,
}UStaticDataRequestType;

// 静态的数据管理类
@interface UStaticData : NSObject <ASIHTTPRequestDelegate> {
    // 用于显示当前用户的相关信息
    UBoxUserInfo    *_userInfo;
    // 用于获取当前的MacAddress
    NSString        *_macAddress;
    // 用于获取当前的IPAddress
    NSString        *_ipAddress;
    // 用于获取当前的IOS系统版本
    NSString        *_sysVersion;
    // 用于获取当前的手机信息（如：iphone ipad等）
    NSString        *_deviceInfo;
    // 用于获取当前的渠道号码
    NSString        *_channelID;
    // 用于判断是否启动过
    BOOL            hasLaunch;
}
// 用于显示当前用户的相关信息
@property (nonatomic, retain) UBoxUserInfo    *userInfo;

// 用于获取当前的MacAddress
@property (nonatomic, readonly) NSString        *macAddress;

// 用于获取当前的IOS系统版本
@property (nonatomic, readonly) NSString        *sysVersion;

// 用于获取当前的IOS系统版本
@property (nonatomic, readonly) NSString        *deviceInfo;

// 用于显示当前的渠道号码
@property (nonatomic, readonly) NSString        *channelID;

// 用于保存Push用的Token
@property (nonatomic, retain)   NSString        *pushToken;

// 用于GIS中的经度
//@property (nonatomic, assign)   CLLocationDegrees   longitude;

// 用于GIS中的维度
//@property (nonatomic, assign)   CLLocationDegrees   latitude;

// 当前Config的md5值
//@property (nonatomic, copy)     NSString        *configMD5;

// 用于获取升级URL
//@property (nonatomic, retain)    NSString        *updateUrl;

// 用于获取升级的提示信息
//@property (nonatomic, retain)    NSString        *updateMessage;

// 有升级提示的时候记录服务器所给版本号
//@property (nonatomic, retain)    NSString        *severVersion;

// 建议升级是否弹过alert
//@property (nonatomic, assign)    BOOL            isShowSuggestUpdateAlert;

// 记录是否是从别的tabbar切入取货tababr下
//@property (nonatomic, assign)    BOOL            isCutPickUpTabbar;

// 记录已弹出签名错误alert
//@property (nonatomic, assign)    BOOL            isShowSignErrorAlert;

// 是否启动过
@property (nonatomic, assign)   BOOL            hasLaunch;

// 是否已经登录
+ (BOOL)hasLogin;

+ (BOOL)firstLaunch;

+ (NSString*)hasPassword;

// 返回当前的defaultStaticData
+ (UStaticData*)defaultStaticData;

// 用于获取当前的Config文件
- (void)getConfigFile;

//// 保存用户的余额
//+ (BOOL)saveUserBalance;

// 做一些数据的保存相关方法（不区分用户的）
+ (BOOL)saveObject:(id)data forKey:(NSString*)key;

// 获取一些数据的相关方法（不区分用户的）
+ (id)getObjectForKey:(NSString*)key;

// 做一些数据的保存相关方法（区分用户的）
+ (BOOL)saveObject:(id)data forKey:(NSString*)key forUser:(NSString*)user;

// 获取一些数据的相关方法（区分用户的）
+ (id)getObjectForKey:(NSString*)key forUser:(NSString*)user;

// 清理用户缓存数据（区分用户的）
+ (BOOL)clearUserData:(NSString*)user;

// 获取当前的时间戳
+ (NSString*)timeStamp;

// 所登出调用
+ (void)logout;


@end
