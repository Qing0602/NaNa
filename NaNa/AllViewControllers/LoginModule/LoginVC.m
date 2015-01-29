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
@interface LoginVC ()<UITextFieldDelegate>

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
                                                             self.defaultView.frame.size.height - 122,
                                                             self.defaultView.frame.size.width, 122)];
    [tabbar setBackgroundColor:[UIColor blackColor]];
    
    UITextField *userName = [[UITextField alloc] init];
    [userName setBorderStyle:UITextBorderStyleRoundedRect];
    userName.frame = CGRectMake(42, 11, 135, 24);
    userName.placeholder = @"用户名";
    userName.returnKeyType = UIReturnKeyDone;
    userName.delegate = self;
    [tabbar addSubview:userName];
    
    UITextField *password = [[UITextField alloc] init];
    [password setBorderStyle:UITextBorderStyleRoundedRect];
    password.frame = CGRectMake(42, 44, 135, 24);
    password.secureTextEntry = YES;
    password.placeholder = @"密码";
    password.returnKeyType = UIReturnKeyDone;
    password.delegate = self;
    [tabbar addSubview:password];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setImage:[UIImage imageNamed:@"LoginButton"] forState:UIControlStateNormal];
    [loginButton setImage:[UIImage imageNamed:@"LoginButton"] forState:UIControlStateSelected];
    loginButton.tag=3;
    [loginButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.frame=CGRectMake(197, 11, 72.5f, 25);
    [tabbar addSubview:loginButton];
    
    UIButton *qqButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [qqButton setImage:[UIImage imageNamed:@"QQLogin"] forState:UIControlStateNormal];
    [qqButton setImage:[UIImage imageNamed:@"QQLoginPressed"] forState:UIControlStateSelected];
    qqButton.tag=1;
    [qqButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    qqButton.frame=CGRectMake(197, 69, 28, 27);
    [tabbar addSubview:qqButton];
    
    UIButton *sinaButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [sinaButton setImage:[UIImage imageNamed:@"SinaLogin"] forState:UIControlStateNormal];
    [sinaButton setImage:[UIImage imageNamed:@"SinaLoginPressed"] forState:UIControlStateSelected];
    sinaButton.tag=2;
    [sinaButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    sinaButton.frame=CGRectMake(239, 69, 28, 27);
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


//当开始点击textField会调用的方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

//按下Done按钮的调用方法，我们让键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)onClick:(UIButton *)sender{
    int TAG=sender.tag;
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
        case 3:
            break;
        default:
            break;
    }
}

@end
