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
#import "PhotoMenuView.h"
#import "MyGiftListViewController.h"
#import "NaNaUIManagement.h"
#import "NaNaUserAccountModel.h"

@interface MyPageVC ()<UIGestureRecognizerDelegate,PhotoMenuDelegate,HeadCartoonDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    PhotoMenuView *_photoMenuView;
    CGRect              _photoMenuHideRect;     // 头像Menu不显示时的位置
    CGRect              _photoMenuShowRect;     // 头像Menu显示时的位置
}
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
    NSString *p =[NSString stringWithFormat:@"userId=%d",[NaNaUIManagement sharedInstance].userAccount.UserID];
    [_myWebView loadRequest:URLREQUEST(K_WEBVIEW_URL_MY_PAGE,p)];
    //[_myWebView loadRequest:URLREQUEST(@"/wblogin/index.php",@"")];
    [self addTapOnWebView];
    
    
    if (!_photoMenuView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoMenuView" owner:self options:nil];
        _photoMenuView = [[nib lastObject] retain];
        
        _photoMenuHideRect = CGRectMake(0.0,
                                        self.view.frame.size.height,
                                        self.view.frame.size.width,
                                        _photoMenuView.frame.size.height);
        _photoMenuShowRect = CGRectMake(0.0,
                                        self.view.frame.size.height - _photoMenuView.frame.size.height,
                                        _photoMenuView.frame.size.width,
                                        _photoMenuView.frame.size.height);
        _photoMenuView.frame = _photoMenuHideRect;
        _photoMenuView.photoMenuDelegate = self;
    }
    [self.view addSubview:_photoMenuView];
    
    
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
            InfoEditVC *controller = [[[InfoEditVC alloc] initWithType:TYPE_NORMAL] autorelease];
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
#pragma mark - HeadCartoonDelegate

- (void)albumButtonPressed:(UIButton *)btn {
    
    
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuHideRect;
                     }
                     completion:^(BOOL finished) {
                         _defaultView.userInteractionEnabled = YES;
                         
                         if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                             
                             UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                             picker.delegate = self;
                             picker.allowsEditing = YES;
                             picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                             [self presentViewController:picker animated:YES completion:nil];
                             
                             [picker release];
                         }
                     }];
}

- (void)photoButtonPressed:(UIButton *)btn {
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuHideRect;
                     }
                     completion:^(BOOL finished) {
                         _defaultView.userInteractionEnabled = YES;
                         
                         if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                             
                             UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                             picker.delegate = self;
                             picker.allowsEditing = YES;
                             picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                             [self presentViewController:picker animated:YES completion:nil];
                             [picker release];
                         }
                     }];
}

- (void)cartoonButtonPressed:(UIButton *)btn {
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuHideRect;
                     }
                     completion:^(BOOL finished) {
                         _defaultView.userInteractionEnabled = YES;
                         
                         HeadCartoonVC *controller = [[HeadCartoonVC alloc] init];
                         controller.headCartoonDelegate = self;
                         [self.navigationController pushViewController:controller animated:YES];
                         [controller release];
                     }];
}

- (void)cancelButtonPressed:(UIButton *)btn {
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuHideRect;
                     }
                     completion:^(BOOL finished) {
                         _defaultView.userInteractionEnabled = YES;
                     }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    //[_headButton setBackgroundImage:image forState:UIControlStateNormal];
    [[NaNaUIManagement sharedInstance] uploadFile:UIImageJPEGRepresentation(image, 0.5f) withUploadType:UploadAvatar withUserID:[NaNaUIManagement sharedInstance].userAccount.UserID withDesc:@""];
    [picker dismissModalViewControllerAnimated:YES];
    
    [_myWebView reload];
}
- (void)currentHeadImage:(NSString *)headName {
    [[NaNaUIManagement sharedInstance] uploadFile:UIImageJPEGRepresentation([UIImage imageNamed:headName], 1.f) withUploadType:UploadAvatar withUserID:[NaNaUIManagement sharedInstance].userAccount.UserID withDesc:@""];
    
}
#pragma mark- TapGestureRecognizer
-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_myWebView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:_myWebView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x*2, pt.y*2];
    NSString *urlToSave = [_myWebView stringByEvaluatingJavaScriptFromString:imgURL];
    NSLog(@"image url=%@", urlToSave);
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", pt.x*2, pt.y*2];
    NSString *jsClass = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).className", pt.x*2, pt.y*2];
    NSString * tagName = [_myWebView stringByEvaluatingJavaScriptFromString:js];
    NSString *className = [_myWebView stringByEvaluatingJavaScriptFromString:jsClass];
    if ([tagName isEqualToString:@"IMG"] && [className isEqualToString:@"avatar"]) {
        //点击头像
        [UIView animateWithDuration:default_duration
                         animations:^{
                             _photoMenuView.frame = _photoMenuShowRect;
                         }];
    }else if ([tagName isEqualToString:@"IMG"] && [className isEqualToString:@"option-lit"])
    {
        NSLog(@"%@",_myWebView.request.URL);
    }else if ([tagName isEqualToString:@"IMG"] && [className isEqualToString:@"single_gift"])
    {
        MyGiftListViewController *giftList = [[MyGiftListViewController  alloc] init];
        [self.navigationController pushViewController:giftList animated:YES];
        [giftList release];
    }
    //    if (urlToSave.length > 0) {
    //        [self showImageURL:urlToSave point:pt];
    //    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
