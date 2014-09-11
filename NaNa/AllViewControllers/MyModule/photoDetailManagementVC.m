//
//  photoDetailManagementVC.m
//  NaNa
//
//  Created by ZhangQing on 14-8-4.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "photoDetailManagementVC.h"

@interface photoDetailManagementVC ()
@property (nonatomic, strong)PhotosModel *photoModel;
@end

@implementation photoDetailManagementVC

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
//    EGOImageView  *imageview = [[EGOImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, ScreenHeight-44.f)];
//    imageview.delegate = self;
//    [imageview setImageURL:[NSURL URLWithString:self.photoModel.imagePath]];
//    [self.view addSubview:imageview];
    
    
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
#pragma mark ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - EGOImageview
-(void)imageViewLoadedImage:(EGOImageView *)imageView
{
    CGRect frame = imageView.frame;
    frame.origin = CGPointMake(0.f, ScreenHeight/2-frame.size.height/2);
    imageView.frame = frame;
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
