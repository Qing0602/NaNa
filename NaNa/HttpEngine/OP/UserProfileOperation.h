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
}UserProfileType;

@interface UserProfileOperation : NaNaOperation
@property (nonatomic) UserProfileType type;
-(UserProfileOperation *) initGetUserProfile : (NSString *) userID;
-(UserProfileOperation *) initGetUserPrivacySetting : (NSString *) userID;
-(UserProfileOperation *) initGetUserPushSetting : (NSString *) userID;
@end
