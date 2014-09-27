//
//  MessageOperation.h
//  NaNa
//
//  Created by singlew on 14-8-7.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaOperation.h"
typedef enum{
    kSendMessage,
    kGetNewMessage,
    kGetSideMessageList,
    kGetHistoryMessage,
    kPostTouchHead,
    kPostGiveKey,
}MessageType;

@interface MessageOperation : NaNaOperation
-(MessageOperation *) initSendMessage : (NSString *) content withTarGetID : (int) targetID;
-(MessageOperation *) initGetNewMessageWithTargetID : (int) targetID;
-(MessageOperation *) initGetSideMessageList : (int) userID;

-(MessageOperation *) initGetHistoryMessageWithTargetID : (int) targetID withTimeStemp : (long long) timeStemp;

-(MessageOperation *) initTouchHead : (int) userID withTargetID : (int) targetID;
-(MessageOperation *) initGiveKey : (int) userID withTargetID : (int) targetID;
@end
