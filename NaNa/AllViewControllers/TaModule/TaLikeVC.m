//
//  TaLikeVC.m
//  NaNa
//
//  Created by dengfang on 14-1-16.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "TaLikeVC.h"

@interface TaLikeVC ()

@end

@implementation TaLikeVC


- (void)loadView {
    [super loadView];
    // title
    self.title = STRING(@"like");
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
        _myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    [self.defaultView addSubview:_myWebView];
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        _activityView.center = _myWebView.center;
    }
    [_myWebView addSubview:_activityView];
    _myWebView.scalesPageToFit = YES;
    [_myWebView loadRequest:URLREQUEST(K_WEBVIEW_URL_LOVE,@"userId=5")];
    
    
//    // content
//    UIImageView *bg = [[UIImageView alloc] init];
//    bg.frame = CGRectMake(_defaultView.frame.origin.x + 15, 15,
//                          _defaultView.frame.size.width - 30, _defaultView.frame.size.height - 30);
//    bg.image = [[UIImage imageNamed:@"bg_white.png"] stretchableImageWithLeftCapWidth:17.0 topCapHeight:17.0];
//    [_defaultView addSubview:bg];
//    
//    // 间隔距离
//    float offsetX = bg.frame.origin.x + 10;
//    float offsetY = 45.0;
//    float offsetW = bg.frame.size.width - 20;
//    float offsetH = 50.0;
//    
//    // 发密钥
//    UIButton *sendKeyBtn = [[UIButton alloc] init];
//    sendKeyBtn.frame = CGRectMake(offsetX, 90.0, offsetW, offsetH);
//    [sendKeyBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_normal.png"] forState:UIControlStateNormal];
//    [sendKeyBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_pressed.png"] forState:UIControlStateHighlighted];
//    [sendKeyBtn setTitle:STRING(@"send_key") forState:UIControlStateNormal];
//    [sendKeyBtn setTitleColor:default_color_deep_dark forState:UIControlStateNormal];
//    sendKeyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_18];
//    [sendKeyBtn addTarget:self action:@selector(sendKey:) forControlEvents:UIControlEventTouchUpInside];
//    [_defaultView addSubview:sendKeyBtn];
//    
//    // 摸摸头
//    UIButton *touchHeadBtn = [[UIButton alloc] init];
//    touchHeadBtn.frame = CGRectMake(offsetX, sendKeyBtn.frame.origin.y + sendKeyBtn.frame.size.height + offsetY, offsetW, offsetH);
//    [touchHeadBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_normal.png"] forState:UIControlStateNormal];
//    [touchHeadBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_pressed.png"] forState:UIControlStateHighlighted];
//    [touchHeadBtn setTitle:STRING(@"touch_head") forState:UIControlStateNormal];
//    [touchHeadBtn setTitleColor:default_color_deep_dark forState:UIControlStateNormal];
//    touchHeadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_18];
//    [touchHeadBtn addTarget:self action:@selector(touchHead:) forControlEvents:UIControlEventTouchUpInside];
//    [_defaultView addSubview:touchHeadBtn];
//    
//    // 送礼物
//    UIButton *sendGiftBtn = [[UIButton alloc] init];
//    sendGiftBtn.frame = CGRectMake(offsetX, touchHeadBtn.frame.origin.y + touchHeadBtn.frame.size.height + offsetY, offsetW, offsetH);
//    [sendGiftBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_normal.png"] forState:UIControlStateNormal];
//    [sendGiftBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_pressed.png"] forState:UIControlStateHighlighted];
//    [sendGiftBtn setTitle:STRING(@"send_gift") forState:UIControlStateNormal];
//    [sendGiftBtn setTitleColor:default_color_deep_dark forState:UIControlStateNormal];
//    sendGiftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_18];
//    [sendGiftBtn addTarget:self action:@selector(sendGift:) forControlEvents:UIControlEventTouchUpInside];
//    [_defaultView addSubview:sendGiftBtn];
//    
//    // 关注ta
//    UIButton *attentionTaBtn = [[UIButton alloc] init];
//    attentionTaBtn.frame = CGRectMake(offsetX, sendGiftBtn.frame.origin.y + sendGiftBtn.frame.size.height + offsetY, offsetW, offsetH);
//    [attentionTaBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_normal.png"] forState:UIControlStateNormal];
//    [attentionTaBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_pressed.png"] forState:UIControlStateHighlighted];
//    [attentionTaBtn setTitle:STRING(@"attention_ta") forState:UIControlStateNormal];
//    [attentionTaBtn setTitleColor:default_color_deep_dark forState:UIControlStateNormal];
//    attentionTaBtn.titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_18];
//    [attentionTaBtn addTarget:self action:@selector(attentionTa:) forControlEvents:UIControlEventTouchUpInside];
//    [_defaultView addSubview:attentionTaBtn];
//    
//    
//    // 内存管理
//    [bg release];
//    [sendKeyBtn release];
//    [touchHeadBtn release];
//    [sendGiftBtn release];
//    [attentionTaBtn release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}


#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendKey:(UIButton *)btn {
    ULog(@"sendKey");
}

- (void)touchHead:(UIButton *)btn {
    ULog(@"touchHead");
}

- (void)sendGift:(UIButton *)btn {
    ULog(@"sendGift");
}

- (void)attentionTa:(UIButton *)btn {
    ULog(@"attentionTa");
}
@end
