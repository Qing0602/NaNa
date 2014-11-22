//
//  SystemOperation.m
//  NaNa
//
//  Created by singlew on 14-8-9.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "SystemOperation.h"
#import "NaNaUIManagement.h"

@interface SystemOperation ()
@property(nonatomic) SysTemType type;
-(void) postSystemDriverToken;
-(void) postChangeCode;
@end

@implementation SystemOperation
-(SystemOperation *) initPostSystemDriverToken : (int) userID withDriverToken : (NSString *) token{
    self = [self initOperation];
    if (nil != self) {
        self.type = kPostDriverToken;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/index.php/device/token?token=%@&userId=%d",token,userID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(SystemOperation *) initChangeCode : (NSString *) code withPassword : (NSString *)password{
    self = [self initOperation];
    if (nil != self) {
        self.type = kPostChangeCode;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/user/rechargeCard"];
        [self setHttpRequestPostWithUrl:urlStr params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [NSNumber numberWithInt:[NaNaUIManagement sharedInstance].userAccount.UserID],@"userId",
                                                       code,@"cardId",
                                                       password,@"cardSec",
                                                       nil]];
    }
    return self;
}

-(void) postSystemDriverToken{
    [self.dataRequest setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].driverToken = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) postChangeCode{
    [self.dataRequest setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].changeCodeDic = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) main{
    @autoreleasepool {
        switch (self.type) {
            case kPostDriverToken:
                [self postSystemDriverToken];
                break;
            case kPostChangeCode:
                [self postChangeCode];
                break;
            default:
                break;
        }
    }
}
@end
