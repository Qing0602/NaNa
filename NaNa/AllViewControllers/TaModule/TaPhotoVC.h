//
//  TaPhotoVC.h
//  NaNa
//
//  Created by ubox  on 14-2-20.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "UBasicViewController.h"
#import "KKGridView.h"

@interface TaPhotoVC : UBasicViewController<KKGridViewDataSource,KKGridViewDelegate>
{
    KKGridView *_gridView;
}
@end


@interface PhotoCell : KKGridViewCell

@end