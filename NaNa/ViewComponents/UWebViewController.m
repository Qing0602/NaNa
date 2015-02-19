//
//  UWebViewController.m
//  NaNa
//
//  Created by shenran on 11/3/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "UWebViewController.h"
#import "AppDelegate.h"
@interface UWebViewController ()

@end

@implementation UWebViewController
@synthesize URL=_URL;
@synthesize TITLE=_TITLE;

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
    _myWebView.delegate = self;
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
    self.title = _TITLE;
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
    [self.defaultView addSubview:_myWebView];
    _myWebView.scalesPageToFit = YES;
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        _activityView.center = _myWebView.center;
    }
    [_myWebView addSubview:_activityView];
    
    
    if(_URL!=nil)
    {
        [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL]]];
    }
    
}
#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    //    UINavigationController *navController = (UINavigationController *)APP_DELEGATE.rootViewController.centerViewController;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemPressed:(UIButton *)btn {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (webView != _myWebView) { return YES; }
    NSString* rurl=[[request URL] absoluteString];
    NSRange containStrRange = [rurl rangeOfString:@"?code=" options:NSCaseInsensitiveSearch];
    if (containStrRange.length > 0) {
        //有当前关键字结果
        NSURL *url = [NSURL URLWithString:rurl];
        NSURLRequest *neededRequest = [NSURLRequest requestWithURL: url];
        NSHTTPURLResponse *response;
        [NSURLConnection sendSynchronousRequest: neededRequest returningResponse: &response error: nil];
        if ([response respondsToSelector:@selector(allHeaderFields)]) {
            NSDictionary *dictionary = [response allHeaderFields];
            //NSString *userID = [dictionary objectForKey:@"user_id"];
#warning 登录成功后缓存数据
            [APP_DELEGATE loadMainView];
        }
    }
    if ([rurl hasPrefix:@"pageTo://"]) {
        //如果是自己定义的协议, 再截取协议中的方法和参数, 判断无误后在这里手动调用oc方法
        UWebViewController *controller = [[[UWebViewController alloc] init] autorelease];
        controller.URL=[NSString stringWithFormat:@"%@%@",@"http",[rurl substringFromIndex:6]];
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
        
    }
    return YES;
}


- (UIView * )viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return  nil;
}



#pragma mark - WebView
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(_TITLE==nil)
        self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [_activityView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_activityView stopAnimating];
}

- (void) dealloc{
    _myWebView.delegate = nil;
    [super dealloc];
}

@end
