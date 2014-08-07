//
//  PalmUIManagement.m
//  teacher
//
//  Created by singlew on 14-3-7.
//  Copyright (c) 2014年 ws. All rights reserved.
//

#import "NaNaUIManagement.h"
#import "UploadOperation.h"
#import "UserProfileOperation.h"
#import "GiftOperation.h"

@implementation NaNaUIManagement
static NaNaUIManagement *sharedInstance = nil;

+(NaNaUIManagement *) sharedInstance{
    @synchronized(sharedInstance){
        if (nil == sharedInstance){
            sharedInstance = [[NaNaUIManagement alloc] init];
            sharedInstance.userAccount = [NaNaUIModelCoding deserializeModel:@"NaNaUserAccount"];
        }
    }
    return sharedInstance;
}


-(void) uploadFile : (NSData *) data withUploadType : (UploadType) uploadType withUserID : (int) userID withDesc : (NSString *) desc{
    UploadOperation * operation = [[UploadOperation alloc] initUpload:data withUploadType:uploadType withUserID:userID withDesc:desc];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

-(void) getUserProfile:(int)userID{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initGetUserProfile:userID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

-(void) getUserPrivacySetting{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initGetUserPrivacySetting:self.userAccount.UserID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

-(void) getUserPushSetting{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initGetUserPushSetting:self.userAccount.UserID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 获取可用于购买的礼物列表
-(void) initGetGiftStoreList{
    GiftOperation *operation = [[GiftOperation alloc] initGetGiftStoreList];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}
// 获取获赠礼物列表
-(void) initGetUserGiftList{
    GiftOperation *operation = [[GiftOperation alloc] initGetUserGiftList:self.userAccount.UserID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}
// 赠送礼物
-(void) initPresentGift : (int) giftID withTargetID : (int) targetUserID{
    GiftOperation *operation = [[GiftOperation alloc] initPresentGift:giftID withUserID:self.userAccount.UserID withTargetID:targetUserID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}
@end
