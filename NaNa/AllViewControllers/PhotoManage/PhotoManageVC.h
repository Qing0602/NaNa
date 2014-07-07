//
//  PhotoManageVC.h
//  NaNa
//
//  Created by shenran on 12/8/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "UWebViewController.h"
#import "KKGridView.h"
#import "PhotoMenuView.h"
@interface PhotoManageVC : UWebViewController<KKGridViewDataSource,KKGridViewDelegate,PhotoMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    KKGridView          *_gridView;
    PhotoMenuView       *_photoMenuView;        // 修改头像的菜单视图
    CGRect              _photoMenuHideRect;     // 头像Menu不显示时的位置
    CGRect              _photoMenuShowRect;     // 头像Menu显示时的位置
    NSMutableArray      *_photosArray;
    
}
@property (nonatomic,retain) NSString *completeImageDes;
@property (nonatomic,retain) UIImage  *chooseImage;

@end
@interface MyPhotoCell : KKGridViewCell

@end