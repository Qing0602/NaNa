//
//  PasswordLockViewController.m
//  NaNa
//
//  Created by ZhangQing on 14-9-26.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "PasswordLockViewController.h"

@interface PasswordLockViewController ()
{
    NSInteger verifyType;
    
    NSInteger pwdNumbers;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"密码锁";
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    cachePwd = @"";
    pwdNumbers = 0;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 120, 16.f)];
    title.textColor = [self colorWithHexString:@"#1e1e1e"];
    title.font = [UIFont boldSystemFontOfSize:15.f];
    title.text = @"请输入密码";
    title.textAlignment = NSTextAlignmentCenter;
    [self.defaultView addSubview:title];
    
    numberOfEnter = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 16.f)];
    numberOfEnter.textColor = [self colorWithHexString:@"#1e1e1e"];
    numberOfEnter.font = [UIFont boldSystemFontOfSize:15.f];
    numberOfEnter.text = @"第一次输入";
    numberOfEnter.textAlignment = NSTextAlignmentCenter;
    [self.defaultView addSubview:numberOfEnter];
    
    
    UITextView * textViewPwdLock=[[UITextView alloc]
                            initWithFrame:CGRectMake(0, numberOfEnter.frame.origin.y+
                                                     numberOfEnter.frame.size.height+
                                                     50.0+61, 320,80)];
    [textViewPwdLock setEditable:NO];
    [textViewPwdLock setTextAlignment:NSTextAlignmentCenter];
    [textViewPwdLock setBackgroundColor:[UIColor clearColor]];
    [textViewPwdLock setTextColor:@"#d8d8d8".color];
    [textViewPwdLock setText:@"设置密码锁，\n保护你在NANA的小秘密"];
    [textViewPwdLock setFont:NormalFont(13)];
    [self.defaultView addSubview:textViewPwdLock];
    
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
    
    [hiddenInput becomeFirstResponder];
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
    numberOfEnter.text = @"再次输入";
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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
