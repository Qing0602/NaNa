//
//  ULogic.h
//  NaNa
//
//  Created by dengfang on 13-3-1.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URequest.h"
#import "URequestManager.h"

@class ULogic;
@protocol ULogicProtocal <NSObject>
// 默认装载Logic的方法，子类需要重载这个方法
- (ULogic*)setupLogic;
@end

// 用于控制界面中的数据以及业务逻辑，从而套用MVC模型
// 需要注意的是，子的逻辑类需要继承于此类
@interface ULogic : NSObject {
    
}

// 用于判断当页面显示的时候，是否需要重新加载数据
@property (nonatomic, assign)   BOOL    needRereshData;

// 用于回调用到的Delegate
@property (nonatomic, assign)   id      delegate;

// 取消掉当前Logic的所有请求
- (void)cancelAllRequest;

@end
