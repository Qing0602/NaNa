//
//  CircleImageButton.m
//  circleImageButton
//
//  Created by 王硕 on 13-5-12.
//  Copyright (c) 2013年 王硕. All rights reserved.
//

#import "CircleImageButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"

@interface CircleImageButton ()
-(UIImage *) resizedImage : (UIImage *) anImage;
@end

@implementation CircleImageButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
        UIBezierPath *layerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, frame.size.width - 2, frame.size.height - 2)];
        maskLayer.path = layerPath.CGPath;
        maskLayer.fillColor = [UIColor blackColor].CGColor;
        
        //self.layer.masksToBounds = YES;
        self.layer.mask = maskLayer;
        [self addTarget:self action:@selector(ButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)RemoveDefaultAction
{
    [self removeTarget:self action:@selector(ButtonDown) forControlEvents:UIControlEventTouchUpInside];

}
-(void)ButtonDown
{
    if (self.targetID ==0) {
    }else
    {
    }
    
    
}
- (id)initWithPlaceholderImage:(UIImage*)anImage withFrame:(CGRect) frame{
	return [self initWithPlaceholderImage:anImage withFrame:frame delegate:nil];
}

- (id)initWithPlaceholderImage:(UIImage*)anImage withFrame:(CGRect) frame delegate:(id<CircleImageButtonDelegate>)aDelegate {
	
    
    
    if((self = [self initWithFrame:frame])) {
        
        UIImage *resizedImage = nil;
        if (nil != anImage) {
            resizedImage = [self resizedImage:anImage];
        }
        
		self.placeholderImage = resizedImage;
		self.delegate = aDelegate;
        [self setBackgroundImage:resizedImage forState:UIControlStateNormal];
        
//        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            UIImage *resizedImage = nil;
//            if (nil != anImage) {
//                resizedImage = [self resizedImage:anImage];
//            }
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                self.placeholderImage = resizedImage;
//                self.delegate = aDelegate;
//                [self setBackgroundImage:resizedImage forState:UIControlStateNormal];
//            });
//            
//        });
	}
	
	return self;
}

-(void) setPlaceholderImage:(UIImage *)placeholderImage{
    UIImage *resizedImage = nil;
    if (nil != placeholderImage) {
        resizedImage = [self resizedImage:placeholderImage];
    }
    
    _placeholderImage = resizedImage;
    [self setBackgroundImage:resizedImage forState:UIControlStateNormal];
}

-(UIImage *) resizedImage:(UIImage *)anImage{
    return [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(self.frame.size.width, self.frame.size.height) interpolationQuality:kCGInterpolationDefault];
}

//-(void) setImage:(UIImage *)image{
//    self.layer.contents = (id)image.CGImage;
//}

- (void)setImageURL:(NSURL *)aURL {
	if(self.imageURL) {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
        
		_imageURL = nil;
	}
	
	if(!aURL) {
        [self setBackgroundImage:self.placeholderImage forState:UIControlStateNormal];
		_imageURL = nil;
		return;
	} else {
		_imageURL = aURL;
	}
	
	UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:self.imageURL shouldLoadWithObserver:self];
	
	if(anImage) {
        self.networkImage = [self resizedImage:anImage];
		[self setBackgroundImage:self.networkImage forState:UIControlStateNormal];
	} else {
        [self setBackgroundImage:self.placeholderImage forState:UIControlStateNormal];
	}
}



#pragma mark -
#pragma mark Image loading

- (void)cancelImageLoad {
	[[EGOImageLoader sharedImageLoader] cancelLoadForURL:self.imageURL];
	[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
}

- (void)imageLoaderDidLoad:(NSNotification*)notification {
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
	UIImage* anImage = [[notification userInfo] objectForKey:@"image"];
    self.networkImage = [self resizedImage:anImage];
    [self setBackgroundImage:self.networkImage forState:UIControlStateNormal];
	[self setNeedsDisplay];
	
	if([self.delegate respondsToSelector:@selector(circleImageButtonLoadedImage:)]) {
		[self.delegate circleImageButtonLoadedImage:self];
	}
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification {
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
	if([self.delegate respondsToSelector:@selector(circleImageButtonFailedToLoadImage:error:)]) {
		[self.delegate circleImageButtonFailedToLoadImage:self error:[[notification userInfo] objectForKey:@"error"]];
	}
}

#pragma mark -
- (void)dealloc {
	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	self.imageURL = nil;
	self.placeholderImage = nil;
    self.networkImage = nil;
    [super dealloc];
}

@end
