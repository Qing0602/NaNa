//
//  UStaticData.m
//  NaNa
//
//  Created by dengfang on 13-3-1.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "UStaticData.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "MD5.h"
#import "URequest.h"
#import "URequestManager.h"

static UStaticData  *defaultStaticData = nil;

#pragma mark - UBoxUserInfo

@implementation UBoxUserInfo

@synthesize identifier,balance,phone, productCount;

- (void)dealloc {
    self.identifier = nil;
    self.balance = nil;
    self.phone = nil;
    [super dealloc];
}

@end

#pragma mark - UStaticData
// =========================================== 分割线 =====================================================

@implementation UStaticData
@synthesize userInfo = _userInfo, macAddress = _macAddress;
@synthesize sysVersion = _sysVersion;
@synthesize deviceInfo = _deviceInfo;
@synthesize pushToken;
@synthesize hasLaunch;
//@synthesize configMD5;
//@synthesize updateUrl;
//@synthesize updateMessage;
//@synthesize severVersion;
//@synthesize isShowSuggestUpdateAlert;
//@synthesize isCutPickUpTabbar;
//@synthesize isShowSignErrorAlert;

#pragma mark - Static Methods

// 返回当前的defaultStaticData
+ (UStaticData*)defaultStaticData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultStaticData = [[UStaticData alloc] init];
        
    });
    return defaultStaticData;
}

// 是否已经登录
+ (BOOL)hasLogin {
    return [[UStaticData defaultStaticData].userInfo.identifier length] ? YES : NO;
}

+ (BOOL)firstLaunch {
    return [UStaticData defaultStaticData].hasLaunch;
}


// 是否有密码
+ (NSString*)hasPassword {
    if([[UStaticData defaultStaticData].userInfo.password length]>0)
        return [UStaticData defaultStaticData].userInfo.password;
    else
        return Nil;
}




// 做一些数据的保存相关方法
+ (BOOL)saveObject:(id)data forKey:(NSString*)key {
    if (!data && key) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    else if (key) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    }
    else {
        assert(data);
    }
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取一些数据的相关方法（不区分用户的）
+ (id)getObjectForKey:(NSString*)key {
    id result = [[NSUserDefaults standardUserDefaults] objectForKey:key];

    return result;
}

// 做一些数据的保存相关方法（区分用户的）
+ (BOOL)saveObject:(id)data forKey:(NSString*)key forUser:(NSString*)user {
    if ([key length] == 0 || [user length] == 0 || data == nil) {
        return NO;
    }
    
    // 判断当前文件夹是否存在
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dirPath = [path stringByAppendingPathComponent:user.md5];
    if (![fileManger fileExistsAtPath:dirPath]) {
        [fileManger createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 保存的文件路径
    NSString *filePath = [dirPath stringByAppendingFormat:@"/%@.plist",key.md5];
    // 返回保存结果
    return [NSKeyedArchiver archiveRootObject:data toFile:filePath];
}

// 获取一些数据的相关方法（区分用户的）
+ (id)getObjectForKey:(NSString*)key forUser:(NSString*)user {
    if ([key length] == 0 || [user length] == 0) {
        return nil;
    }
    
    // 判断当前文件夹是否存在
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dirPath = [path stringByAppendingPathComponent:user.md5];
    // 对应的保存文件路径
    NSString *filePath = [dirPath stringByAppendingFormat:@"/%@.plist",key.md5];
    if (![fileManger fileExistsAtPath:filePath]) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (BOOL)clearUserData:(NSString *)user {
    if ([user length] == 0) {
        return NO;
    }
    
    // 判断当前文件夹是否存在
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dirPath = [path stringByAppendingPathComponent:user.md5];
    NSError *error = nil;
    if ([fileManger fileExistsAtPath:dirPath]) {
        [fileManger removeItemAtPath:dirPath error:&error];
//        ULog(@"error.code =%d error.userInfo = %@",error.code , error.userInfo);
        if (error.code == noErr) {
            
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return YES;
    }
}

// 获取当前的时间戳
+ (NSString*)timeStamp {
    NSDate *now = [NSDate date];
    return [NSString stringWithFormat:@"%ld",(unsigned long)[now timeIntervalSince1970]];
}

+ (void)logout {
    [UStaticData clearUserData:[[[UStaticData defaultStaticData] userInfo] identifier]];
    [UStaticData defaultStaticData].userInfo = nil;
    [UStaticData saveObject:@"" forKey:USER_ACCOUNT];
    [UStaticData saveObject:@"" forKey:USER_PHONE];
    [UStaticData saveObject:@"" forKey:USER_UID];
    [UStaticData saveObject:@"" forKey:USER_PASSWD];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOGOUT object:nil];
}

#pragma mark - Common Methods

- (void)dealloc {
    SAFERELEASE(_userInfo)
    SAFERELEASE(_macAddress)
    SAFERELEASE(_ipAddress)
    SAFERELEASE(_sysVersion)
    SAFERELEASE(_deviceInfo)
    SAFERELEASE(_channelID)
    self.pushToken = nil;
//    self.updateMessage = nil;
//    self.updateUrl = nil;
    [super dealloc];
}


- (id)init {
    self = [super init];
    if (self) {
        _userInfo = nil;
        self.hasLaunch=NO;
//        self.updateUrl = nil;
//        self.updateMessage = nil;
//        self.severVersion = nil;
//        self.isCutPickUpTabbar = YES;
//        self.longitude = .0f;
//        self.latitude = .0f;
        self.pushToken = [UStaticData getObjectForKey:DEVICE_TOKEN];
        if (!self.pushToken) {
            self.pushToken = @"";
        }
//        self.configMD5 = [UStaticData getObjectForKey:CONFIG_MD5];
    }
    return self;
}

// 用于获取当前的MacAddress
- (NSString*)macAddress {
    // 当为空字符串的时候，则去查找，不为空的情况下，使用内存中的数据
    if (!_macAddress) {
        int                 mib[6];
        size_t              len;
        char                *buf;
        unsigned char       *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl  *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex("en0")) == 0) {
            printf("Error: if_nametoindex error\n");
            goto emptyMacAddress;
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 1\n");
            goto emptyMacAddress;
        }
        
        if ((buf = malloc(len)) == NULL) {
            printf("Could not allocate memory. error!\n");
            goto emptyMacAddress;
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            free(buf);
            printf("Error: sysctl, take 2");
            goto emptyMacAddress;
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        _macAddress = [[NSString alloc] initWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                               *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        // NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
        //                       *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        free(buf);
        return _macAddress;
emptyMacAddress:
        _macAddress = [[NSString alloc] initWithString:@""];
    }
    return _macAddress;
}

// 用于获取当前的IOS系统版本
- (NSString*)sysVersion {
    if (!_sysVersion) {
        _sysVersion = [[NSString alloc] initWithString:[[UIDevice currentDevice] systemVersion]];
    }
    return _sysVersion;
}

// 用于获取当前渠道号码
- (NSString*)channelID {
    if (!_channelID) {
        // 渠道文件路径
        NSString *channelFilePath = [[NSBundle mainBundle] pathForResource:@"channel_id" ofType:@"dat"];
        // 获取渠道ID
        NSString *channelStr = [NSString stringWithContentsOfFile:channelFilePath encoding:NSUTF8StringEncoding error:nil];
        if ([channelStr length]) {
            _channelID = [channelStr copy];
        }
        else {
            _channelID = [[NSString alloc] initWithString:@"0"];
        }
    }
    return _channelID;
}

// 用于获取当前的IOS系统版本
- (NSString*)deviceInfo {
    if (!_deviceInfo) {
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        _deviceInfo = [[NSString alloc] initWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
    }
    return _deviceInfo;
}

// 用于获取当前的Config文件
- (void)getConfigFile {
    // 判断当前是否已经存在一个，Config的请求，如果存在，则不再发送请求
    /*
    BOOL hasExistRequest = NO;
    for (URequest *tempRequest in [URequestManager unfinishedRequestWithDelegate:self]) {
        if (tempRequest.tag == UStaticDataRequestConfig) {
            hasExistRequest = YES;
            break;
        }
    }
    
    // 如果没有Config请求，则发送广告请求
    if (!hasExistRequest) {
        NSString *param = [NSString stringWithFormat:@"config=%@", [UStaticData getObjectForKey:CONFIG_MD5]];
        URequest *configRequest = [[[URequest alloc] initWithDomain:K_DOMAIN_NANA withPath:K_URL_CONFIG
                                                          withParam:param] autorelease];
        configRequest.allowedToast = NO;
        configRequest.allowedAlert = NO;
        configRequest.tag = UStaticDataRequestConfig;
        configRequest.delegate = self;
        configRequest.queuePriority = NSOperationQueuePriorityVeryHigh;
        configRequest.numberOfTimesToRetryOnTimeout = 3;
        [URequestManager addBackgroundRequest:configRequest];
    }
     */
}

- (void)updateLocalTime {
//    NSString *localTime = [[[NSDate date] description] substringToIndex:10];
//    [UStaticData saveObject:localTime forKey:U_PLUS_APP_UPDATE];
}

#pragma mark - ASIHttpRequestDelegate
- (void)requestFinished:(URequest *)request {
    switch (request.tag) {
        case UStaticDataRequestConfig:
            [self didGetConfig:request];
            break;
        default:
            break;
    }
}

- (void)requestFailed:(URequest *)request {
    
}

- (void)didGetConfig:(URequest*)request {
    ULog(@"%@", request.parsedDict ? request.parsedDict: request.responseString)
    
    if (request.parsedDict) {
        [UStaticData saveObject:[[request.parsedDict objectForKey:@"header"] objectForKey:@"ConfigFile"] forKey:CONFIG_MD5];
//        self.configMD5 = [[request.parsedDict objectForKey:@"header"] objectForKey:@"ConfigFile"];
        

    }
}

@end
