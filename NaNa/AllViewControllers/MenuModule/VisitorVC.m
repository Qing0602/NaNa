//
//  VisitorVC.m
//  NaNa
//
//  Created by shenran on 10/31/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "VisitorVC.h"
#import "TaPageVC.h"
@interface VisitorVC ()

@end

@implementation VisitorVC


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setSideMenuController];
}

- (void)loadView {
    [super loadView];
    // title
    self.title = STRING(@"guest");
    [self setNavLeftType:UNavBarBtnTypeMenu navRightType:UNavBarBtnTypeTa];
    
    // webview
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] init];
        _myWebView.frame = CGRectMake(0,
                                      0,
                                      self.defaultView.frame.size.width,
                                      self.defaultView.frame.size.height);
        _myWebView.backgroundColor = [UIColor clearColor];
        _myWebView.delegate = self;
        _myWebView.scrollView.showsHorizontalScrollIndicator = NO;
        _myWebView.scrollView.showsVerticalScrollIndicator = NO;
    }
    [self.defaultView addSubview:_myWebView];
    _myWebView.scalesPageToFit = YES;
    NSString *temp = [NSString stringWithFormat:@"userId=%d",[NaNaUIManagement sharedInstance].userAccount.UserID];
    [_myWebView loadRequest:URLREQUEST(K_WEBVIEW_URL_FOLLOW,temp)];
    
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
