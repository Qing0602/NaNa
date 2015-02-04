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
#import "MyBackgroundListViewController.h"
#import "UAlertView.h"
@interface MyPageVC ()<UIGestureRecognizerDelegate,PhotoMenuDelegate,HeadCartoonDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate>
{
    PhotoMenuView *_photoMenuView;
    CGRect              _photoMenuHideRect;     // 头像Menu不显示时的位置
    CGRect              _photoMenuShowRect;     // 头像Menu显示时的位置
    AVAudioPlayer *_audioPlayer;
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
        _photoMenuView = [nib lastObject];
        
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
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"uploadResult"];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_myWebView != nil) {
        [_myWebView reload];
    }
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"uploadResult" options:0 context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"uploadResult"])
    {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].uploadResult];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            //正确
            NSString  *avatarPath = tempData[ASI_REQUEST_DATA][@"avatar"];
            if (avatarPath.length > 0) {
                [NaNaUIManagement sharedInstance].userProfileCache.userAvatarURL = avatarPath;
            }
        }else
        {
            [UAlertView showAlertViewWithMessage:tempData[@"errorMessage"] delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        }
        
    }
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
            
            PhotoManageVC *controller = [[PhotoManageVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MyPageTabItemInfoEdit: {
            ULog(@"MyPageTabItemInfoEdit");
            InfoEditVC *controller = [[InfoEditVC alloc] initWithType:TYPE_NORMAL];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MyPageTabItemSetPrivate: {
            ULog(@"MyPageTabItemSetPrivate");
            SetPrivateVC *controller = [[SetPrivateVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MyPageTabItemUpdateMember: {
            ULog(@"MyPageTabItemUpdateMember");
            [UAlertView showAlertViewWithTitle:nil message:@"该服务即将上线" delegate:nil cancelButton:@"确定" defaultButton:nil];
            /*
            UpdateMemberVC *controller = [[UpdateMemberVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
             */
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
    [[NaNaUIManagement sharedInstance] uploadFile:UIImageJPEGRepresentation(image, 0.5f) withUploadType:UploadAvatar withUserID:[NaNaUIManagement sharedInstance].userAccount.UserID withDesc:@"" withVoiceTime:0];
    [picker dismissModalViewControllerAnimated:YES];
    
    [_myWebView reload];
}
- (void)currentHeadImage:(NSString *)headName {
        [[NaNaUIManagement sharedInstance] uploadFile:UIImageJPEGRepresentation([UIImage imageNamed:headName], 1.f) withUploadType:UploadAvatar withUserID:[NaNaUIManagement sharedInstance].userAccount.UserID withDesc:@"" withVoiceTime:0];
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
        MyBackgroundListViewController *backgroundList = [[MyBackgroundListViewController alloc] init];
        [self.navigationController pushViewController:backgroundList animated:YES];
    }else if ([tagName isEqualToString:@"IMG"] && [className isEqualToString:@"single_gift"])
    {
        MyGiftListViewController *giftList = [[MyGiftListViewController  alloc] init];
        [self.navigationController pushViewController:giftList animated:YES];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
 
    return YES;
}
#pragma mark - WebView
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url=[[request URL] absoluteString];
    if ([url rangeOfString:@"my-background" options:NSCaseInsensitiveSearch].length > 0) {
        return NO;
    }else if ([url rangeOfString:@"my-photos" options:NSCaseInsensitiveSearch].length > 0){
        PhotoManageVC *controller = [[PhotoManageVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
    }else if ([url rangeOfString:@"set_voice" options:NSCaseInsensitiveSearch].length > 0){
        InfoEditVC *controller = [[InfoEditVC alloc] initWithType:TYPE_NORMAL];
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
    }else if ([url rangeOfString:@"myvoice" options:NSCaseInsensitiveSearch].length > 0){
        InfoEditVC *controller = [[InfoEditVC alloc] initWithType:TYPE_NORMAL];
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
    }
    return YES;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

}

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
