//
//  UserProfileOperation.m
//  NaNa
//
//  Created by singlew on 14-8-5.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "UserProfileOperation.h"
#import "NaNaUIManagement.h"

@interface UserProfileOperation ()
-(void) getUserProfile;
-(void) getUserPrivacySetting;
-(void) getUserPushSetting;
-(void) postUserProfile;
-(void) postUserPrivacySetting;
-(void) postUserPushSetting;
@end

@implementation UserProfileOperation
-(UserProfileOperation *) initGetUserProfile : (int) userID{
    if ((self = [self initOperation])) {
        self.type = kGetUserProfile;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/user/info?userId=%d",userID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(UserProfileOperation *) initGetUserPrivacySetting : (int) userID{
    if ((self = [self initOperation])) {
        self.type = kGetUserPrivacySetting;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/user/getPrivacySetting?userId=%d",userID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(UserProfileOperation *) initGetUserPushSetting : (int) userID{
    if ((self = [self initOperation])) {
        self.type = kGetUserPushSetting;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/user/getPushSetting?userId=%d",userID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(UserProfileOperation *) initUpdateUserProfile : (int) userID withNickName : (NSString *) nickName withRole : (NSString *) role withCityID : (int) cityID{
    self = [self initOperation];
    if (nil != self) {
        self.type = kPostUserProfile;
        NSString *urlStr  = @"http://api.local.ishenran.cn/user/updateInfo";
        [self setHttpRequestPostWithUrl:urlStr params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithInt:userID],@"userId",
                                                      nickName,@"nickname",
                                                      [NSNumber numberWithInt:cityID],@"city_id",
                                                      role,@"role",nil]];
    }
    return self;
}

-(UserProfileOperation *) initUpdateUserPushSetting : (int) userID withCanMessagePush : (BOOL) canMessagePush withCanVisitPush : (BOOL) canVisitPush
                                    withCanLovePush : (BOOL) canLovePush withCanFriendPush : (BOOL) canFriendPush{
    self = [self initOperation];
    if (nil != self) {
        self.type = kPostUserPushSetting;
        NSString *urlStr = @"http://api.local.ishenran.cn/user/pushSetting";
        [self setHttpRequestPostWithUrl:urlStr params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithInt:userID],@"userId",
                                                      [NSNumber numberWithBool:canMessagePush],@"messagePush",
                                                      [NSNumber numberWithBool:canVisitPush],@"visitPush",
                                                      [NSNumber numberWithBool:canLovePush],@"lovePush",
                                                      [NSNumber numberWithBool:canFriendPush],@"friendPush",
                                                       nil]];
        
    }
    return self;
}

-(UserProfileOperation *) initUpdateUserPrivacySetting : (int) userID withIsShowPhotoes : (BOOL) isShowPhotoes withIsShowUserInfo : (BOOL) isShowUserInfo
                                  withIsShowUserAvatar : (BOOL) isShowUserAvatar withIsShowVoice : (BOOL) isShowVoice{
    self = [self initOperation];
    if (nil != self) {
        self.type = kPostUserPrivacySetting;
        NSString *urlStr = @"http://api.local.ishenran.cn/user/privacySetting";
        [self setHttpRequestPostWithUrl:urlStr params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithInt:userID],@"userId",
                                                      [NSNumber numberWithBool:isShowPhotoes],@"showPhotos",
                                                      [NSNumber numberWithBool:isShowUserInfo],@"showInfo",
                                                      [NSNumber numberWithBool:isShowUserAvatar],@"showAvatar",
                                                      [NSNumber numberWithBool:isShowVoice],@"showVoice",
                                                       nil]];
    }
    return self;
}

-(void) getUserProfile{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].userProfile = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) getUserPrivacySetting{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].userPrivacySetting = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) getUserPushSetting{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].userPushSetting = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) postUserProfile{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].updateUserProfile = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) postUserPrivacySetting{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].updateUserPrivacySetting = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) postUserPushSetting{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].updateUserPushSetting = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) main{
    @autoreleasepool {
        switch (self.type) {
            case kGetUserProfile:
                [self getUserProfile];
                break;
            case kGetUserPrivacySetting:
                [self getUserPrivacySetting];
                break;
            case kGetUserPushSetting:
                [self getUserPushSetting];
                break;
            case kPostUserProfile:
                [self postUserProfile];
                break;
            case kPostUserPrivacySetting:
                [self postUserPrivacySetting];
                break;
            case kPostUserPushSetting:
                [self postUserPushSetting];
                break;
            default:
                break;
        }
    }
}
@end
