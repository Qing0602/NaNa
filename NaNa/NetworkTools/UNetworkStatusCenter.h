//
//  UNetworkStatusCenter.h
//  NaNa
//
//  Created by dengfang on 13-2-20.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

typedef enum {
    OperatorsUnKnow = 0,    // 未知运营商
    OperatorsChinaMobile,   // 中国移动
    OperatorsChinaUnicom,   // 中国联通
    OperatorsChinaTelecom   // 中国电信

}Operators;

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface UNetworkStatusCenter : NSObject {
    // Apple Reachbility
    Reachability        *_reachability;
    
    // 当前的网络状态
    NetworkStatus       _currentNetworkStatus;
    
    // 当前运营商
    Operators           _currentOperators;
}

@property (readonly, nonatomic) NetworkStatus currentNetworkStatus;
@property (readonly, nonatomic) Operators currentOperators;

//  获取默认的 UNetworkStatusCenter (网络状态中心)
+ (UNetworkStatusCenter*) defaultNetworkStatusCenter;

//  添加网络状态的通知
//  (设置的通知接口必须有一个回调的参数)
+ (void) addNetworkStatusCallback:(SEL)selector target:(id)target;

//  移除网络状态的通知
//  (设置的通知接口必须有一个回调的参数)
+ (void) removeNetworkStatusCallback:(id)target;

@end
