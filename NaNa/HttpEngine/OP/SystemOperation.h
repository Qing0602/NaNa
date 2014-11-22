//
//  SystemOperation.h
//  NaNa
//
//  Created by singlew on 14-8-9.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaOperation.h"

typedef enum{
    kPostDriverToken,
    kPostChangeCode,
}SysTemType;

@interface SystemOperation : NaNaOperation

-(SystemOperation *) initPostSystemDriverToken : (int) userID withDriverToken : (NSString *) token;

-(SystemOperation *) initChangeCode : (NSString *) code withPassword : (NSString *)password;
@end
