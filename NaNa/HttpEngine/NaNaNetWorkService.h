//
//  PalmNetWorkService.h
//  teacher
//
//  Created by singlew on 14-3-7.
//  Copyright (c) 2014年 ws. All rights reserved.
//

#define maxQueueCount 1
#import "NaNaHttpEngine.h"
#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "NaNaOperation.h"

@interface NaNaNetWorkService : NaNaHttpEngine
@property(nonatomic,strong) ASINetworkQueue *uiBusinessQueue;

+(NaNaNetWorkService *) sharedInstance;

// 封装网络请求的Operation
-(void) networkEngine : (NaNaOperation *)operation;
// 开始网络请求的Operation
-(void) startAsynchronous : (NSOperation *) request;
-(void) canelHttpRequestFrom : (id) clazz;
@end
