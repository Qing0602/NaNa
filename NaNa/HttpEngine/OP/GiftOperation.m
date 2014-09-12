//
//  GiftOperation.m
//  NaNa
//
//  Created by singlew on 14-8-7.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "GiftOperation.h"
#import "NaNaUIManagement.h"

@interface GiftOperation ()
@property (nonatomic) GiftType type;

-(void) getGiftStoreList;
-(void) getUserGiftList;
-(void) postPresentGift;
@end

@implementation GiftOperation
-(GiftOperation *) initGetGiftStoreList{
    self = [self initOperation];
    if (nil != self) {
        self.type = kGetGiftStoreList;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/gift/list4Sell"];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(GiftOperation *) initGetUserGiftList : (int) userID{
    self = [self initOperation];
    if (nil != self) {
        self.type = kGetUserGiftList;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/gift/getList?userId=%d",userID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(GiftOperation *) initPresentGift : (int) giftID withUserID : (int) userID withTargetID : (int) targetUserID{
    self = [self initOperation];
    if (nil != self) {
        self.type = kPostPresentGift;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/gift/send?userId=%d&targetId=%d&giftId=%d",userID,targetUserID,giftID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(void) getGiftStoreList{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].giftStoreDic = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) getUserGiftList{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].userGiftListDic = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) postPresentGift{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].presentGift = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) main{
    @autoreleasepool {
        switch (self.type) {
            case kGetGiftStoreList:
                [self getGiftStoreList];
                break;
            case kGetUserGiftList:
                [self getUserGiftList];
                break;
            case kPostPresentGift:
                [self postPresentGift];
                break;
            default:
                break;
        }
    }
}

@end
