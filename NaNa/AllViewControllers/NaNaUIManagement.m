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
#import "SystemOperation.h"
#import "LoginOperation.h"

@implementation NaNaUIManagement
static NaNaUIManagement *sharedInstance = nil;

+(NaNaUIManagement *) sharedInstance{
    @synchronized(sharedInstance){
        if (nil == sharedInstance){
            sharedInstance = [[NaNaUIManagement alloc] init];
            sharedInstance.userAccount = [NaNaUIModelCoding deserializeModel:@"NaNaUserAccount"];
            sharedInstance.userProfileCache = [NaNaUIModelCoding deserializeModel:@"userProfileCache"];
        }
    }
    return sharedInstance;
}

+(BOOL)createPath:(NSString *)path{
    BOOL isSucess = NO;
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@",path];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:filePath];
    
    BOOL success = [fm createDirectoryAtPath:writableDBPath withIntermediateDirectories:YES attributes:nil error:&error];
    if(!success){
    }
    return isSucess;
}

-(void) uploadFile : (NSData *) data withUploadType : (UploadType) uploadType withUserID : (int) userID withDesc : (NSString *) desc withVoiceTime : (NSUInteger) time{
    UploadOperation * operation = [[UploadOperation alloc] initUpload:data withUploadType:uploadType withUserID:userID withDesc:desc withVoiceTime:time];
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
-(void) updateUserProfile : (NSString *) nickName withRole : (NSString *) role withCityID : (int) cityID withBirthday : (NSString *) birthday{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initUpdateUserProfile:self.userAccount.UserID withNickName:nickName withRole:role withCityID:cityID withBirthday:birthday];
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

// 获取新消息
-(void) getNewMessageWithTargetID : (int) targetID{
    MessageOperation *operation = [[MessageOperation alloc] initGetNewMessageWithTargetID:targetID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 获取历史消息
-(void) getHistoryMessageWithTargetID : (int) targetID withTimeStemp : (long long) timeStemp{
    MessageOperation *operation = [[MessageOperation alloc] initGetHistoryMessageWithTargetID:targetID withTimeStemp:timeStemp];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 移除用户相册照片
-(void) removeUserPhoto : (int) photoID{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initRemoveUserPhoto:self.userAccount.UserID withPhotoID:photoID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 获取用户可购买背景
-(void) getUserBackGround{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initGetUserBackGround:[NaNaUIManagement sharedInstance].userAccount.UserID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 购买背景
-(void) buyBackGround : (int) backgroundID{
    UserProfileOperation *operation = [[UserProfileOperation alloc] initBuyBackGround:[NaNaUIManagement sharedInstance].userAccount.UserID withBackGroundID:backgroundID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

//发送push token
-(void) postPushToken : (NSString *) pushToken{
    SystemOperation *operation = [[SystemOperation alloc] initPostSystemDriverToken:[NaNaUIManagement sharedInstance].userAccount.UserID withDriverToken:pushToken];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 摸头
-(void) touchHead : (int) targetID{
    MessageOperation *operation = [[MessageOperation alloc] initTouchHead:[NaNaUIManagement sharedInstance].userAccount.UserID withTargetID:targetID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 钥匙
-(void) giveKey : (int) targetID{
    MessageOperation *operation = [[MessageOperation alloc] initGiveKey:[NaNaUIManagement sharedInstance].userAccount.UserID withTargetID:targetID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

-(void) downLoadUserVoiceFile : (NSString *) videoUrl withFilePath : (NSString *) filePath{
    UploadOperation *operation = [[UploadOperation alloc] initDownLoadUserVoiceFile:videoUrl withFilePath:filePath];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 退出登录
-(void) quit{
    [NaNaUIModelCoding clearCache:@"NaNaUserAccount"];
}

-(void) changeCode : (NSString *) code withPassword : (NSString *)password{
    SystemOperation *operation = [[SystemOperation alloc] initChangeCode:code withPassword:password];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

// 登陆
-(void) login : (NSString *) userName withPassword : (NSString *) password{
    LoginOperation *operation = [[LoginOperation alloc] initLogin:userName withPassword:password];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}
// 注册
-(void) postUserName : (NSString *) userName withPassword : (NSString *) password{
    LoginOperation *operation = [[LoginOperation alloc] initPostUserName:userName withPassword:password];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

-(void) sinaLogin : (NSString *) userID{
    LoginOperation *operation = [[LoginOperation alloc] initSinaLogin:userID];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}
@end
