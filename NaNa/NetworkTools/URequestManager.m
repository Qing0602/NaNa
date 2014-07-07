//
//  URequestManager.m
//  NaNa
//
//  Created by dengfang on 13-2-21.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "URequestManager.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "UWindowHud.h"

static URequestManager *defaultRequestManager = nil;

@implementation URequestManager
@synthesize commonRequestQueue = _commonRequestQueue;
@synthesize backgroundRequestQueue = _backgroundRequestQueue;

#pragma mark - Implementation

- (void)dealloc {
    [_commonRequestQueue reset];
    SAFERELEASE(_commonRequestQueue)
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
//        [URequest setShouldUpdateNetworkActivityIndicator:NO];
        _commonRequestQueue = [[ASINetworkQueue alloc] init];
        // 设置普通请求回调的方法
        _commonRequestQueue.delegate = self;
        [_commonRequestQueue setRequestDidStartSelector:@selector(commonRequestDidStart:)];
        [_commonRequestQueue setRequestDidFinishSelector:@selector(commonRequestDidFinish:)];
        [_commonRequestQueue setRequestDidFailSelector:@selector(commonRequestDidFail:)];
        [_commonRequestQueue go];
        
        // 后台的网络请求运行
        _backgroundRequestQueue = [[ASINetworkQueue alloc] init];
        [_backgroundRequestQueue go];
    }
    return self;
}

// 获取默认RequestManage
+ (URequestManager*) defaultRequestManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultRequestManager = [[URequestManager alloc] init];
    });
    return defaultRequestManager;
}

// 添加普通请求至普通网络请求队列
+ (BOOL)addCommonRequest:(ASIHTTPRequest*)request {
    if (!defaultRequestManager) {
        [URequestManager defaultRequestManager];
    }
    [defaultRequestManager.commonRequestQueue addOperation:request];
    if ([[defaultRequestManager.commonRequestQueue operations] indexOfObject:request] != NSNotFound) {
        return YES;
    }
    return NO;
}

// 添加请求至后台网络请求队列
+ (BOOL)addBackgroundRequest:(ASIHTTPRequest*)request {
    if (!defaultRequestManager) {
        [URequestManager defaultRequestManager];
    }
    [defaultRequestManager.backgroundRequestQueue addOperation:request];
    if ([[defaultRequestManager.backgroundRequestQueue operations] indexOfObject:request] != NSNotFound) {
        return YES;
    }
    return NO;
}

// 取消请求
+ (void)cancelRequest:(ASIHTTPRequest *)request {
    if (request) {
        [UWindowHud hideAnimated:YES withRequest:(URequest*)request];
        if ([request.delegate respondsToSelector:@selector(requestCanceled:)]) {
            [request.delegate performSelectorOnMainThread:@selector(requestCanceled:) withObject:request waitUntilDone:YES];
        }
        [request clearDelegatesAndCancel];
    }
}

// 移除当前的delegate
+ (void)removeURequestWithDelegate:(id)delegate {
    for (URequest *tempRequest in [defaultRequestManager.commonRequestQueue operations]) {
        if (tempRequest.delegate == delegate) {
            if ([tempRequest.delegate respondsToSelector:@selector(requestCanceled:)]) {
                [tempRequest.delegate performSelectorOnMainThread:@selector(requestCanceled:) withObject:tempRequest waitUntilDone:YES];
            }
            [URequestManager cancelRequest:tempRequest];
        }
    }
}

// 根据Delegate获取未完成的请求(如果Delegate为nil,则返回所有未完成的请求)
+ (NSArray*)unfinishedRequestWithDelegate:(id)delegate {
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    for (ASIHTTPRequest *tempRequest in [defaultRequestManager.commonRequestQueue operations]) {
        if (delegate == nil) {
            [array addObject:tempRequest];
        }
        else if (tempRequest.delegate == delegate) {
            [array addObject:tempRequest];
        }
    }
    
    for (ASIHTTPRequest *tempRequest in [defaultRequestManager.backgroundRequestQueue operations]) {
        if (delegate == nil) {
            [array addObject:tempRequest];
        }
        else if (tempRequest.delegate == delegate) {
            [array addObject:tempRequest];
        }
    }
    
    return array;
}

#pragma mark - Common Request CallBack
// 网络请求开始
- (void)commonRequestDidStart:(ASIHTTPRequest*)request {
    if ([(URequest*)request needLoading]) {
        [UWindowHud hudWithType:kHttpLodingType withRequest:(URequest*)request];
    }
}

// 网络请求完成
- (void)commonRequestDidFinish:(ASIHTTPRequest*)request {
    if ([(URequest*)request needLoading]) {
        [UWindowHud hideAnimated:YES withRequest:(URequest*)request];
    }
}

// 网络请求失败
- (void)commonRequestDidFail:(ASIHTTPRequest*)request {
    if ([(URequest*)request needLoading]) {
        [UWindowHud hideAnimated:YES withRequest:(URequest*)request];
    }
    else if ([(URequest*)request allowedToast]) {
        [UWindowHud hudWithType:kToastType withContentString:STRING(@"request_fail_message")];
    }
}

#pragma mark - Image Request CallBack

@end
