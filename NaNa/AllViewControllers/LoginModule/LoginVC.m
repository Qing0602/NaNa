//
//  LoginVC.m
//  NaNa
//
//  Created by shenran on 11/18/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "WebLoginVC.h"
#import "RegisterViewController.h"
#import "InfoEditVC.h"
#import "ColorUtil.h"

@interface LoginVC ()
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *password;
@end

@implementation LoginVC

@synthesize imageList=_imageList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // title
    self.title = @"NaNa";
    
    //定义UIScrollView
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-_navBarView.frame.size.height)];
    _scrollview.backgroundColor=[UIColor redColor];
    _scrollview.contentSize = CGSizeMake(320, 1405);  //scrollview的滚动范围
    _scrollview.showsVerticalScrollIndicator = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.delegate = self;
    _scrollview.scrollEnabled = YES;
    _scrollview.bounces = NO;
    
    UIImageView * image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1405)];
    image.image=[UIImage imageNamed:@"login.png"];
    [_scrollview addSubview:image];
    
    UIView * tabbar=[[UIView alloc] initWithFrame:CGRectMake(0,
                                                             self.defaultView.frame.size.height - 192,
                                                             self.defaultView.frame.size.width, 192)];
    [tabbar setBackgroundColor:[UIColor blackColor]];
    
    
//    UITextField *userName = [[UITextField alloc] init];
//    [userName setBorderStyle:UITextBorderStyleRoundedRect];
//    userName.frame = CGRectMake(42, 11, 135, 24);
//    userName.placeholder = @"用户名";
//    userName.returnKeyType = UIReturnKeyDone;
//    userName.delegate = self;
//    [tabbar addSubview:userName];
//    
//    UITextField *password = [[UITextField alloc] init];
//    [password setBorderStyle:UITextBorderStyleRoundedRect];
//    password.frame = CGRectMake(42, 44, 135, 24);
//    password.secureTextEntry = YES;
//    password.placeholder = @"密码";
//    password.returnKeyType = UIReturnKeyDone;
//    password.delegate = self;
//    [tabbar addSubview:password];
    
    self.userName = [[UITextField alloc] init];
    [self.userName setBorderStyle:UITextBorderStyleRoundedRect];
    self.userName.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.userName.frame = CGRectMake(37, 41, 150, 30);
    self.userName.placeholder = @"  用户名";
    self.userName.font = [UIFont systemFontOfSize:12.0f];
    self.userName.textColor = [UIColor colorWithHexString:@"c8c7cf"];
    [self.userName setValue:[UIColor colorWithHexString:@"#c8c7cf"] forKeyPath:@"_placeholderLabel.textColor"];
    self.userName.returnKeyType = UIReturnKeyDone;
    self.userName.delegate = self;
    [tabbar addSubview:self.userName];
    
    self.password = [[UITextField alloc] init];
    [self.password setBorderStyle:UITextBorderStyleRoundedRect];
    self.password.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.password.frame = CGRectMake(37, 79, 150, 30);
    self.password.secureTextEntry = YES;
    self.password.placeholder = @"  密码";
    [self.password setValue:[UIColor colorWithHexString:@"#c8c7cf"] forKeyPath:@"_placeholderLabel.textColor"];
    self.password.font = [UIFont systemFontOfSize:12.0f];
    self.password.returnKeyType = UIReturnKeyDone;
    self.password.delegate = self;
    [tabbar addSubview:self.password];
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundColor:[UIColor colorWithHexString:@"#ff6633"]];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateHighlighted];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    loginButton.layer.cornerRadius = 5;
    loginButton.clipsToBounds = YES;
    loginButton.tag =3;
    loginButton.frame=CGRectMake(207, 41, 82.5f, 32);
    [loginButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabbar addSubview:loginButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setBackgroundColor:[UIColor clearColor]];
    [registerButton setTitle:@"注册新用户>" forState:UIControlStateNormal];
    [registerButton setTitle:@"注册新用户>" forState:UIControlStateHighlighted];
    [registerButton setTitleColor:[UIColor colorWithHexString:@"#118ede"] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithHexString:@"#118ede"] forState:UIControlStateHighlighted];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:12];
    registerButton.tag = 4;
    [registerButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.frame=CGRectMake(212, 83, 73, 23);
    [tabbar addSubview:registerButton];
    
    UILabel *other = [[UILabel alloc] init];
    other.text = @"其他登录:";
    other.backgroundColor = [UIColor clearColor];
    other.textColor = [UIColor grayColor];
    other.font = [UIFont systemFontOfSize:12.0f];
    [other sizeToFit];
//    other.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0f, 117.0f);
    other.frame = CGRectMake(37.0f, 140.0f, other.frame.size.width, other.frame.size.height);
    [tabbar addSubview:other];
    
    UIButton *qqButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [qqButton setImage:[UIImage imageNamed:@"QQLogin"] forState:UIControlStateNormal];
    [qqButton setImage:[UIImage imageNamed:@"QQLoginPressed"] forState:UIControlStateSelected];
    qqButton.tag=1;
    [qqButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    qqButton.frame=CGRectMake(122, 129, 42, 40);
    [tabbar addSubview:qqButton];
    
    UIButton *sinaButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [sinaButton setImage:[UIImage imageNamed:@"SinaLogin"] forState:UIControlStateNormal];
    [sinaButton setImage:[UIImage imageNamed:@"SinaLoginPressed"] forState:UIControlStateSelected];
    sinaButton.tag=2;
    [sinaButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    sinaButton.frame=CGRectMake(177, 129, 42, 40);
    [tabbar addSubview:sinaButton];
    
    [self.defaultView addSubview:_scrollview];
    [self.defaultView addSubview:tabbar];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void) keyboardWillShow : (NSNotification *)not{
    CGRect keyboardBounds;
    [[not.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [not.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [not.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [self.view setFrame:CGRectMake(0, -260.f, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

-(void) keyboardWillHide : (NSNotification *)not{
    NSNumber *duration = [not.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [not.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [self.view setFrame:CGRectMake(0, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"loginResult" options:0 context:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"loginResult"];
}

//当开始点击textField会调用的方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

//按下Done按钮的调用方法，我们让键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loginResult"]) {
        NSDictionary *result = [NaNaUIManagement sharedInstance].loginResult;
        if ([result[ASI_REQUEST_HAS_ERROR] boolValue]) {
            [UAlertView showAlertViewWithMessage:result[@"errorMessage"] delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        }else{
            NaNaUserAccountModel *userAccount = [[NaNaUserAccountModel alloc] init];
            if ([userAccount convertForDic:result[ASI_REQUEST_DATA]]) {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:userAccount.UserID] forKeyPath:@"UserID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [NaNaUIManagement sharedInstance].userAccount = userAccount;
                [NaNaUserAccountModel serializeModel:userAccount withFileName:@"NaNaUserAccount"];
            }
            
            NSInteger isfirst = [[result[ASI_REQUEST_DATA] objectForKey:@"is_1st"] integerValue];
            if (isfirst == 0) {
                [APP_DELEGATE loadMainView];
            }else{
                InfoEditVC *infoEdit = [[InfoEditVC alloc] initWithType:TYPE_LOGIN];
                [self.navigationController pushViewController:infoEdit animated:YES];
            }
        }
    }
}

-(void)onClick:(UIButton *)sender{
    NSInteger TAG=sender.tag;
    switch (TAG) {
        case 1:{
            WebLoginVC *webQQLogin =  [[WebLoginVC alloc] init];
            [webQQLogin setURL:[NSString stringWithFormat:@"%@/qqlogin/index.php",K_DOMAIN_NANA]];
            [self.navigationController pushViewController:webQQLogin animated:YES];
        }
        break;
        case 2:{
            WebLoginVC *webWeiBoLogin =  [[WebLoginVC alloc] init];
            [webWeiBoLogin setURL:[NSString stringWithFormat:@"%@/wblogin/index.php",K_DOMAIN_NANA]];
            [self.navigationController pushViewController:webWeiBoLogin animated:YES];
        }
        break;
        case 3:{
            NSString *uName = self.userName.text;
            NSString *pWord = self.password.text;
            if (uName == nil || [uName isEqualToString:@""]) {
                [self showProgressWithText:@"请填写用户名" withDelayTime:2.0f];
                break;
            }
            if (pWord == nil || [pWord isEqualToString:@""]) {
                [self showProgressWithText:@"请填写密码" withDelayTime:2.0f];
                break;
            }
            [[NaNaUIManagement sharedInstance] login:uName withPassword:pWord];
            break;
        }
        case 4:
        {
            RegisterViewController *registerVC = [[RegisterViewController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
