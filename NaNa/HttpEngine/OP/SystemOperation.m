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

-(void) postSystemDriverToken{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].driverToken = data;
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
            default:
                break;
        }
    }
}
@end
