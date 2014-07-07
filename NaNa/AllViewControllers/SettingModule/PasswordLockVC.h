//
//  PasswordLockVC.h
//  NaNa
//
//  Created by shenran on 11/3/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "UBasicViewController.h"

@interface PasswordLockVC : UBasicViewController<UITextFieldDelegate>
{
    UITextView * _statusTextView;
    

}
@property (nonatomic, retain) IBOutlet NSArray * _passwordArray;

-(PasswordLockVC*)initWithType:(int) type;
@end
