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


-(void) uploadFile : (NSData *) data withUploadType : (UploadType) uploadType withUserID : (NSString *) userID withDesc : (NSString *) desc{
    UploadOperation * operation = [[UploadOperation alloc] initUpload:data withUploadType:uploadType withUserID:userID withDesc:desc];
    [[NaNaNetWorkService sharedInstance] networkEngine:operation];
}

-(void) getUserProfile:(NSString *)userID{
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
@end
