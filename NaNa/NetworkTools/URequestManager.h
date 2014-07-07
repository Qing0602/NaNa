//
//  URequestManager.h
//  NaNa
//
//  Created by dengfang on 13-2-21.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URequest.h"

@class ASIHTTPRequest;
@class ASINetworkQueue;

// 用于管理所有Http请求的类
@interface URequestManager : NSObject {
    // 用于普通文本的网络请求
    ASINetworkQueue         *_commonRequestQueue;
    
    // 用于在后台中的网络请求
    ASINetworkQueue         *_backgroundRequestQueue;
}

// 用于普通文本的网络请求
@property (nonatomic, readonly) ASINetworkQueue *commonRequestQueue;

// 用于在后台中的网络请求
@property (nonatomic, readonly) ASINetworkQueue *backgroundRequestQueue;

// 获取默认RequestManage
+ (URequestManager*) defaultRequestManager;

// 添加普通请求至普通网络请求队列
+ (BOOL)addCommonRequest:(ASIHTTPRequest*)request;

// 添加请求至后台网络请求队列
+ (BOOL)addBackgroundRequest:(ASIHTTPRequest*)request;

// 取消该网络请求
+ (void)cancelRequest:(ASIHTTPRequest *)request;

// 取消当前delegate的所有请求
+ (void)removeURequestWithDelegate:(id)delegate;

// 根据Delegate获取未完成的请求(如果Delegate为nil,则返回所有未完成的请求)
+ (NSArray*)unfinishedRequestWithDelegate:(id)delegate;

@end
