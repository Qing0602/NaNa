//
//  MyPageVC.m
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "TaPageVC.h"
#import "UpdateMemberVC.h"
#import "TaLikeVC.h"
#import "ChatVC.h"
#import "TaInfoVC.h"
#import "UTabbar.h"
#import "TaPhotoVC.h"
#import "NaNaUserProfileModel.h"

@implementation TaPageVC


- (id)initWithURL:(NSString *)taURL {
    if (self = [super init]) {
        _url = [[NSURL alloc] initWithString:taURL];
        NSRange range = [taURL rangeOfString:@"targetId="];
        targetID = [[taURL substringFromIndex:range.location+range.length] integerValue];
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    // title
    self.title = @"她的空间";
    
    _taNickName = @"";
    
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
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
    [self.defaultView addSubview:_myWebView];
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        _activityView.center = _myWebView.center;
    }
    [_myWebView addSubview:_activityView];
    _myWebView.scalesPageToFit = YES;
    [_myWebView loadRequest:[NSURLRequest requestWithURL:_url]];
    
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"相册",@"资料",@"互动",@"聊天", nil];
    NSArray *normalArray = [NSArray arrayWithObjects:@"tabbar_album_normal.png",@"tabbar_info_normal.png",@"tabbar_private_normal.png",@"tabbar_member_normal.png", nil];
    NSArray *selectArray = [NSArray arrayWithObjects:@"tabbar_album_pressed.png",@"tabbar_info_pressed.png",@"tabbar_private_pressed.png",@"tabbar_member_pressed.png", nil];
    
    UTabbar *tab = [[UTabbar alloc] initWithTitleArray:titleArray imageArray:normalArray selectImageArray:selectArray];
    tab.frame = CGRectMake(0, CGRectGetMaxY(_myWebView.frame), 320, 50);
    [_defaultView addSubview:tab];
    [tab setDidSelectTabBlock:^(NSInteger index){
        [self selectTabbar:index];
    }];
    [tab release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    SAFERELEASE(_myWebView)
    SAFERELEASE(_activityView)
    SAFERELEASE(_url)
    [super dealloc];
}

#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITabBarDelegate
- (void)selectTabbar:(NSInteger)index {
    switch (index) {
        case TaPageTabItemAlbum: {
            ULog(@"TaPageTabItemAlbum");
            TaPhotoVC *infoVC = [[TaPhotoVC alloc] initWithUserID:targetID];
            [self.navigationController pushViewController:infoVC animated:YES];
            [infoVC release];
            break;
        }
        case TaPageTabItemInfo: {
            ULog(@"TaPageTabItemInfo");
            TaInfoVC *infoVC = [[TaInfoVC alloc] initWithUserID:targetID];
            [self.navigationController pushViewController:infoVC animated:YES];
            [infoVC release];
            break;
        }
        case TaPageTabItemLike: {
            ULog(@"TaPageTabItemLike");
            TaLikeVC *taLikeVC  =[[TaLikeVC alloc] initWithUserID:targetID];
            [self.navigationController pushViewController:taLikeVC animated:YES];
            [taLikeVC release];
            break;
        }
        case TaPageTabItemChat: {
            // ULog(@"TaPageTabItemChat");
            NaNaUserProfileModel *model = [[[NaNaUserProfileModel alloc] init] autorelease];
            model.userID = targetID;
            model.userNickName = _taNickName;
            ChatVC *chatVC  =[[ChatVC alloc] initChatVC:model];
            [self.navigationController pushViewController:chatVC animated:YES];
            [chatVC release];
            break;
        }
    }
    // 移除左右菜单栏
    [self removeSideMenuController];
}

#pragma mark - WebView
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_activityView stopAnimating];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

        NSURL *reqUrl = [request URL];
        NSString *curUrl= [reqUrl absoluteString];
        NSURL *url = [NSURL URLWithString:curUrl];
        NSURLRequest *neededRequest = [NSURLRequest requestWithURL: url];
        NSHTTPURLResponse *response;
        [NSURLConnection sendSynchronousRequest: neededRequest returningResponse: &response error: nil];
        if ([response respondsToSelector:@selector(allHeaderFields)]) {
            NSDictionary *dictionary = [response allHeaderFields];
            NSLog(@"%@",dictionary);
            NSString *tempNickName = dictionary[@"nickname"];
            if (![tempNickName isEqualToString:@""]) {
                _taNickName = tempNickName;
            }
            
        }



    return YES;
}
- (UIView * )viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return  nil;
}
@end
