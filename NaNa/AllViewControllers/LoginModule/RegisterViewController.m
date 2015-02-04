//
//  RegisterViewController.m
//  NaNa
//
//  Created by ZhangQing on 15/2/2.
//  Copyright (c) 2015年 dengfang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UAlertView.h"
@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate>
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
    
    UITableView *_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,
                                                               80,
                                                               self.view.frame.size.width,
                                                                            200)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //_tableView.separatorColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    
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
    [self showProgressWithText:@"正在注册"];
    [[NaNaUIManagement sharedInstance] postUserName:userName.text withPassword:password.text];
}

#pragma mark - UITableview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //被选中cell容器
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"用户名";
            if (!userName) {
                userName = [[UITextField alloc] init];
                [userName setBorderStyle:UITextBorderStyleNone];
                userName.frame = CGRectMake(90, 8, 220, 24);
                //userName.placeholder = @"用户名";
                [cell.contentView addSubview:userName];
            }
            [userName becomeFirstResponder];
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"密码";
            if (!password) {
                password = [[UITextField alloc] init];
                [password setBorderStyle:UITextBorderStyleNone];
                password.frame = CGRectMake(90, 8, 220, 24);
                password.secureTextEntry = YES;
                //password.placeholder = @"密码";
                [cell.contentView addSubview:password];
            }

        }
            break;
        case 2:
        {
            cell.textLabel.text = @"确认密码";
            if (!confirmPassword) {
                confirmPassword = [[UITextField alloc] init];
                [confirmPassword setBorderStyle:UITextBorderStyleNone];
                confirmPassword.frame = CGRectMake(90, 8, 220, 24);
                confirmPassword.secureTextEntry = YES;
                //confirmPassword.placeholder = @"密码";
                [cell.contentView addSubview:confirmPassword];
            }
        }
            break;
        default:
            break;
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
@end
