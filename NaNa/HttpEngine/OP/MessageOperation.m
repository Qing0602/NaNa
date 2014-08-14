//
//  MessageOperation.m
//  NaNa
//
//  Created by singlew on 14-8-7.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "MessageOperation.h"
#import "NaNaUIManagement.h"

@interface MessageOperation ()
@property(nonatomic) MessageType type;

-(void) getSideMessageList;
@end

@implementation MessageOperation
-(MessageOperation *) initSendMessage : (NSString *) content withUserID : (int) userID withTarGetID : (int) targetID{
    return self;
}

-(MessageOperation *) initGetNewMessage : (int) userID withTargetID : (int) targetID withPage : (int) page{
    return self;
}

-(MessageOperation *) initGetSideMessageList : (int) userID{
    self = [self initOperation];
    if (nil != self) {
        self.type = kGetSideMessageList;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/message/getList?userId=%d",[NaNaUIManagement sharedInstance].userAccount.UserID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(void) getSideMessageList{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].sideResult = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) main{
    @autoreleasepool {
        switch (self.type) {
            case kGetSideMessageList:
                [self getSideMessageList];
                break;
            default:
                break;
        }
    }
}
@end
