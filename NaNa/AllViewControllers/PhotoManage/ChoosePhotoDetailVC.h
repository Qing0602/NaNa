//
//  ChoosePhotoDetailVC.h
//  NaNa
//
//  Created by ubox  on 14-2-24.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "UBasicViewController.h"

typedef void(^backChooseImageBlock)(NSString *imageDes);

@interface ChoosePhotoDetailVC : UBasicViewController<UIScrollViewDelegate,UITextViewDelegate>
{
    UIScrollView *_scrollView;
    UITextView *_textView;
    BOOL _keyBoardIsShow;
}
@property (nonatomic,retain)UIImage *chooseImage;

@property (nonatomic,copy)backChooseImageBlock choosedImageBlock;

@end
