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
        
        [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(CGRectGetWidth(self.navBarView.frame) - 60, 7, 60, 30);
        [btn setTitle:@"修改" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(imageAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarView addSubview:btn];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.photoModel.imagePath]];
    CGRect frame = imageview.frame;
    frame.origin = CGPointMake(0.f, ScreenHeight/2-frame.size.height/2);
    imageview.frame = frame;
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
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照",@"删除", nil];
    [action showInView:self.view];
}
#pragma mark ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [UIView animateWithDuration:default_duration
                             animations:^{
                                 
                             }
                             completion:^(BOOL finished) {
                                 
                                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                                     
                                     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                     picker.delegate = self;
                                     picker.allowsEditing = YES;
                                     picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                     
                                     [self presentViewController:picker animated:YES completion:nil];
                                     

                                 }
                             }];
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:default_duration
                             animations:^{

                             }
                             completion:^(BOOL finished) {

                                 
                                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                     
                                     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                     picker.delegate = self;
                                     picker.allowsEditing = YES;
                                     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     [self presentViewController:picker animated:YES completion:nil];

                                 }
                             }];
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
    
    [picker dismissModalViewControllerAnimated:YES];
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
