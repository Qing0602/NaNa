//
//  PhotoManageVC.m
//  NaNa
//
//  Created by shenran on 12/8/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "PhotoManageVC.h"
#import "ChoosePhotoDetailVC.h"
#import "PhotosModel.h"
@interface PhotoManageVC ()

@end

@implementation PhotoManageVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView {
    [super loadView];
    
    
    
    _URL = K_WEBVIEW_URL_MY_BLACK_LIST;
    _TITLE = @"相册管理";
    _photosArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 29; i++)
    {

        UIImage *image = [UIImage imageNamed:@"key_pressed.png"];
        NSString *imageDes = [NSString stringWithFormat:@"后海游玩%d张照片",i];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",imageDes,@"imageDes", nil];
        [_photosArray addObject:dic];
    }
    
    
//    self.title = STRING(@"private");
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    _gridView = [[KKGridView alloc] initWithFrame:_defaultView.bounds];
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.cellSize = CGSizeMake(100, 120);
    _gridView.cellPadding = CGSizeMake(5, 5);
    _gridView.delegate = self;
    _gridView.dataSource = self;
    [_defaultView addSubview:_gridView];
    
    // 修改头像的菜单视图
    if (!_photoMenuView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoMenuView" owner:self options:nil];
        _photoMenuView = [[nib lastObject] retain];
        
        _photoMenuHideRect = CGRectMake(0.0,
                                        CGRectGetHeight(_defaultView.frame),
                                        self.view.frame.size.width,
                                        _photoMenuView.frame.size.height);
        _photoMenuShowRect = CGRectMake(0.0,
                                        CGRectGetHeight(_defaultView.frame) - _photoMenuView.frame.size.height,
                                        _photoMenuView.frame.size.width,
                                        _photoMenuView.frame.size.height);
        _photoMenuView.frame = _photoMenuHideRect;
        _photoMenuView.cameraBtn.frame = _photoMenuView.cartoonBtn.frame;
        _photoMenuView.cartoonBtn.hidden = YES;
        _photoMenuView.photoMenuDelegate = self;
    }
    [_defaultView addSubview:_photoMenuView];
 
    

}
#pragma mark - HeadCartoonDelegate

- (void)albumButtonPressed:(UIButton *)btn {
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuHideRect;
                     }
                     completion:^(BOOL finished) {
                         _gridView.userInteractionEnabled = YES;
                         
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
                         _gridView.userInteractionEnabled = YES;
                         
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
                         _gridView.userInteractionEnabled = YES;
                     }];
}

- (void)cancelButtonPressed:(UIButton *)btn {
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuHideRect;
                     }
                     completion:^(BOOL finished) {
                         _gridView.userInteractionEnabled = YES;
                     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    [[NaNaUIManagement sharedInstance] uploadFile:UIImageJPEGRepresentation(image, 1.f) withUploadType:UploadPhoto withUserID:[self getAccountValueByKey:ACCOUNT_INFO_TYPE_USERID] withDesc:@""];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    [self performSelector:@selector(goChooseVC:) withObject:image afterDelay:0.5];
    
}

- (void)goChooseVC:(UIImage *)image
{
    ChoosePhotoDetailVC *chooseVC = [[ChoosePhotoDetailVC alloc] init];
    chooseVC.chooseImage = image;
    self.chooseImage = image;
    [chooseVC setChoosedImageBlock:^(NSString *imageDes){
        self.completeImageDes = imageDes;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",imageDes,@"imageDes", nil];
        [_photosArray insertObject:dic atIndex:0];
        [_gridView reloadData];
        
    }];
    [self.navigationController pushViewController:chooseVC animated:YES];
    [chooseVC release];
}

- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section
{
    return [_photosArray count];
}

- (KKGridViewCell *)gridView:(KKGridView *)gridView cellForItemAtIndexPath:(KKIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    MyPhotoCell *cell = (MyPhotoCell *)[gridView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[MyPhotoCell alloc] initWithFrame:CGRectMake(0, 0, 100, 120) reuseIdentifier:identifier] autorelease];
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:0xfd0];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:0xfd1];
    UILabel *addLabel = (UILabel *)[cell.contentView viewWithTag:0xfd2];
    if (indexPath.index == 0) {
        cell.contentView.layer.borderWidth = 5;
        cell.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        image.hidden = YES;
        label.hidden = YES;
       
        if (!addLabel) {
            addLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 60)] autorelease];
            addLabel.text = @"+";
            addLabel.font = [UIFont boldSystemFontOfSize:80];
            addLabel.textAlignment = NSTextAlignmentCenter;
            addLabel.textColor = [UIColor whiteColor];
            addLabel.backgroundColor = [UIColor clearColor];
            addLabel.tag = 0xfd2;
            [cell.contentView addSubview:addLabel];
        }
         addLabel.hidden = NO;
    }
    else
    {
        image.hidden = NO;
        label.hidden = NO;
        addLabel.hidden = YES;
        cell.contentView.layer.borderWidth = 0;
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        NSInteger index = indexPath.index - 1;
        NSDictionary *dic = [_photosArray objectAtIndex:index];
        if (!image) {
            image = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
            image.tag = 0xfd0;
            [cell.contentView addSubview:image];
        }
        image.image = [dic objectForKey:@"image"];
        
        
        if (!label) {
            label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 20)] autorelease];
            label.tag =  0xfd1;
            label.font = [UIFont systemFontOfSize:12];
            label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
        }
        [cell.contentView addSubview:label];
//        label.text = [NSString stringWithFormat:@"你好,这是第%d照片",indexPath.index];
        label.text = [dic objectForKey:@"imageDes"];
    }
    return cell;
}

- (void)gridView:(KKGridView *)gridView didSelectItemAtIndexPath:(KKIndexPath *)indexPath
{
    [gridView deselectAll:YES];
    if (indexPath.index == 0) {
        _gridView.userInteractionEnabled = NO;
        [UIView animateWithDuration:default_duration
                         animations:^{
                             _photoMenuView.frame = _photoMenuShowRect;
                         }];
    }
}

- (void)dealloc {
    [super dealloc];
}

@end

@implementation MyPhotoCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self bringSubviewToFront:self.contentView];
}

- (void)dealloc
{
    [super dealloc];
}
@end