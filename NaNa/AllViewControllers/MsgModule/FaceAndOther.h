//
//  FaceAndOther.h
//  NaNa
//
//  Created by ubox  on 14-1-15.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FaceType,
    OtherType
}FaceAndOtherType;

typedef enum {
    OptionsPhoth,
    OptionsPhotograph,
    OptionsGift,
    OptionsOnThings,
    OptionsKey
}OtherActionOptions;

@protocol FaceAndOtherDelegate <NSObject>

@optional

- (void)didSelectSendMessage;

- (void)didSelectFace:(NSString *)face;

- (void)didSelectDelete;

- (void)didSelectOtherOption:(OtherActionOptions )option;
@end



@interface FaceAndOther : UIView<UIScrollViewDelegate>
{
    UIScrollView  *_scrollView;
    UIView        *_otherView;
    UIView        *_faceView;
    UIPageControl *_pageControl;
    NSMutableArray*_phraseArray;
}

@property (nonatomic,assign)id <FaceAndOtherDelegate> delegate;
@property (nonatomic,assign)FaceAndOtherType viewType;
- (void)showFaceAndeOther:(FaceAndOtherType)type animation:(BOOL)animation;

@end
