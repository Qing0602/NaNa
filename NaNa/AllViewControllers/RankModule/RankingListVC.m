//
//  RankingListVC.m
//  NaNa
//
//  Created by dengfang on 13-7-2.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "RankingListVC.h"
#import "MenuLeftVC.h"
#import "AppDelegate.h"
#import "TTTAttributedLabel.h"
#import "TaPageVC.h"
#import "MyPageVC.h"

@implementation RankingListVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setSideMenuController];
}

- (void)loadView {
    [super loadView];
    [self setNavLeftType:UNavBarBtnTypeMenu navRightType:UNavBarBtnTypeTa];
    
    
    // ------------------------ button --------------------------
    _currentType = RankTypeNone;
    float tabX = _titleItem.frame.origin.x;
    float tabWidth = _titleItem.frame.size.width / 3;
    float tabHeight = _titleItem.frame.size.height;
    
    // 同城
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.frame = CGRectMake(tabX, 0, tabWidth, tabHeight);
        _leftButton.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
        [_leftButton setBackgroundColor:[UIColor clearColor]];
        [_leftButton setTitle:STRING(@"city") forState:UIControlStateNormal];
        [_leftButton addTarget:self
                        action:@selector(tabButtonClick:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    [_navBarView addSubview:_leftButton];
    
    // 周边
    if (!_centerButton) {
        _centerButton = [[UIButton alloc] init];
        _centerButton.frame = CGRectMake(tabX + tabWidth, 0, tabWidth, tabHeight);
        _centerButton.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
        [_centerButton setBackgroundColor:[UIColor clearColor]];
        [_centerButton setTitle:STRING(@"near") forState:UIControlStateNormal];
        [_centerButton addTarget:self
                          action:@selector(tabButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    [_navBarView addSubview:_centerButton];
    
    // 全部
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.frame = CGRectMake(tabX + tabWidth * 2, 0, tabWidth, tabHeight);
        _rightButton.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
        [_rightButton setBackgroundColor:[UIColor clearColor]];
        [_rightButton setTitle:STRING(@"all") forState:UIControlStateNormal];
        [_rightButton addTarget:self
                          action:@selector(tabButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    [_navBarView addSubview:_rightButton];
    
    
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.image = [UIImage imageNamed:@"category_focus_bg.png"];
    }
    [_navBarView addSubview:_lineImageView];
    
    // ------------------------ webview -------------------------
    // 同城
    if (!_leftWebview) {
        _leftWebview = [[UIWebView alloc] init];
        _leftWebview.frame = CGRectMake(0, 0, _defaultView.frame.size.width, _defaultView.frame.size.height);
        _leftWebview.backgroundColor = [UIColor clearColor];
        _leftWebview.delegate = self;
        _leftWebview.scalesPageToFit = YES;
    }
    
    // 周边
    if (!_centerWebview) {
        _centerWebview = [[UIWebView alloc] init];
        _centerWebview.frame = CGRectMake(0, 0, _defaultView.frame.size.width, _defaultView.frame.size.height);
        _centerWebview.backgroundColor = [UIColor clearColor];
        _centerWebview.delegate = self;
        _centerWebview.scalesPageToFit = YES;
    }
    
    // 全部
    if (!_rightWebview) {
        _rightWebview = [[UIWebView alloc] init];
        _rightWebview.frame = CGRectMake(0, 0, _defaultView.frame.size.width, _defaultView.frame.size.height);
        _rightWebview.backgroundColor = [UIColor clearColor];
        _rightWebview.delegate = self;
        _rightWebview.scalesPageToFit = YES;
    }
    
    // ActivityView
    if (!_leftActivityView) {
        _leftActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _leftActivityView.hidesWhenStopped = YES;
        _leftActivityView.center = _leftWebview.center;
    }
    [_leftWebview addSubview:_leftActivityView];
    
    if (!_centerActivityView) {
        _centerActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _centerActivityView.hidesWhenStopped = YES;
        _centerActivityView.center = _centerWebview.center;
    }
    [_centerWebview addSubview:_centerActivityView];
    
    if (!_rightActivityView) {
        _rightActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _rightActivityView.hidesWhenStopped = YES;
        _rightActivityView.center = _rightWebview.center;
    }
    [_rightWebview addSubview:_rightActivityView];
    
    // 选择
    [self tabButtonClick:_leftButton];
    
    
  
}

-(void) viewDidLoad{
    [[NaNaUIManagement sharedInstance] postPushToken:[UStaticData getObjectForKey:DEVICE_TOKEN]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    SAFERELEASE(_leftButton)
    SAFERELEASE(_centerButton)
    SAFERELEASE(_rightButton)
    
    SAFERELEASE(_leftWebview)
    SAFERELEASE(_centerWebview)
    SAFERELEASE(_rightWebview)
    
    SAFERELEASE(_leftActivityView)
    SAFERELEASE(_centerActivityView)
    SAFERELEASE(_rightActivityView)
    [super dealloc];
}

#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)rightItemPressed:(UIButton *)btn {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

// 同城 - 周边 - 全部
- (void)tabButtonClick:(UIButton *)btn {
    float lineX = _titleItem.frame.origin.x;
    float lineY = _titleItem.frame.size.height - 3;
    float lineWidth = _titleItem.frame.size.width / 3;
    float lineHeight = 3;
    
    // 同城
    if (btn == _leftButton) {
        if (_currentType == RankTypeCity) {
            return;
        }
        [_leftButton setTitleColor:default_color_cyan forState:UIControlStateNormal];
        [_centerButton setTitleColor:default_color_white forState:UIControlStateNormal];
        [_rightButton setTitleColor:default_color_white forState:UIControlStateNormal];
        if (_currentType == RankTypeCity) {
            [UIView animateWithDuration:default_duration
                             animations:^{
                                 _lineImageView.frame = CGRectMake(lineX, lineY, lineWidth, lineHeight);
                             }];
        } else {
            _lineImageView.frame = CGRectMake(lineX, lineY, lineWidth, lineHeight);
        }
        _currentType = RankTypeCity;
        
        [_defaultView addSubview:_leftWebview];
        [_centerWebview removeFromSuperview];
        [_rightWebview removeFromSuperview];
        NSString *temp = [NSString stringWithFormat:@"userId=%d",[NaNaUIManagement sharedInstance].userAccount.UserID];
        [_leftWebview loadRequest:URLREQUEST(K_WEBVIEW_URL_RANK_CITY,temp)];
        [_leftActivityView startAnimating];
    }
    // 周边
    else if (btn == _centerButton) {
        if (_currentType == RankTypeNear) {
            return;
        }
        _currentType = RankTypeNear;
        [_leftButton setTitleColor:default_color_white forState:UIControlStateNormal];
        [_centerButton setTitleColor:default_color_cyan forState:UIControlStateNormal];
        [_rightButton setTitleColor:default_color_white forState:UIControlStateNormal];
        [UIView animateWithDuration:default_duration
                         animations:^{
                             _lineImageView.frame = CGRectMake(lineX + lineWidth, lineY, lineWidth, lineHeight);
                         }];
        [_leftWebview removeFromSuperview];
        [_defaultView addSubview:_centerWebview];
        [_rightWebview removeFromSuperview];
        NSString *temp = [NSString stringWithFormat:@"userId=%d",[NaNaUIManagement sharedInstance].userAccount.UserID];
        [_centerWebview  loadRequest:URLREQUEST(K_WEBVIEW_URL_RANK_NEAR,temp)];
    }
    // 全部
    else {
        if (_currentType == RankTypeAll) {
            return;
        }
        _currentType = RankTypeAll;
        [_leftButton setTitleColor:default_color_white forState:UIControlStateNormal];
        [_centerButton setTitleColor:default_color_white forState:UIControlStateNormal];
        [_rightButton setTitleColor:default_color_cyan forState:UIControlStateNormal];
        [UIView animateWithDuration:default_duration
                         animations:^{
                             _lineImageView.frame = CGRectMake(lineX + lineWidth * 2, lineY, lineWidth, lineHeight);
                         }];
        [_leftWebview removeFromSuperview];
        [_centerWebview removeFromSuperview];
        [_defaultView addSubview:_rightWebview];
        NSString *temp = [NSString stringWithFormat:@"userId=%d",[NaNaUIManagement sharedInstance].userAccount.UserID];
        [_rightWebview loadRequest:URLREQUEST(K_WEBVIEW_URL_RANK_ALL,temp)];
    }
}

#pragma mark - WebView
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (webView == _leftWebview) {
        [_leftActivityView startAnimating];
        
    } else if (webView == _centerWebview) {
        [_centerActivityView startAnimating];
        
    } else if (webView == _rightWebview) {
        [_rightActivityView startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == _leftWebview) {
        [_leftActivityView stopAnimating];
        
    } else if (webView == _centerWebview) {
        [_centerActivityView stopAnimating];
        
    } else if (webView == _rightWebview) {
        [_rightActivityView stopAnimating];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView == _leftWebview) {
        [_leftActivityView stopAnimating];
        
    } else if (webView == _centerWebview) {
        [_centerActivityView stopAnimating];
        
    } else if (webView == _rightWebview) {
        [_rightActivityView stopAnimating];
    }
}

- (UIView * )viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return  nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [request.URL absoluteString];
    NSRange range = [url rangeOfString:@"/user/show"];
    if(range.location != NSNotFound) {
        
        NSString *temp = [url substringFromIndex:range.location + range.length + 1];
        NSDictionary *dic = [self dictionaryFromQuery:temp usingEncoding:NSUTF8StringEncoding];
        if ([dic[@"userId"] integerValue] == [dic[@"targetId"] integerValue]) {
            MyPageVC *controller = [[[MyPageVC alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            // 跳转新页面：TA
            TaPageVC *controller = [[[TaPageVC alloc] initWithURL:url] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        // 移除左右菜单栏
        [self removeSideMenuController];
        return NO;
    }
    return YES;
}

- (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[[NSScanner alloc] initWithString:query] autorelease];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}
@end
