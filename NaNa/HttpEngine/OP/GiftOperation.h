//
//  GiftOperation.h
//  NaNa
//
//  Created by singlew on 14-8-7.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaOperation.h"

typedef enum{
    kGetGiftStoreList,
    kGetUserGiftList,
    kPostPresentGift,
}GiftType;

@interface GiftOperation : NaNaOperation
-(GiftOperation *) initGetGiftStoreList;
-(GiftOperation *) initGetUserGiftList : (int) userID;
-(GiftOperation *) initPresentGift : (int) giftID withUserID : (int) userID withTargetID : (int) targetUserID;
@end
