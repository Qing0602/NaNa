
//
//  PalmHttpEngine.m
//  teacher
//
//  Created by singlew on 14-3-7.
//  Copyright (c) 2014年 ws. All rights reserved.
//

#import "NaNaHttpEngine.h"
#import <objc/message.h>
#import "Reachability.h"
#import "NaNaUIManagement.h"

@interface NaNaHttpEngine ()
//转换数据
-(id) getJSONObject:(NSString *)jsonString;
-(void) sendMsgToAutoCloseProgress : (id) clazz;
@end

@implementation NaNaHttpEngine

-(id) init{
    self = [super init];
    if (nil != self) {
        self.hasError = NO;
        self.errorMessage = @"";
    }
    return self;
}

-(BOOL) addSTOperation:(NaNaHTTPRequest *)op{
    return [self canConnected:op];
}

-(BOOL) canConntected{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach isReachable]) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL) canConnected : (NaNaHTTPRequest *) request{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach isReachable]) {
        return YES;
    }else{
        self.hasError = YES;
        self.errorMessage = NSLocalizedString(@"NetWorkError", @"");
        //调用委托
        if (nil != request.clazz && nil != request.clazzAction && [request.clazz respondsToSelector:request.clazzAction]) {
            NSDictionary *result = [self configRequestResult:YES withErrorMsg:self.errorMessage withData:nil withContext:request.context];
            [self sendMsgToAutoShowErrorMessage:request.clazz withMsg:[result objectForKey:ASI_REQUEST_ERROR_MESSAGE]];
            [self callback:request.clazz withAction:request.clazzAction withResult:result];
        }
        return NO;
    }
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(NaNaHTTPRequest *)request{
    
    self.hasError = NO;
    self.errorMessage = @"";
    
    
    // 当以文本形式读取返回内容时用这个方法
    NSString *responseString = [request responseString];
    NSDictionary *dic = [self getJSONObject:responseString];
    
    // 获取网络访问Header信息并判断
    NSDictionary *headers = dic[@"header"];
    
    int status = [headers[@"status"] intValue];
    
    if (status == 1) {
        /*
         "charm": 60,        //int       魅力值
         "newfriend": 0,     //int       新好友数量
         "newloved": 0,      //int       新关注者数量
         "newmessage": 0,    //int       未读消息数量
         "newvisitor": 6,    //int       未查看来访数量
         "point": 997499,    //int       积分数量
         */
        int charm = -1;
        if (headers[@"charm"] != nil) {
            charm = [headers[@"charm"] intValue];
        }
        int friendOfNew = -1;
        if (headers[@"newfriend"] != nil) {
            friendOfNew = [headers[@"newfriend"] intValue];
        }
        int lovedOfNew = -1;
        if (headers[@"newloved"] != nil) {
            lovedOfNew = [headers[@"newloved"] intValue];
        }
        int messageOfNew = -1;
        if (headers[@"newmessage"] != nil) {
            messageOfNew = [headers[@"newmessage"] intValue];
        }
        
        int visitorOfNew = -1;
        if (headers[@"newvisitor"] != nil) {
            visitorOfNew = [headers[@"newvisitor"] intValue];
        }
        
        int point = -1;
        if (headers[@"point"] != nil) {
            point = [headers[@"point"] intValue];
        }
        
        dispatch_block_t updateTagBlock = ^{
            if(charm != -1 && [[NaNaUIManagement sharedInstance].charm intValue] != charm){
                [NaNaUIManagement sharedInstance].charm = [NSNumber numberWithInt:charm];
            }
            if(friendOfNew != -1 && [[NaNaUIManagement sharedInstance].friendsOfNew intValue] != friendOfNew){
                [NaNaUIManagement sharedInstance].friendsOfNew = [NSNumber numberWithInt:friendOfNew];
            }
            if(lovedOfNew != -1 && [[NaNaUIManagement sharedInstance].lovedOfNew intValue] != lovedOfNew){
                [NaNaUIManagement sharedInstance].lovedOfNew = [NSNumber numberWithInt:lovedOfNew];
            }
            if(messageOfNew != -1 && [[NaNaUIManagement sharedInstance].messageOfNew intValue] != messageOfNew){
                [NaNaUIManagement sharedInstance].messageOfNew = [NSNumber numberWithInt:messageOfNew];
            }
            if(visitorOfNew != -1 && [[NaNaUIManagement sharedInstance].visitorOfNew intValue] != visitorOfNew){
                [NaNaUIManagement sharedInstance].visitorOfNew = [NSNumber numberWithInt:visitorOfNew];
            }
            if(point != -1 && [[NaNaUIManagement sharedInstance].point intValue] != point){
                [NaNaUIManagement sharedInstance].point = [NSNumber numberWithInt:point];
            }
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }
    
    
    
    if (!status) {
        self.hasError = YES;
        self.errorMessage = headers[@"message"];
    }
    if (!self.hasError) {
        [self sendMsgToAutoCloseProgress:request.clazz];
    }
    
    // 调用委托
    NSDictionary *result = [self configRequestResult:self.hasError withErrorMsg:self.errorMessage withData:dic[@"body"] withContext:request.context];
    
    // 用于KVO回调
    if (request.requestCompleted != nil) {
        request.requestCompleted(result);
    }
}

- (void)requestFailed:(NaNaHTTPRequest *)request{
    self.hasError = YES;
    NSError *error = [request error];
    if (error.code == ASIRequestTimedOutErrorType) {
        self.errorMessage = NSLocalizedString(@"TimeOut", @"");
    }else{
        self.errorMessage = NSLocalizedString(@"NetWorkError", @"");
    }
    
    NSDictionary *result = [self configRequestResult:self.hasError withErrorMsg:self.errorMessage withData:nil withContext:request.context];
    // 用于KVO回调
    if (request.requestCompleted != nil) {
        request.requestCompleted(result);
    }
    //调用委托
    if (nil != request.clazz && nil != request.clazzAction && [request.clazz respondsToSelector:request.clazzAction]) {
        if (request.needAutoShowErrorMessage) {
            [self sendMsgToAutoShowErrorMessage:request.clazz withMsg:[result objectForKey:ASI_REQUEST_ERROR_MESSAGE]];
        }
        [self callback:request.clazz withAction:request.clazzAction withResult:result];
    }
}

-(id)getJSONObject:(NSString *)jsonString{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [data objectFromJSONData];
}

-(void) sendMsgToAutoCloseProgress : (id) clazz{
    SEL autoCloseProgress = NSSelectorFromString(@"autoCloseProgress");
    
    if (nil != autoCloseProgress && nil != clazz) {
        if ([clazz respondsToSelector:autoCloseProgress]) {
            objc_msgSend(clazz, autoCloseProgress);
        }
    }
}

-(void) sendMsgToAutoShowErrorMessage : (id) clazz withMsg : (NSString *) msg{
    SEL autoShowErrorMessage = NSSelectorFromString(@"showProgressAutoWithText:withDelayTime:");
    if (nil != autoShowErrorMessage && nil != clazz) {
        if ([clazz respondsToSelector:autoShowErrorMessage]) {
            objc_msgSend(clazz, autoShowErrorMessage,msg,2);
        }
    }
}

-(NSDictionary *) configRequestResult : (BOOL) hasError withErrorMsg : (NSString *) errorMsg withData : (NSDictionary *) data withContext:(id)context{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:5];
    [result setObject:[NSNumber numberWithBool:hasError] forKey:ASI_REQUEST_HAS_ERROR];
    if (nil == errorMsg) {
        [result setObject:@"" forKey:ASI_REQUEST_ERROR_MESSAGE];
    }else{
        [result setObject:errorMsg forKey:ASI_REQUEST_ERROR_MESSAGE];
    }
    
    if (nil != data) {
        [result setObject:data forKey:ASI_REQUEST_DATA];
    }
    
    if (nil != context) {
        [result setObject:context forKey:ASI_REQUEST_CONTEXT];
    }
    return [NSDictionary dictionaryWithDictionary:result];
}

-(void) callback : (id) clazz withAction : (SEL) action withResult : (NSDictionary *)result{
    NSString *callbackParameters = NSStringFromSelector(action);
    if (callbackParameters) {
        NSArray *parameters=[callbackParameters componentsSeparatedByString:@":"];
        if ([parameters count] == 2) {
            objc_msgSend(clazz,action,result);
        }else{
            NSAssert([parameters count] == 2, @"回调函数非法");
        }
    }
}


@end
