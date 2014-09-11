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
@interface photoDetailManagementVC ()
@property (nonatomic, strong)PhotosModel *photoModel;
@end

@implementation photoDetailManagementVC
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"removeUserPhotoDic"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].removeUserPhotoDic];
        if (![[tempData objectForKey:Http_Has_Error_Key] boolValue]) {
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
-(id)initWithModel:(PhotosModel *)model
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.photoModel = model;
        

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetWidth(self.navBarView.frame) - 60, 7, 60, 30);
    [btn setTitle:@"修改" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(imageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:btn];
//
    EGOImageView  *imageview = [[EGOImageView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.navBarView.frame), 320.f, ScreenHeight-CGRectGetHeight(self.navBarView.frame))];
    imageview.delegate = self;
    [imageview setImageURL:[NSURL URLWithString:self.photoModel.imagePath]];
    [self.view addSubview:imageview];
    
    
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
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
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
            [[NaNaUIManagement sharedInstance] initRemoveUserPhoto:[self.photoModel.imageID intValue]];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - EGOImageview
-(void)imageViewLoadedImage:(EGOImageView *)imageView
{
    CGSize imageSize = CGSizeMake(imageView.image.size.width/2, imageView.image.size.height/2);
    [imageView setFrame:CGRectMake((320-imageSize.width)/2, CGRectGetHeight(self.navBarView.frame)+(ScreenHeight-CGRectGetHeight(self.navBarView.frame)-imageSize.height)/2, imageSize.width, imageSize.height)];
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
