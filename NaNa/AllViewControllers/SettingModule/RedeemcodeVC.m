//
//  RedeemcodeVC.m
//  NaNa
//
//  Created by shenran on 12/4/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "RedeemcodeVC.h"

@interface RedeemcodeVC ()
-(void) changeClick;
@end

@implementation RedeemcodeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"changeCodeDic" options:0 context:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"changeCodeDic"];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([@"changeCodeDic" isEqualToString:keyPath]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].changeCodeDic];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            [self showProgressOnwindowsWithText:[tempData objectForKey:ASI_REQUEST_ERROR_MESSAGE] withDelayTime:1.5f];
        }else
        {
            [self showProgressOnwindowsWithText:[tempData objectForKey:ASI_REQUEST_ERROR_MESSAGE] withDelayTime:1.5f];
        }
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"兑换码";
    
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0f, 90.0f, 50.0f, 20.0f)];
    self.codeLabel.backgroundColor = [UIColor clearColor];
    self.codeLabel.text = @"卡号";
    self.codeLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    self.codeLabel.textColor = default_color_dark;
    [self.view addSubview:self.codeLabel];
    
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(self.codeLabel.frame.origin.x + self.codeLabel.frame.size.width,
                                                                   self.codeLabel.frame.origin.y + 4.0f, 220.0f, 20.0f)];
    self.codeField.textAlignment = NSTextAlignmentLeft;
    self.codeField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.codeField];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, self.codeField.frame.origin.y + self.codeField.frame.size.height + 6.0f, 300.0f, 2.0f)];
    line.image = [UIImage imageNamed:@"cell_line"];
    [self.view addSubview:line];
    
    self.passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0f,
                                                                   line.frame.origin.y + line.frame.size.height + 12.0f, 50.0f, 20.0f)];
    
    self.passwordLabel.text = @"密码";
    self.passwordLabel.backgroundColor = [UIColor clearColor];
    self.passwordLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    self.passwordLabel.textColor = default_color_dark;
    [self.view addSubview:self.passwordLabel];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(self.passwordLabel.frame.origin.x + self.passwordLabel.frame.size.width,
                                                                       self.passwordLabel.frame.origin.y + 4.0f , 220.0f, 20.0f)];
    self.passwordField.textAlignment = NSTextAlignmentLeft;
    self.passwordField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.passwordField];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, self.passwordLabel.frame.origin.y + self.passwordLabel.frame.size.height + 10.0f, 300.0f, 2.0f)];
    line1.image = [UIImage imageNamed:@"cell_line"];
    [self.view addSubview:line1];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.frame = CGRectMake(40.0f, line1.frame.origin.y + 20.0f, 240.0f, 40.0f);
    [changeButton setBackgroundColor:[UIColor blackColor]];
    [changeButton setTitle:@"兑换" forState:UIControlStateNormal];
    [changeButton setTitle:@"兑换" forState:UIControlStateHighlighted];
    changeButton.layer.cornerRadius = 5;
    changeButton.layer.borderWidth = 1;
    changeButton.clipsToBounds = YES;
    [changeButton addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
}

-(void) changeClick{
    if ([self.codeField.text length] == 0) {
        [self showProgressOnwindowsWithText:@"卡号不能为空" withDelayTime:1.5f];
        return;
    }
    
    if ([self.passwordField.text length] == 0) {
        [self showProgressOnwindowsWithText:@"密码不能为空" withDelayTime:1.5f];
        return;
    }
    
    [[NaNaUIManagement sharedInstance] changeCode:self.codeField.text withPassword:self.passwordField.text];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
}

- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
