//
//  FriendVC.m
//  NaNa
//
//  Created by shenran on 10/31/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "FriendVC.h"
#import "TaPageVC.h"
@interface FriendVC ()

@end

@implementation FriendVC


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setSideMenuController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    // title
    self.title = STRING(@"friend");
    [self setNavLeftType:UNavBarBtnTypeMenu navRightType:UNavBarBtnTypeTa];
    
    // webview
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] init];
        _myWebView.frame = CGRectMake(0,
                                      0,
                                      self.defaultView.frame.size.width,
                                      self.defaultView.frame.size.height - tabBarHeight);
        _myWebView.backgroundColor = [UIColor clearColor];
        _myWebView.delegate = self;
    }
    [_defaultView addSubview:_myWebView];
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        _activityView.center = _myWebView.center;
    }
    [_myWebView addSubview:_activityView];
    _myWebView.scalesPageToFit = YES;
    NSString *temp = [NSString stringWithFormat:@"userId=%d",[NaNaUIManagement sharedInstance].userAccount.UserID];
     [_myWebView loadRequest:URLREQUEST(K_WEBVIEW_URL_FRIEND,temp)];
    [_defaultView addSubview:_myWebView];
    
}

- (void)dealloc {
    SAFERELEASE(_myWebView)
    SAFERELEASE(_activityView)
    [super dealloc];
}

#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)rightItemPressed:(UIButton *)btn {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
#pragma mark - Webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [request.URL absoluteString];
    if([url rangeOfString:@"/user/show"].location != NSNotFound) {
        // 跳转新页面：TA
        TaPageVC *controller = [[[TaPageVC alloc] initWithURL:url] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
        
        // 移除左右菜单栏
        [self removeSideMenuController];
        return NO;
    }
    return YES;
}
@end
