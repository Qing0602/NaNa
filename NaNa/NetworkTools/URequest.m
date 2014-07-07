//
//  URequest.m
//  NaNa
//
//  Created by dengfang on 13-2-21.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "URequest.h"
#import "MD5.h"
#import "JSONKit.h"
#import "UStaticData.h"
#import "UStaticData.h"
#import "AppDelegate.h"
#import "UAlertView.h"

@implementation URequest

@synthesize comments, parsedDict, serverCode, isError, allowedAlert;

// 初始化方法
- (id)initWithDomain:(NSString *)url_domain withPath:(NSString*)path withParam:(NSString*)param {
    NSString *allPath = [NSString stringWithFormat:@"%@%@%@", [url_domain length]? url_domain : K_DOMAIN_NANA,
                         path ? path : @"" , URL_TAIL_PARAM];
//    ULog(@"URL = %@",allPath);
    self = [self initWithURL:[NSURL URLWithString:allPath]];
    if (self) {
        self.allowedAlert = YES;
        self.allowedToast = YES;
        [self setRequestMethod:@"POST"];
        
        NSString *validParam = [param validStringForRequest];
        if (validParam) {
            NSDictionary *paramDict = [validParam signDict];
            for ( NSString *key in [paramDict allKeys]) {
                [self setPostValue:[paramDict valueForKey:key] forKey:key];
            }
            ULog(@"发送的地址 %@ \n发送的参数 %@", self.url, paramDict);
        }
    }
    return self;
}


- (void)dealloc {
    self.comments = nil;
    self.parsedDict = nil;
    [super dealloc];
}

//
- (void)customLogic {
    ULog(@"Http %@", [NSThread currentThread].description);
    
    
    // 所有解析或者其他共有的东西应该在这里调用
    self.parsedDict = [self.responseData objectFromJSONData];
    
//    ULog(@"Http 地址 %@\n  Http内容  %@ ", self.url ,self.responseString)
    NSString *balance = [[self.parsedDict objectForKey:@"header"] objectForKey:@"balance"];
    if ([balance isKindOfClass:[NSString class]] && [balance length]) {
        BOOL shouldRefresh = NO;
        if (![[UStaticData defaultStaticData].userInfo.balance isEqualToString:balance]) {
            shouldRefresh = YES;
        }
        [UStaticData defaultStaticData].userInfo.balance = balance;
//        if (shouldRefresh) {
//            UINavigationController *navi = [[APP_DELEGATE.rootViewController viewControllers] objectAtIndex:0];
//            if([[navi viewControllers] count] == 1 && APP_DELEGATE.rootViewController.selectedIndex == 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REFRESH_BALANCE object:nil];
//            }
//        }
    }
    
    // 在这里可以解析各种错误等内容，（风险：有可能是在另外一个线程）
    self.serverCode = [[[self.parsedDict objectForKey:@"header"] objectForKey:@"code"] intValue];

    // 强制升级
    if (self.serverCode == EServerErrorEnforceUpdate) {
//        [UStaticData defaultStaticData].isShowSignErrorAlert = NO;
//        if (![[UStaticData defaultStaticData] updateUrl]) {
//            [[UStaticData defaultStaticData] setUpdateUrl:[[self.parsedDict objectForKey:@"header"] objectForKey:@"packageUrl"]];
//            [[UStaticData defaultStaticData] setUpdateMessage:[[self.parsedDict objectForKey:@"header"] objectForKey:@"message"]];
//            
//            UAlertView *alert = [UAlertView showAlertViewWithTitle:STRING(@"upgrade_remind")
//                                                           message:[[self.parsedDict objectForKey:@"header"] objectForKey:@"message"]
//                                                          delegate:APP_DELEGATE
//                                                      cancelButton:STRING(@"straightway_update")
//                                                     defaultButton:nil];
//            alert.messageLabel.textAlignment = NSTextAlignmentLeft;
//            alert.tag = EServerErrorEnforceUpdate;
    
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:STRING(@"upgrade_remind")
//                                                            message:[[self.parsedDict objectForKey:@"header"] objectForKey:@"message"]
//                                                           delegate:APP_DELEGATE
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:STRING(@"straightway_update"), nil];
//            alert.tag = EServerErrorEnforceUpdate;
//            [alert show];
//            [alert release];
//        }
//        else {
//            return;
//        }
    
    }
    // 签名错误
    else if (self.serverCode == EServerErrorSignError) {
//        if (![[UStaticData defaultStaticData] isShowSignErrorAlert]) {
//            [UStaticData defaultStaticData].isShowSignErrorAlert = YES;
//            
//            
//            UAlertView *alert = [UAlertView showAlertViewWithTitle:STRING(@"prompt")
//                                                           message:[[self.parsedDict objectForKey:@"header"] objectForKey:@"message"]
//                                                          delegate:APP_DELEGATE
//                                                      cancelButton:STRING(@"ok")
//                                                     defaultButton:nil];
//            alert.tag = EServerErrorSignError;
//        }
//        else {
//            return;
//        }
    }
    // 正常情况
    else if (self.serverCode >= 20000 && self.serverCode < 30000) {
//            [UStaticData defaultStaticData].isShowSignErrorAlert = NO;
//            if (self.serverCode == EServerErrorSuggestUpdate) {
//                UBasicNavigationController *vc = (UBasicNavigationController *)APP_DELEGATE.rootViewController.selectedViewController;
//                if (![UStaticData defaultStaticData].isShowSuggestUpdateAlert) {
//                    UAlertView *alert = [UAlertView showAlertViewWithTitle:STRING(@"upgrade_remind")
//                                               message:[UStaticData getObjectForKey:UPDATE_MESSAGE]
//                                              delegate:APP_DELEGATE
//                                          cancelButton:STRING(@"cancel") defaultButton:STRING(@"straightway_update")];
//                    alert.tag = EServerErrorSuggestUpdate;
//                    alert.messageLabel.textAlignment = NSTextAlignmentLeft;
//
//                    [UStaticData defaultStaticData].isShowSuggestUpdateAlert = YES;
//                }
//                [[UStaticData defaultStaticData] setUpdateUrl:[[self.parsedDict objectForKey:@"header"] objectForKey:@"packageUrl"]];
//                [[UStaticData defaultStaticData] setUpdateMessage:[[self.parsedDict objectForKey:@"header"] objectForKey:@"message"]];
//                [[UStaticData defaultStaticData] setSeverVersion:[[self.parsedDict objectForKey:@"header"] objectForKey:@"lastVersion"]];
//            
//            }
//            else {
//                [[UStaticData defaultStaticData] setUpdateUrl:nil];
//                [[UStaticData defaultStaticData] setUpdateMessage:nil];
//                [[UStaticData defaultStaticData] setSeverVersion:nil];
//            }
    }

    // 错误情况
    else if (self.allowedAlert) {
//        [UStaticData defaultStaticData].isShowSignErrorAlert = NO;
        [UAlertView showAlertViewWithMessage:self.serverErrMsg delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
    }
}
                              
// 服务器给返回的ErrorMsg
- (NSString*)serverErrMsg {
    return [[self.parsedDict objectForKey:@"header"] objectForKey:@"message"];
}

// Http CallBack 以后的逻辑
- (void)customLogicAfterCallBack {
    
    // 当前的Http回调以后处理当前Config获取的问题
//    if (self.parsedDict && [[self.parsedDict objectForKey:@"header"] objectForKey:@"ConfigFile"]
//        &&![[[self.parsedDict objectForKey:@"header"] objectForKey:@"ConfigFile"]
//                             isEqualToString:[UStaticData defaultStaticData].configMD5]) {
//        [[UStaticData defaultStaticData] getConfigFile];
//    }
}

- (BOOL)isError {
    // 正常情况
    if (self.serverCode >= 20000 && self.serverCode < 30000) {
        return NO;
    }
    else {
        return YES;
    }
}

@end


// =========================================== 分割线 =====================================================

// 用于给Param签名的NSString+Category
@implementation NSString (URequest)

// 参数合法化
- (NSString*)validStringForRequest {
    NSString *str = self;
    if ([str length]) {
        NSString *enCodeParam = nil;
        
        NSMutableString *tmpParam = [[[NSMutableString alloc] init] autorelease];
        [tmpParam setString:str];
        for (int i = 0; i < tmpParam.length; i++) {
            if ([tmpParam rangeOfString:@" "].location != NSNotFound) {
                [tmpParam replaceCharactersInRange:[tmpParam rangeOfString:@" "] withString:@"+"];
            }
        }
        
        if ([tmpParam rangeOfString:@":"].location != NSNotFound) { //字符串中包含:符号
            enCodeParam = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                              (CFStringRef)tmpParam,
                                                                              NULL,
                                                                              (CFStringRef)@":@",
                                                                              kCFStringEncodingUTF8);
            [enCodeParam autorelease];
            
        } else if ([tmpParam rangeOfString:@"@"].location != NSNotFound) { //字符串中包含@符号
            enCodeParam = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                              (CFStringRef)tmpParam,
                                                                              NULL,
                                                                              (CFStringRef)@"@@",
                                                                              kCFStringEncodingUTF8);
            [enCodeParam autorelease];
        } else if ([tmpParam rangeOfString:@","].location != NSNotFound) { //字符串中包含@符号
            enCodeParam = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                              (CFStringRef)tmpParam,
                                                                              NULL,
                                                                              (CFStringRef)@",@",
                                                                              kCFStringEncodingUTF8);
            [enCodeParam autorelease];
        }
        else {
            enCodeParam = [tmpParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        return enCodeParam;
    }
    else {
        return @"";
    }
}


// 用于给Param签名的函数(返回签名后的NSString)
-(NSString*)signString {
    
    // 时间戳
    NSString *timeStamp = [UStaticData timeStamp];
    // 密码
    NSString *passWd = [UStaticData getObjectForKey:USER_PASSWD];
    // 应用秘钥
    NSString *appSecret = [[NSString stringWithFormat:@"%@%@", passWd, timeStamp] md5];
    // 需要排序的String
    NSString *sortString = [NSString stringWithFormat:@"appsecret=%@&%@&timestamp=%@",
                            appSecret,
                            self,
                            timeStamp];
	NSArray *sortArray = [[sortString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]]
                          sortedArrayUsingSelector:@selector(compare:)];
    // 排序结果String
	NSMutableString *tempStr = [NSMutableString stringWithCapacity:10];
    for (NSString *str in sortArray) {
        if ([tempStr length] > 0) {
            [tempStr appendFormat:@"&%@", str];
        }
        else {
            [tempStr appendString:str];
        }
    }
    
//    ULog(@"排序后的字符串 %@", tempStr);
    
    // 签名后的字符串
    NSString *signString = [[tempStr md5] uppercaseString];
	NSString *postStr = [NSString stringWithFormat:@"sign=%@&%@&timestamp=%@", signString, self, timeStamp];
    return postStr;
}

// 用于给Param签名的函数(返回签名后的NSDictionary)
-(NSDictionary*)signDict {
    NSString *needPostData = [self signString];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *string in [needPostData componentsSeparatedByString:@"&"]) {
        //得到=的索引
        if ([string rangeOfString:@"="].location != NSNotFound) {
            int index = [[NSNumber numberWithInteger:([string rangeOfString:@"="]).location] intValue];
            NSString *key = [string substringToIndex:index];            // =前, key值
            NSString *value = [string substringFromIndex:(index + 1)];  // =后, value
            [dict setValue:value forKey:key];
        }
    }
    return dict;
}

@end
