//
//  photoDetailManagementVC.h
//  NaNa
//
//  Created by ZhangQing on 14-8-4.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "UBasicViewController.h"
#import "PhotosModel.h"
#import "EGOImageView.h"
@interface photoDetailManagementVC : UBasicViewController <UIActionSheetDelegate,EGOImageViewDelegate>

-(id)initWithModel:(PhotosModel *)model;

@end
