//
//  PasswordLockViewController.h
//  NaNa
//
//  Created by ZhangQing on 14-9-26.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//
#define VERIFYSUCCESS_KEY @"VerifySuccess"
#import "UBasicViewController.h"
typedef enum
{
    VERIFY_TYPE_SETTING = 1,
    VERIFY_TYPE_CHANGE = 2,
    VERIFY_TYPE_VERIFY = 3,
}VERIFY_TYPE;
@interface PasswordLockViewController : UBasicViewController<UITextFieldDelegate>

-(id)initWithType:(VERIFY_TYPE)type;

@end
