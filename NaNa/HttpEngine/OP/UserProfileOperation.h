//
//  UserProfileOperation.h
//  NaNa
//
//  Created by singlew on 14-8-5.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaOperation.h"

typedef enum{
    kGetUserProfile,
    kGetUserPrivacySetting,
    kGetUserPushSetting,
    kPostUserProfile,
    kPostUserPrivacySetting,
    kPostUserPushSetting,
    kGetUserPhotoesList,
    kRemoveUserPhoto,
}UserProfileType;

@interface UserProfileOperation : NaNaOperation
@property (nonatomic) UserProfileType type;
-(UserProfileOperation *) initGetUserProfile : (int) userID;
-(UserProfileOperation *) initGetUserPrivacySetting : (int) userID;
-(UserProfileOperation *) initGetUserPushSetting : (int) userID;

-(UserProfileOperation *) initUpdateUserProfile : (int) userID withNickName : (NSString *) nickName withRole : (NSString *) role withCityID : (int) cityID;

-(UserProfileOperation *) initUpdateUserPushSetting : (int) userID withCanMessagePush : (BOOL) canMessagePush withCanVisitPush : (BOOL) canVisitPush
                                withCanLovePush : (BOOL) canLovePush withCanFriendPush : (BOOL) canFriendPush;

-(UserProfileOperation *) initUpdateUserPrivacySetting : (int) userID withIsShowPhotoes : (BOOL) isShowPhotoes withIsShowUserInfo : (BOOL) isShowUserInfo
                                withIsShowUserAvatar : (BOOL) isShowUserAvatar withIsShowVoice : (BOOL) isShowVoice;
-(UserProfileOperation *) initGetuserPhotoesList : (int) userID;

-(UserProfileOperation *) initRemoveUserPhoto :(int) userID withPhotoID : (int) photoID;
@end
