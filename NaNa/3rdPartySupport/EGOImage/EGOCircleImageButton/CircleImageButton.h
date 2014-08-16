//
//  CircleImageButton.h
//  circleImageButton
//
//  Created by 王硕 on 13-5-12.
//  Copyright (c) 2013年 王硕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageLoader.h"

@protocol CircleImageButtonDelegate;
@interface CircleImageButton : UIButton<EGOImageLoaderObserver>{
    CALayer *imageLayer;
}

- (id)initWithPlaceholderImage:(UIImage*)anImage withFrame : (CGRect) frame;
- (id)initWithPlaceholderImage:(UIImage*)anImage withFrame : (CGRect) frame delegate:(id<CircleImageButtonDelegate>)aDelegate;
-(void)RemoveDefaultAction;
- (void)cancelImageLoad;

@property int targetID;
@property(nonatomic,strong) NSURL* imageURL;
@property(nonatomic,strong) UIImage* placeholderImage;
@property(nonatomic,assign) id<CircleImageButtonDelegate> delegate;
@property(nonatomic,strong) UIImage *networkImage;
@end


@protocol CircleImageButtonDelegate<NSObject>
@optional
- (void)circleImageButtonLoadedImage:(CircleImageButton*)imageButton;
- (void)circleImageButtonFailedToLoadImage:(CircleImageButton*)imageButton error:(NSError*)error;
@end

