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

-(void) sendMessage;
-(void) getSideMessageList;
-(void) getNewMessage;
-(void) getHistoryMessage;
-(void) postTouchHead;
-(void) postGiveKey;
@end

@implementation MessageOperation
-(MessageOperation *) initSendMessage : (NSString *) content withTarGetID : (int) targetID{
    self = [self initOperation];
    if (nil != self) {
        self.type = kSendMessage;
        NSString *urlStr = [NSString stringWithFormat:@"%@/message/send",K_DOMAIN_NANA];
        [self setHttpRequestPostWithUrl:urlStr params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [NSNumber numberWithInt:[NaNaUIManagement sharedInstance].userAccount.UserID],@"userId",
                                                       [NSNumber numberWithInt:targetID],@"targetId",
                                                       content,@"content",nil]];
    }
    return self;
}

-(MessageOperation *) initGetNewMessageWithTargetID : (int) targetID{
    self = [self initOperation];
    if (nil != self) {
        self.type = kGetNewMessage;
        NSString *urlStr = [NSString stringWithFormat:@"%@/message/getNew?userId=%d&targetId=%d",K_DOMAIN_NANA,[NaNaUIManagement sharedInstance].userAccount.UserID,targetID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(MessageOperation *) initGetSideMessageList : (int) userID{
    self = [self initOperation];
    if (nil != self) {
        self.type = kGetSideMessageList;
        NSString *urlStr = [NSString stringWithFormat:@"%@/message/getList?userId=%d",K_DOMAIN_NANA,[NaNaUIManagement sharedInstance].userAccount.UserID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(MessageOperation *) initGetHistoryMessageWithTargetID : (int) targetID withTimeStemp : (long long) timeStemp;{
    self = [self initOperation];
    if (nil != self) {
        self.type = kGetHistoryMessage;
        NSString *urlStr = [NSString stringWithFormat:@"%@/message/get?userId=%d&targetId=%d&time=%lld",K_DOMAIN_NANA,[NaNaUIManagement sharedInstance].userAccount.UserID,targetID,timeStemp];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(MessageOperation *) initTouchHead : (int) userID withTargetID : (int) targetID{
    self = [self initOperation];
    if (nil != self) {
        self.type = kPostTouchHead;
        NSString *urlStr = [NSString stringWithFormat:@"%@/interactive/touchhead?userId=%d&targetId=%d",K_DOMAIN_NANA,userID,targetID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(MessageOperation *) initGiveKey : (int) userID withTargetID : (int) targetID{
    self = [self initOperation];
    if (nil != self) {
        self.type = kPostGiveKey;
        NSString *urlStr = [NSString stringWithFormat:@"%@/interactive/sendkey?userId=%d&targetId=%d",K_DOMAIN_NANA,userID,targetID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(void) sendMessage{
    [self.dataRequest setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].sendMessageResult = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
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

-(void) getNewMessage{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].messagesDic = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) getHistoryMessage{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].historyMessage = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) postTouchHead{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].touchHeadDic = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) postGiveKey{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].giveKey = data;
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
            case kSendMessage:
                [self sendMessage];
                break;
            case kGetHistoryMessage:
                [self getHistoryMessage];
                break;
            case kGetNewMessage:
                [self getNewMessage];
                break;
            case kPostTouchHead:
                [self postTouchHead];
                break;
            case kPostGiveKey:
                [self postGiveKey];
                break;
            default:
                break;
        }
    }
}
@end
