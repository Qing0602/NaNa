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
@end

@implementation UserProfileOperation
-(UserProfileOperation *) initGetUserProfile : (NSString *) userID{
    if ((self = [self initOperation])) {
        self.type = kGetUserProfile;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/user/info?userId=%@",userID];
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
