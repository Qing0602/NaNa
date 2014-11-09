//
//  MoreVC.m
//  NaNa
//
//  Created by singlew on 14/11/9.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "MoreVC.h"
#import "TaPageVC.h"

@interface MoreVC ()
@property (nonatomic,strong) NSString *navTitle;
@property (nonatomic,strong) NSURL *url;
@end

@implementation MoreVC

-(id) initMore : (NSURL *) url withTitle : (NSString *) title{
    self = [super init];
    if (nil != self) {
        self.navTitle = title;
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    // title
    self.title = self.navTitle;
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
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
    [_defaultView addSubview:_myWebView];
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        _activityView.center = _myWebView.center;
    }
    [_myWebView addSubview:_activityView];
    _myWebView.scalesPageToFit = YES;
    _myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    _myWebView.scrollView.showsVerticalScrollIndicator = NO;
//    [_myWebView loadRequest:URLREQUEST(K_WEBVIEW_URL_FRIEND,temp)];
    [_myWebView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [_defaultView addSubview:_myWebView];
}

#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [request.URL absoluteString];
    if([url rangeOfString:@"/user/show"].location != NSNotFound) {
        // 跳转新页面：TA
        TaPageVC *controller = [[TaPageVC alloc] initWithURL:url];
        [self.navigationController pushViewController:controller animated:YES];
        
        // 移除左右菜单栏
        [self removeSideMenuController];
        return NO;
    }
    return YES;
}

@end
