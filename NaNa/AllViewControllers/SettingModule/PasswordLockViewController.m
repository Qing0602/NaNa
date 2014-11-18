//
//  PasswordLockViewController.m
//  NaNa
//
//  Created by ZhangQing on 14-9-26.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "PasswordLockViewController.h"
#import "AppDelegate.h"
#import "UAlertView.h"

#import "PasswordLockManagementViewController.h"
@interface PasswordLockViewController ()
{
    NSInteger verifyType;
    
    NSInteger pwdNumbers;
    
    UILabel *title;
    UILabel *numberOfEnter;
    
    UITextField *hiddenInput;
    
    NSString *cachePwd;
    
    
}

@property NSMutableArray *pwdTextFields;
@end

@implementation PasswordLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithType:(VERIFY_TYPE)type
{
    self = [super init];
    if (self) {
        verifyType = type;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary *pwdInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
    if (pwdInfo && verifyType != VERIFY_TYPE_SETTING) {
        cachePwd = pwdInfo[PWD_LOCK_DATA];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [hiddenInput becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"密码锁";
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    cachePwd = @"";
    pwdNumbers = 0;
    
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 120, 16.f)];
    title.textColor = [self colorWithHexString:@"#1e1e1e"];
    title.font = [UIFont boldSystemFontOfSize:15.f];
    title.textAlignment = NSTextAlignmentCenter;
    [self.defaultView addSubview:title];
    
    numberOfEnter = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 16.f)];
    numberOfEnter.textColor = [self colorWithHexString:@"#1e1e1e"];
    numberOfEnter.font = [UIFont boldSystemFontOfSize:15.f];
    numberOfEnter.textAlignment = NSTextAlignmentCenter;
    [self.defaultView addSubview:numberOfEnter];
    
    
//    UITextView * textViewPwdLock=[[UITextView alloc]
//                            initWithFrame:CGRectMake(0, numberOfEnter.frame.origin.y+
//                                                     numberOfEnter.frame.size.height+
//                                                     50.0+61, 320,80)];
//    [textViewPwdLock setEditable:NO];
//    [textViewPwdLock setTextAlignment:NSTextAlignmentCenter];
//    [textViewPwdLock setBackgroundColor:[UIColor clearColor]];
//    [textViewPwdLock setTextColor:@"#d8d8d8".color];
//    [textViewPwdLock setText:@"设置密码锁，保护你在\nNANA的小秘密"];
//    [textViewPwdLock setFont:NormalFont(13)];
//    [self.defaultView addSubview:textViewPwdLock];
    
    hiddenInput=[[UITextField alloc]
                 initWithFrame:CGRectMake(23.0,
                                          25,
                                          61.0, 61.0)];
    [hiddenInput setHidden:YES];
    hiddenInput.keyboardType = UIKeyboardTypeNumberPad;
    hiddenInput.delegate=self;
    [hiddenInput addTarget:self action:@selector(textChange:)forControlEvents:UIControlEventEditingChanged];
    [self.defaultView addSubview:hiddenInput];
    
    
    self.pwdTextFields = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        UITextField * passInput=[[UITextField alloc]
                                 initWithFrame:CGRectMake(23.0+71.0*i,
                                                          numberOfEnter.frame.origin.y+
                                                          numberOfEnter.frame.size.height+
                                                          25,
                                                          61.0, 61.0)];
        [passInput setBorderStyle:UITextBorderStyleBezel];
        [passInput setTextAlignment:NSTextAlignmentCenter];
        passInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passInput.secureTextEntry = YES; //密码
        passInput.keyboardType = UIKeyboardTypeNumberPad;
        passInput.delegate = self;
//        [passInput addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        passInput.tag=i;
        [self.pwdTextFields insertObject:passInput atIndex:i];
        
        [self.defaultView addSubview:passInput];
        }
    
    
    
    switch (verifyType) {
        case VERIFY_TYPE_SETTING:
        {
            title.text = @"请设置密码";
            numberOfEnter.text = @"第一次输入";
        }
            break;
            
        default:
        {
            numberOfEnter.text = @"输入密码";
        }
            break;
    }
    
    // Do any additional setup after loading the view.
}
- (void)textChange:(UITextField *)textField
{

    if(textField.text.length == 0)
    {
        pwdNumbers = 0;
        UITextField *pwdInput = [self.pwdTextFields objectAtIndex:pwdNumbers];
        pwdInput.text = @"";
        return;
    }
    
    
    if (textField.text.length > pwdNumbers) {
        //输入一位密码
        UITextField *pwdInput = [self.pwdTextFields objectAtIndex:pwdNumbers];
        NSString *lastStr = [textField.text substringFromIndex:textField.text.length-1];
        pwdInput.text = lastStr;
        pwdNumbers ++;
        if (textField.text.length == 4) {
            if ([cachePwd isEqualToString:@""]) {
                [self clearText];
            }else
            {
                //验证2次密码;
                if ([textField.text isEqualToString:cachePwd]) {
                    switch (verifyType) {
                        case VERIFY_TYPE_CHANGE:
                        {
                            [self clearText];
                        }
                            break;
                        case VERIFY_TYPE_SETTING:
                        {
                            [self saveNewPwd];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                            break;
                        case VERIFY_TYPE_VERIFY:
                        {
                            if (self.navigationController.viewControllers.count > 2 && [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -2] isKindOfClass:[PasswordLockManagementViewController class]]) {
                                NSDictionary *lockData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
                                NSMutableDictionary *temdic = [NSMutableDictionary dictionaryWithDictionary:lockData];
                                [temdic setValue:[NSNumber numberWithBool:NO] forKey:PWD_LOCK_STATUS];
                                lockData = [NSDictionary dictionaryWithDictionary:temdic];
                                [[NSUserDefaults standardUserDefaults] setObject:lockData forKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }else [APP_DELEGATE loadMainView];
                
                        }
                            break;
                            
                        default:
                            break;
                    }
                }else
                {
                    NSLog(@"wrong pwd");
                    [self clearWhenPwdWrong];
                    [UAlertView showAlertViewWithTitle:@"错误" message:@"密码输入错误" delegate:nil cancelButton:@"确定" defaultButton:nil];
                }
                

                    
            }
            
        }
        
    }else
    {
        pwdNumbers --;
        UITextField *pwdInput = [self.pwdTextFields objectAtIndex:pwdNumbers];
        //删除一位密码
        pwdInput.text = @"";

    }


}
-(void)clearText
{
    pwdNumbers = 0;
    cachePwd = hiddenInput.text;
    hiddenInput.text = @"";
    for (UITextField *pwdInput in self.pwdTextFields) {
        pwdInput.text = @"";
    }
    
    if (verifyType == VERIFY_TYPE_CHANGE) {
        cachePwd = @"";
        title.text = @"请设置新密码";
        numberOfEnter.text = @"第一次输入";
        verifyType = VERIFY_TYPE_SETTING;
    }else
    {
        numberOfEnter.text = @"再次输入";
    }
}
-(void)clearWhenPwdWrong
{
    pwdNumbers = 0;
    
    hiddenInput.text = @"";
    for (UITextField *pwdInput in self.pwdTextFields) {
        pwdInput.text = @"";
    }
    
    switch (verifyType) {
        case VERIFY_TYPE_SETTING:
        {
            title.text = @"请设置密码";
            numberOfEnter.text = @"第一次输入";
            cachePwd = @"";
        }
            break;
        case VERIFY_TYPE_CHANGE:
        {
            numberOfEnter.text = @"请输入当前密码";
            cachePwd = @"";
        }
            break;
        default:
        {
            numberOfEnter.text = @"输入密码";
        }
            break;
    }
}
-(void)saveNewPwd
{
    NSDictionary *pwdInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
    if (pwdInfo) {
        NSMutableDictionary *tempPwd = [NSMutableDictionary dictionaryWithDictionary:pwdInfo];
        [tempPwd setValue:cachePwd forKey:PWD_LOCK_DATA];
        pwdInfo = [NSDictionary dictionaryWithDictionary:tempPwd];
    }else
    {
        pwdInfo = [[NSDictionary alloc] initWithObjectsAndKeys:cachePwd,PWD_LOCK_DATA,[NSNumber numberWithBool:YES],PWD_LOCK_STATUS, nil];
    }
    [[NSUserDefaults standardUserDefaults] setObject:pwdInfo forKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *pwdInfos = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
    NSLog(@"%@",pwdInfos);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 4)
    {
        return NO; // return NO to not change text
    }
    return YES;
    
}
#pragma mark - Nav
- (void)leftItemPressed:(UIButton *)btn {
    if (verifyType == VERIFY_TYPE_VERIFY) {
        [APP_DELEGATE loadLoginView];
    }else [self.navigationController popViewControllerAnimated:YES];
    
}
@end
