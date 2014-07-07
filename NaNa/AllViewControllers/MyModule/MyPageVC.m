//
//  MyPageVC.m
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "MyPageVC.h"
#import "InfoEditVC.h"
#import "UpdateMemberVC.h"
#import "SetPrivateVC.h"
#import "PhotoManageVC.h"
#import "UTabbar.h"

@interface MyPageVC ()

@end

@implementation MyPageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setSideMenuController];
}

- (void)loadView {
    [super loadView];
    // title
    self.title = STRING(@"myPage");
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
    [self.defaultView addSubview:_myWebView];
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        _activityView.center = _myWebView.center;
    }
    [_myWebView addSubview:_activityView];
    _myWebView.scalesPageToFit = YES;
    [_myWebView loadRequest:URLREQUEST(K_WEBVIEW_URL_MY_PAGE,@"userId=5")];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"相册",@"资料",@"隐私",@"会员", nil];
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
    SAFERELEASE(_tabBar)
    [super dealloc];
}

#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)rightItemPressed:(UIButton *)btn {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

#pragma mark - UITabBarDelegate
- (void)selectTabbar:(NSInteger)index
{
    switch (index) {
        case MyPageTabItemAlbum: {
            ULog(@"MyPageTabItemAlbum");
            PhotoManageVC *controller = [[[PhotoManageVC alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MyPageTabItemInfoEdit: {
            ULog(@"MyPageTabItemInfoEdit");
            InfoEditVC *controller = [[[InfoEditVC alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MyPageTabItemSetPrivate: {
            ULog(@"MyPageTabItemSetPrivate");
            SetPrivateVC *controller = [[[SetPrivateVC alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MyPageTabItemUpdateMember: {
            ULog(@"MyPageTabItemUpdateMember");
            UpdateMemberVC *controller = [[[UpdateMemberVC alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
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

- (UIView * )viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return  nil;
}

@end
