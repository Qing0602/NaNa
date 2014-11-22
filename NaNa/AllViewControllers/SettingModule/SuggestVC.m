//
//  SuggestVC.m
//  NaNa
//
//  Created by shenran on 10/31/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "SuggestVC.h"

@interface SuggestVC ()

@end

@implementation SuggestVC

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
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeSubmit];
    
    // webview
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] init];
        _myWebView.frame = CGRectMake(0,
                                      0,
                                      self.defaultView.frame.size.width,
                                      self.defaultView.frame.size.height);
        _myWebView.backgroundColor = [UIColor clearColor];
        _myWebView.delegate = self;
    }
    [self.defaultView addSubview:_myWebView];
    _myWebView.scalesPageToFit = YES;
    NSString *temp = [NSString stringWithFormat:@"userId=%d",[NaNaUIManagement sharedInstance].userAccount.UserID];
    [_myWebView loadRequest:URLREQUEST(K_WEBVIEW_URL_SUGGEST,temp)];
}
#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemPressed:(UIButton *)btn {
    [_myWebView stringByEvaluatingJavaScriptFromString:@"submitSuggest();"];
}
@end
