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
}MessageType;

@interface MessageOperation : NaNaOperation
-(MessageOperation *) initSendMessage : (NSString *) content withTarGetID : (int) targetID;
-(MessageOperation *) initGetNewMessage : (int) userID withTargetID : (int) targetID withPage : (int) page;
-(MessageOperation *) initGetSideMessageList : (int) userID;
@end
