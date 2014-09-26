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
#import "photoDetailManagementVC.h"
@interface PhotoManageVC ()

@end

@implementation PhotoManageVC
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userPhotoesList"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].userPhotoesList];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            [_photosArray removeAllObjects];
            for (NSDictionary *info in tempData[ASI_REQUEST_DATA]) {
                PhotosModel *model = [[PhotosModel alloc] init];
                model.imageDes = info[@"description"];
                model.imagePath = info[@"imageurl"];
                model.imageID = info[@"id"];
                NSURL *imageUrl = [NSURL URLWithString:info[@"imageurl"]];
                if (![[EGOImageLoader sharedImageLoader] hasLoadedImageURL:imageUrl] && ![[EGOImageLoader sharedImageLoader] isLoadingImageURL:imageUrl]) {
                    [[EGOImageLoader sharedImageLoader] loadImageForURL:imageUrl observer:self];
                }
                [_photosArray addObject:model];
            }
            
            [_gridView reloadData];
        }else
        {
            
        }
    }else if ([keyPath isEqualToString:@"uploadResult"])
    {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].uploadResult];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            [[NaNaUIManagement sharedInstance] getuserPhotoesList:[NaNaUIManagement sharedInstance].userAccount.UserID];
        }else
        {
            
        }
        NSLog(@"tempData==%@",tempData);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView {
    [super loadView];
    
    
    
    _URL = K_WEBVIEW_URL_MY_BLACK_LIST;
    _TITLE = @"相册管理";
    _photosArray = [[NSMutableArray alloc] init];
    
//    for (int i = 0; i < 29; i++)
//    {
//
//        UIImage *image = [UIImage imageNamed:@"key_pressed.png"];
//        NSString *imageDes = [NSString stringWithFormat:@"后海游玩%d张照片",i];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",imageDes,@"imageDes", nil];
//        [_photosArray addObject:dic];
//    }
    
    
//    self.title = STRING(@"private");
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    _gridView = [[KKGridView alloc] initWithFrame:_defaultView.bounds];
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.cellSize = CGSizeMake(104, 104);
    _gridView.cellPadding = CGSizeMake(2, 2);
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
-(void)viewWillAppear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"userPhotoesList" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"updateUserPushSetting" options:0 context:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"userPhotoesList"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"updateUserPushSetting"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] getuserPhotoesList:[NaNaUIManagement sharedInstance].userAccount.UserID];
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
        
        //[[NaNaUIManagement sharedInstance] uploadFile:UIImageJPEGRepresentation(image, 1.f) withUploadType:UploadPhoto withUserID:[NaNaUIManagement sharedInstance].userAccount.UserID withDesc:imageDes];
        [[NaNaUIManagement sharedInstance] uploadFile:UIImageJPEGRepresentation(image, 1.f) withUploadType:UploadPhoto withUserID:[NaNaUIManagement sharedInstance].userAccount.UserID withDesc:imageDes withVoiceTime:0];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",imageDes,@"imageDes", nil];
//        [_photosArray insertObject:dic atIndex:0];
//        [_gridView reloadData];
        
    }];
    [self.navigationController pushViewController:chooseVC animated:YES];
    [chooseVC release];
}

- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section
{
    return [_photosArray count]+1;
}

- (KKGridViewCell *)gridView:(KKGridView *)gridView cellForItemAtIndexPath:(KKIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    MyPhotoCell *cell = (MyPhotoCell *)[gridView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[MyPhotoCell alloc] initWithFrame:CGRectMake(0, 0, 104, 104) reuseIdentifier:identifier] autorelease];
    }
    
    //cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:0xfd0];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:0xfd1];
    UILabel *addLabel = (UILabel *)[cell.contentView viewWithTag:0xfd2];
    if (indexPath.index == 0) {
        cell.contentView.backgroundColor = [UIColor blackColor];
        
        cell.contentView.layer.borderWidth = 5;
        cell.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        image.hidden = YES;
        label.hidden = YES;
       
        if (!addLabel) {
            addLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 30, 100, 40)] autorelease];
            addLabel.text = @"+";
            addLabel.font = [UIFont boldSystemFontOfSize:40];
            addLabel.textAlignment = NSTextAlignmentCenter;
            addLabel.textColor = [UIColor lightGrayColor];
            addLabel.backgroundColor = [UIColor clearColor];
            addLabel.tag = 0xfd2;
            [cell.contentView addSubview:addLabel];
        }
         addLabel.hidden = NO;
    }
    else
    {
        PhotosModel *model = [_photosArray objectAtIndex:indexPath.index-1];
        
        image.hidden = NO;
        label.hidden = NO;
        addLabel.hidden = YES;
        cell.contentView.layer.borderWidth = 0;
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        //NSInteger index = indexPath.index - 1;
        //NSDictionary *dic = [_photosArray objectAtIndex:index];
        if (!image) {
            image = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
            image.tag = 0xfd0;
            [cell.contentView addSubview:image];
        }
        UIImage *tempImage = [[EGOImageLoader sharedImageLoader] imageForURL:[NSURL URLWithString:model.imagePath] shouldLoadWithObserver:self];
        if (!tempImage) {
            
        }else
        {
            image.image = tempImage;
        }
        
        //SAFERELEASE(tempImage);
        
        if (!label) {
            label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 80, 100, 20)] autorelease];
            label.tag =  0xfd1;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            //label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
            label.backgroundColor = [UIColor blackColor];
            label.textColor = [UIColor whiteColor];
        }
        [cell.contentView addSubview:label];
//        label.text = [NSString stringWithFormat:@"你好,这是第%d照片",indexPath.index];
        label.text = model.imageDes;
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
    }else
    {
        PhotosModel *model = [_photosArray objectAtIndex:indexPath.index-1];
        photoDetailManagementVC *photoDetail = [[photoDetailManagementVC alloc] initWithModel:model andIsMyPhoto:YES];
        [self.navigationController pushViewController:photoDetail animated:YES];
        [photoDetail release];
    }
}
#pragma mark EgoDelegate
-(void)imageLoaderDidLoad:(NSNotification *)notification
{
    [_gridView reloadData];
}
- (void)dealloc {
    [super dealloc];
    [_photosArray release];
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