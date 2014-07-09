//
//  PalmHttpEngine.h
//  teacher
//
//  Created by singlew on 14-3-7.
//  Copyright (c) 2014年 ws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "NaNaHTTPRequest.h"
#import "NaNaFormDataRequest.h"
#import "NaNaOperation.h"

@interface NaNaHttpEngine : NSObject
// private
@property (nonatomic,strong) NSString *errorMessage;
@property (nonatomic) BOOL hasError;
-(void) sendMsgToAutoShowErrorMessage : (id) clazz withMsg : (NSString *) msg;
-(void) callback : (id) clazz withAction : (SEL) action withResult : (NSDictionary *)result;
-(NSDictionary *) configRequestResult : (BOOL) hasError withErrorMsg : (NSString *) errorMsg withData : (NSDictionary *) data withContext : (id) context;

// public
-(BOOL) canConntected;
-(BOOL) addSTOperation : (NaNaHTTPRequest *)op;
-(BOOL) canConnected : (NaNaHTTPRequest *) request;
-(void) requestFinished : (NaNaHTTPRequest *)request;
-(void) requestFailed : (NaNaHTTPRequest *)request;
@end
