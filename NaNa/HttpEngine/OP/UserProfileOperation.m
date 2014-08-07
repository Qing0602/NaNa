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

-(void) main{
    @autoreleasepool {
        switch (self.type) {
            case kGetUserProfile:
                [self getUserProfile];
                break;
                
            default:
                break;
        }
    }
}
@end
