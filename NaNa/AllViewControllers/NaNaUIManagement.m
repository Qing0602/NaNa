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
#import "MessageOperation.h"

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
-(void) getGiftStoreList{
    GiftOperation *operation = [[GiftOperation alloc] initGetGiftStoreList];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}
// 获取获赠礼物列表
-(void) getUserGiftList{
    GiftOperation *operation = [[GiftOperation alloc] initGetUserGiftList:self.userAccount.UserID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}
// 赠送礼物
-(void) presentGift : (int) giftID withTargetID : (int) targetUserID{
    GiftOperation *operation = [[GiftOperation alloc] initPresentGift:giftID withUserID:self.userAccount.UserID withTargetID:targetUserID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 修改用户资料
-(void) updateUserProfile : (NSString *) nickName withRole : (NSString *) role withCityID : (int) cityID{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initUpdateUserProfile:self.userAccount.UserID withNickName:nickName withRole:role withCityID:cityID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 修改用户接受推送
-(void) updateUserPushSetting : (BOOL) canMessagePush withCanVisitPush : (BOOL) canVisitPush withCanLovePush : (BOOL) canLovePush
                withCanFriendPush : (BOOL) canFriendPush{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initUpdateUserPushSetting:self.userAccount.UserID withCanMessagePush:canMessagePush withCanVisitPush:canVisitPush withCanLovePush:canLovePush withCanFriendPush:canFriendPush];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 修改隐私设置
-(void) updateUserPrivacySetting : (BOOL) isShowPhotoes withIsShowUserInfo : (BOOL) isShowUserInfo withIsShowUserAvatar : (BOOL) isShowUserAvatar withIsShowVoice : (BOOL) isShowVoice{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initUpdateUserPrivacySetting:self.userAccount.UserID withIsShowPhotoes:isShowPhotoes withIsShowUserInfo:isShowUserInfo withIsShowUserAvatar:isShowUserAvatar withIsShowVoice:isShowVoice];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 获取用户照片
-(void) getuserPhotoesList : (int) userID{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initGetuserPhotoesList:userID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 发送消息
-(void) sendMessage : (NSString *) content withTarGetID : (int) targetID{
    MessageOperation *operation = [[MessageOperation alloc] initSendMessage:content withTarGetID:targetID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 获取侧边栏消息通知
-(void) getSideMessage{
    MessageOperation *operation = [[MessageOperation alloc] initGetSideMessageList:[NaNaUIManagement sharedInstance].userAccount.UserID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}
@end
