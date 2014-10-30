//
//  photoDetailManagementVC.m
//  NaNa
//
//  Created by ZhangQing on 14-8-4.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "photoDetailManagementVC.h"
#import "NaNaUIManagement.h"
#import "UAlertView.h"
@interface photoDetailManagementVC ()<UIScrollViewDelegate>
@property (nonatomic, strong)PhotosModel *photoModel;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)EGOImageView *imageview;
@end

@implementation photoDetailManagementVC
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"removeUserPhotoDic"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].removeUserPhotoDic];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            [UAlertView showAlertViewWithMessage:@"删除成功" delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [UAlertView showAlertViewWithMessage:@"删除失败" delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        }
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(id)initWithModel:(PhotosModel *)model andIsMyPhoto:(BOOL)isMine;
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.photoModel = model;
        _isMyPhoto = isMine;

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    if (_isMyPhoto) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(CGRectGetWidth(self.navBarView.frame) - 60, 7, 60, 30);
        [btn setTitle:@"修改" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(imageAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarView addSubview:btn];
    }

//
    self.imageview = [[EGOImageView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.navBarView.frame), 320.f, ScreenHeight-CGRectGetHeight(self.navBarView.frame))];
    self.imageview.delegate = self;
    [self.imageview setImageURL:[NSURL URLWithString:self.photoModel.imagePath]];
    [self.view addSubview:self.imageview];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, self.screenHeight - 64.0f)];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(320.0f, self.screenHeight - 64.0f);
    [self.view addSubview:self.scrollView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)imageAction
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
    [action showInView:self.view];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"removeUserPhotoDic" options:0 context:nil];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"removeUserPhotoDic"];
    
}
#pragma mark ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [[NaNaUIManagement sharedInstance] removeUserPhoto:[self.photoModel.imageID intValue]];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - EGOImageview
-(void)imageViewLoadedImage:(EGOImageView *)imageView{
    CGSize imageSize = CGSizeMake(imageView.image.size.width/2, imageView.image.size.height/2);
    [self.imageview setFrame:CGRectMake((320-imageSize.width)/2, (self.screenHeight - 64.0f - imageSize.height)/2, imageSize.width, imageSize.height)];
    [self.scrollView addSubview:imageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    self.imageview.center = CGPointMake(self.scrollView.contentSize.width /2, self.scrollView.contentSize.height/2);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
