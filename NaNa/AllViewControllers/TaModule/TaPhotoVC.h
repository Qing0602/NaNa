//
//  TaPhotoVC.h
//  NaNa
//
//  Created by ubox  on 14-2-20.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "UBasicViewController.h"
#import "KKGridView.h"
#import "EGOImageLoader.h"
@interface TaPhotoVC : UBasicViewController<KKGridViewDataSource,KKGridViewDelegate,EGOImageLoaderObserver>
{
    KKGridView *_gridView;
    NSMutableArray  *_photosArray;
}
-(id)initWithUserID:(NSInteger)userID;
@end


@interface PhotoCell : KKGridViewCell

@end