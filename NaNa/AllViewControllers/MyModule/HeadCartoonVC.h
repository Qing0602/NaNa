//
//  HeadCartoonVC.h
//  NaNa
//
//  Created by dengfang on 13-8-18.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBasicViewController.h"
#import "KKGridView.h"

@protocol HeadCartoonDelegate <NSObject>
- (void)currentHeadImage:(NSString *)headName;
@end

@interface HeadCartoonVC : UBasicViewController <KKGridViewDataSource, KKGridViewDelegate> {
    KKGridView                  *_gridView;
    NSArray                     *_imageArray;
    id<HeadCartoonDelegate>     _headCartoonDelegate;
}

@property (nonatomic, assign) id<HeadCartoonDelegate> headCartoonDelegate;
@end
