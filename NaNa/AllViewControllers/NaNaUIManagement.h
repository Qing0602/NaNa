//
//  PalmUIManagement.h
//  teacher
//
//  Created by singlew on 14-3-7.
//  Copyright (c) 2014年 ws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NaNaNetWorkService.h"
#import "NaNaUserAccountModel.h"

#define TRANSFERVALUE @"TransferValue"
#define TRANSFERVCFROMCLASS @"TransferFromVCClass"
#define TRANSFERVCTOCLASS @"TransferToVCClass"

typedef enum{
    UploadAvatar,
    UploadPhoto,
    UploadVoice,
}UploadType;

@interface NaNaUIManagement : NSObject

+(NaNaUIManagement *) sharedInstance;

// 用户登陆model
@property(nonatomic,strong) NaNaUserAccountModel *userAccount;

// 新好友数量
@property(nonatomic,strong) NSNumber *friendsOfNew;
// 新关注者数量
@property(nonatomic,strong) NSNumber *lovedOfNew;
// 未读消息数量
@property(nonatomic,strong) NSNumber *messageOfNew;
// 未查看来访数量
@property(nonatomic,strong) NSNumber *visitorOfNew;
// 积分数量
@property(nonatomic,strong) NSNumber *point;
// 魅力值
@property(nonatomic,strong) NSNumber *charm;

// 用户资料
@property(nonatomic,strong) NSDictionary *userProfile;
// 获取用户隐私设置
@property(nonatomic,strong) NSDictionary *userPrivacySetting;
// 获取用户通知设置
@property(nonatomic,strong) NSDictionary *userPushSetting;

// 可用于购买的礼物列表
@property(nonatomic,strong) NSDictionary *giftStoreDic;
// 获赠礼物列表
@property(nonatomic,strong) NSDictionary *userGiftListDic;
// 赠送礼物
@property(nonatomic,strong) NSDictionary *presentGift;


// 修改用户资料结果
@property(nonatomic,strong) NSDictionary *updateUserProfile;
// 设置用户接收推送结果
@property(nonatomic,strong) NSDictionary *updateUserPrivacySetting;
// 设置隐私设置结果
@property(nonatomic,strong) NSDictionary *updateUserPushSetting;

@property(nonatomic,strong) NSDictionary *uploadResult;

// 上传DriverToken结果
@property(nonatomic,strong) NSDictionary *driverToken;

@property(nonatomic,strong) NSHTTPCookie *php;
@property(nonatomic,strong) NSHTTPCookie *suid;
@property(nonatomic,strong) NSString *imServerIP;


-(void) uploadFile : (NSData *) data withUploadType : (UploadType) uploadType withUserID : (int) userID withDesc : (NSString *) desc;
// 获取用户资料
-(void) getUserProfile:(int) userID;
// 获取用户隐私设置
-(void) getUserPrivacySetting;
// 获取用户通知设置
-(void) getUserPushSetting;

// 修改用户资料
-(void) updateUserProfile : (NSString *) nickName withRole : (NSString *) role withCityID : (int) cityID;

// 修改用户接受推送
-(void) initUpdateUserPushSetting : (BOOL) canMessagePush withCanVisitPush : (BOOL) canVisitPush withCanLovePush : (BOOL) canLovePush
                withCanFriendPush : (BOOL) canFriendPush;
// 修改隐私设置
-(void) updateUserPrivacySetting : (BOOL) isShowPhotoes withIsShowUserInfo : (BOOL) isShowUserInfo withIsShowUserAvatar : (BOOL) isShowUserAvatar withIsShowVoice : (BOOL) isShowVoice;

// 获取可用于购买的礼物列表
-(void) initGetGiftStoreList;
// 获取获赠礼物列表
-(void) initGetUserGiftList;
// 赠送礼物
-(void) initPresentGift : (int) giftID withTargetID : (int) targetUserID;
@end
