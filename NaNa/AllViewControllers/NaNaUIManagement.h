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
//#import "UploadOperation.h"


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

@property(nonatomic,strong) NSDictionary *uploadResult;

@property(nonatomic,strong) NSHTTPCookie *php;
@property(nonatomic,strong) NSHTTPCookie *suid;
@property(nonatomic,strong) NSString *imServerIP;


-(void) uploadFile : (NSData *) data withUploadType : (UploadType) uploadType withUserID : (NSString *) userID withDesc : (NSString *) desc;
// 获取用户资料
-(void) getUserProfile:(NSString *) userID;
// 获取用户隐私设置
-(void) getUserPrivacySetting;
// 获取用户通知设置
-(void) getUserPushSetting;
@end
