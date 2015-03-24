//
//  LoginOperation.m
//  NaNa
//
//  Created by singlew on 15/1/30.
//  Copyright (c) 2015年 dengfang. All rights reserved.
//

#import "LoginOperation.h"
#import "NaNaUIManagement.h"

@interface LoginOperation ()
@property(nonatomic) LoginType type;
-(void) login;
-(void) postUserNameAndPassword;
-(void) sinaLogin;
@end

@implementation LoginOperation
-(LoginOperation *) initLogin : (NSString *) userName withPassword : (NSString *) password{
    self = [self initOperation];
    if (nil != self) {
        self.type = NaNaLogin;
        NSString *urlStr = [NSString stringWithFormat:@"%@/login/local?username=%@&password=%@",K_DOMAIN_NANA,userName,password];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(LoginOperation *) initPostUserName : (NSString *) userName withPassword : (NSString *) password{
    self = [self initOperation];
    if (nil != self) {
        self.type = PostUserNameAndPassword;
        NSString *urlStr = [NSString stringWithFormat:@"%@/user/register?username=%@&password=%@",K_DOMAIN_NANA,userName,password];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(LoginOperation *) initSinaLogin : (NSString *) userID{
    self = [self initOperation];
    if (nil != self) {
        self.type = sinaLogin;
        NSString *urlStr = [NSString stringWithFormat:@"%@/login/weibo_login?uid=%@",K_DOMAIN_NANA,userID];
        [self setHttpRequestGetWithUrl:urlStr];
    }
    return self;
}

-(void) login{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].loginResult = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) postUserNameAndPassword{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].regResult = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) sinaLogin{
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].sinaLoginResult = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}


-(void) main{
    @autoreleasepool {
        switch (self.type) {
            case NaNaLogin:
                [self login];
                break;
            case PostUserNameAndPassword:
                [self postUserNameAndPassword];
                break;
            case sinaLogin:
                [self sinaLogin];
                break;
            default:
                break;
        }
    }
}
@end
