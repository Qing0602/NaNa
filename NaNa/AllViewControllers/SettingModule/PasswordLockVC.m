//
//  PasswordLockVC.m
//  NaNa
//
//  Created by shenran on 11/3/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "PasswordLockVC.h"

@interface PasswordLockVC ()

@end

@implementation PasswordLockVC

NSArray * _passwordArray;
UITextField * hiddenInput;

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
	// Do any additional setup after loading the view.
    //UITextField * input =[_passwordArray objectAtIndex:0];
    [hiddenInput becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    // title
    self.title = STRING(@"suggestion");
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    [self.defaultView setBackgroundColor:default_color_light_bg];
    // webview
    UITextView * textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 25.0, 320,30)];
    [textView setTextAlignment:NSTextAlignmentCenter];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setText:@"请输入密码"];
    [textView setEditable:NO];
    [textView setFont:BoldFont(15)];
    [self.defaultView addSubview:textView];
    [textView release];
    _statusTextView=[[UITextView alloc]  initWithFrame:CGRectMake(0, textView.frame.origin.y+
                                                                    textView.frame.size.height+
                                                                  8, 320,30)];
    [_statusTextView setTextAlignment:NSTextAlignmentCenter];
    [_statusTextView setBackgroundColor:[UIColor clearColor]];
    [_statusTextView setText:@"第一次输入"];
    [_statusTextView setEditable:NO];
    [_statusTextView setFont:NormalFont(15)];
    [self.defaultView addSubview:_statusTextView];
    [_statusTextView release];
    hiddenInput=[[UITextField alloc]
                             initWithFrame:CGRectMake(23.0,
                                                      25,
                                                      61.0, 61.0)];
    [hiddenInput setHidden:YES];
    hiddenInput.keyboardType = UIKeyboardTypeNumberPad;
    hiddenInput.delegate=self;
    [hiddenInput addTarget:self action:@selector(textChange:)forControlEvents:UIControlEventEditingChanged];
    
    [self.defaultView addSubview:hiddenInput];

    NSMutableArray * mpasswordInputs=[NSMutableArray arrayWithCapacity:4];
    for (int i=0; i<4; i++) {
        UITextField * passInput=[[UITextField alloc]
                                 initWithFrame:CGRectMake(23.0+71.0*i,
                                                          _statusTextView.frame.origin.y+
                                                          _statusTextView.frame.size.height+
                                                                              25,
                                                          61.0, 61.0)];
        [passInput setBorderStyle:UITextBorderStyleBezel];
        [passInput setTextAlignment:NSTextAlignmentCenter];
        passInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passInput.secureTextEntry = YES; //密码
        passInput.keyboardType = UIKeyboardTypeNumberPad;
        [passInput setEnabled:NO];
        

        passInput.tag=i;
        [mpasswordInputs insertObject:passInput atIndex:i];
        if (i == 0) {
            [passInput becomeFirstResponder];
        }
        [self.defaultView addSubview:passInput];
        [passInput release];
    }
    self._passwordArray=[NSArray arrayWithArray:mpasswordInputs];
    
    UITextView * textView2=[[UITextView alloc]
                            initWithFrame:CGRectMake(0, _statusTextView.frame.origin.y+
                                                        _statusTextView.frame.size.height+
                                                                        50.0+61, 320,80)];
    [textView2 setEditable:NO];
    [textView2 setTextAlignment:NSTextAlignmentCenter];
    [textView2 setBackgroundColor:[UIColor clearColor]];
    [textView2 setTextColor:@"#d8d8d8".color];
    [textView2 setText:@"设置密码锁，\n保护你在NANA的小秘密"];
    [textView2 setFont:NormalFont(13)];
    [self.defaultView addSubview:textView2];
    [textView2 release];

    
       
}
-(PasswordLockVC*)initWithType:(int)type
{
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    textField.text=nil;
    return YES;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 4)
    {
        return NO; // return NO to not change text
    }
       return YES;
}

- (void)textChange:(id) sender 
{
    UITextField * textField=(UITextField *)sender;
    NSString * passwd=textField.text;
    for (int pos=0;pos<4; pos++) {
        UITextField * passField=[self._passwordArray objectAtIndex:pos];
        if(pos<textField.text.length)
            [passField setText:[passwd substringWithRange:NSMakeRange(pos, 1)]];
        else
            [passField setText:Nil];
    }
    if(passwd.length==4)
    {
        [self Verify:passwd];
        _statusTextView.text = @"再次输入";
        for (int i =0; i < self._passwordArray.count; i++) {
            UITextField *inputTextfield = [self._passwordArray objectAtIndex:i];
            inputTextfield.text = @"";
            if (i == 0) {
                [inputTextfield becomeFirstResponder];
            }
        }
    }
}

-(void)Verify:(NSString*)password
{

}
#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    //    UINavigationController *navController = (UINavigationController *)APP_DELEGATE.rootViewController.centerViewController;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemPressed:(UIButton *)btn {
    
}
@end
