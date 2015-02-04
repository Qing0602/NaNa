//
//  RegisterViewController.m
//  NaNa
//
//  Created by ZhangQing on 15/2/2.
//  Copyright (c) 2015年 dengfang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UAlertView.h"
@interface RegisterViewController ()
{
    UITextField *userName;
    UITextField *password;
    UITextField *confirmPassword;
}
@end

@implementation RegisterViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self closeProgress];
    if ([keyPath isEqualToString:@"regResult"]) {
        NSDictionary *result = [NaNaUIManagement sharedInstance].regResult;
        if (![result[@"hasError"] boolValue]) {
            [UAlertView showAlertViewWithMessage:result[@"errorMessage"] delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        }else
        {
            [UAlertView showAlertViewWithMessage:@"注册成功" delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"regResult" options:0 context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"regResult"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeSubmit];
    self.title = @"注册";
    
    userName = [[UITextField alloc] init];
    [userName setBorderStyle:UITextBorderStyleRoundedRect];
    userName.frame = CGRectMake(40, 100, 240, 24);
    userName.placeholder = @"用户名";
    [self.view addSubview:userName];
    
    password = [[UITextField alloc] init];
    [password setBorderStyle:UITextBorderStyleRoundedRect];
    password.frame = CGRectMake(40, 144, 240, 24);
    password.secureTextEntry = YES;
    password.placeholder = @"密码";
    [self.view addSubview:password];
    
    confirmPassword = [[UITextField alloc] init];
    [confirmPassword setBorderStyle:UITextBorderStyleRoundedRect];
    confirmPassword.frame = CGRectMake(40, 188, 240, 24);
    confirmPassword.secureTextEntry = YES;
    confirmPassword.placeholder = @"密码";
    [self.view addSubview:confirmPassword];
    
    [userName becomeFirstResponder];
    /*
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setImage:[UIImage imageNamed:@"LoginButton"] forState:UIControlStateNormal];
    [confirm setImage:[UIImage imageNamed:@"LoginButton"] forState:UIControlStateSelected];
    [confirm addTarget:self action:@selector(confirmRegister) forControlEvents:UIControlEventTouchUpInside];
    confirm.frame=CGRectMake(100, 232, 120, 25);
    [self.view addSubview:confirm];
     */
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemPressed:(UIButton *)btn
{
    if (userName.text.length < 5) {
        [UAlertView showAlertViewWithMessage:@"用户名必须大于6位" delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        return;
    }
    if (password.text.length < 5 ) {
        [UAlertView showAlertViewWithMessage:@"密码必须大于6位" delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        return;
    }
    
    if (![password.text isEqualToString:confirmPassword.text]) {
        [UAlertView showAlertViewWithMessage:@"密码不一致" delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        return;
    }
    //-(void) postUserName : (NSString *) userName withPassword : (NSString *) password;
    [self showProgressWithText:@"正在购买"];
    [[NaNaUIManagement sharedInstance] postUserName:userName.text withPassword:password.text];
}
@end
