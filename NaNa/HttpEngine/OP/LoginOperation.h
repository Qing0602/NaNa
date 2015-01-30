//
//  LoginOperation.h
//  NaNa
//
//  Created by singlew on 15/1/30.
//  Copyright (c) 2015年 dengfang. All rights reserved.
//

#import "NaNaOperation.h"

typedef enum{
    NaNaLogin,
    PostUserNameAndPassword,
}LoginType;

@interface LoginOperation : NaNaOperation
-(LoginOperation *) initLogin : (NSString *) userName withPassword : (NSString *) password;
-(LoginOperation *) initPostUserName : (NSString *) userName withPassword : (NSString *) password;
@end
