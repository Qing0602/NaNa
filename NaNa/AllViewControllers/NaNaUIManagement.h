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
// 获取当前用户的照片列表
@property(nonatomic,strong) NSDictionary *userPhotoesList;

// 修改用户资料结果
@property(nonatomic,strong) NSDictionary *updateUserProfile;
// 设置用户接收推送结果
@property(nonatomic,strong) NSDictionary *updateUserPrivacySetting;
// 设置隐私设置结果
@property(nonatomic,strong) NSDictionary *updateUserPushSetting;
// 上传结果
@property(nonatomic,strong) NSDictionary *uploadResult;

// 上传DriverToken结果
@property(nonatomic,strong) NSDictionary *driverToken;

// 获取侧边栏数据
@property(nonatomic,strong) NSDictionary *sideResult;

// 发送消息
@property(nonatomic,strong) NSDictionary *sendMessageResult;

// 历史消息
@property(nonatomic,strong) NSDictionary *historyMessage;

// 新消息
@property(nonatomic,strong) NSDictionary *messagesDic;

// 移除用户相册图片
@property(nonatomic,strong) NSDictionary *removeUserPhotoDic;

// 获取用户可购买背景
@property(nonatomic,strong) NSDictionary *userBackGroundDic;
// 用户购买背景结果
@property(nonatomic,strong) NSDictionary *buyBackGroundDic;

@property(nonatomic,strong) NSHTTPCookie *php;
@property(nonatomic,strong) NSHTTPCookie *suid;
@property(nonatomic,strong) NSString *imServerIP;

// 上传文件
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
-(void) updateUserPushSetting : (BOOL) canMessagePush withCanVisitPush : (BOOL) canVisitPush withCanLovePush : (BOOL) canLovePush
                withCanFriendPush : (BOOL) canFriendPush;
// 修改隐私设置 -- 此接口仅仅使用ShowUserInfo参数和ShowPhotoes参数
-(void) updateUserPrivacySetting : (BOOL) isShowPhotoes withIsShowUserInfo : (BOOL) isShowUserInfo withIsShowUserAvatar : (BOOL) isShowUserAvatar withIsShowVoice : (BOOL) isShowVoice;

// 获取可用于购买的礼物列表
-(void) getGiftStoreList;
// 获取获赠礼物列表
-(void) getUserGiftList;
// 赠送礼物
-(void) presentGift : (int) giftID withTargetID : (int) targetUserID;
// 获取用户照片
-(void) getuserPhotoesList : (int) userID;


// 发送消息
-(void) sendMessage : (NSString *) content withTarGetID : (int) targetID;
// 获取侧边栏消息通知
-(void) getSideMessage;
// 获取新消息
-(void) getNewMessageWithTargetID : (int) targetID;
// 获取历史消息
-(void) getHistoryMessageWithTargetID : (int) targetID withTimeStemp : (int) timeStemp;
// 移除用户相册照片
-(void) removeUserPhoto : (int) photoID;
// 获取用户可购买背景
-(void) getUserBackGround;
// 购买背景
-(void) buyBackGround : (int) backgroundID;
@end
