//
//  RoundRectEGOImageButton.m
//  iStation
//
//  Created by 郑 帅 on 13-5-23.
//  Copyright (c) 2013年 北京友宝昂莱科技有限公司. All rights reserved.
//

#import "RoundRectEGOImageButton.h"



@implementation RoundRectEGOImageButton
{
  UIImageView * faceView ;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code   
        
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    
    }
    return self;
}

- (id)initWithPlaceholderImage:(UIImage*)anImage withFrame:(CGRect) frame FaceType:(Face_Type)_type {
	if((self = [self initWithFrame:frame])) {
        
        UIImage *resizedImage = nil;
        if (nil != anImage) {
            resizedImage = [self resizedImage:anImage];
        }
        
		self.placeholderImage = resizedImage;
		self.delegate = nil;
        [self setImage:resizedImage forState:UIControlStateNormal];
        
        
        type = _type;
        if (type!=0) {
//            faceView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 25, 25)];
//            faceView.image = [UIImage imageNamed:[NSString stringWithFormat:@"face%d",_type]];            
        }
	}
	return self;
}

//-(void) setPlaceholderImage:(UIImage *)_placeholderImage{
//    UIImage *resizedImage = nil;
//    if (nil != _placeholderImage) {
//        resizedImage = [self resizedImage:_placeholderImage];
//    }
//    
//    placeholderImage = resizedImage;
//    [self setImage:resizedImage forState:UIControlStateNormal];
//}

-(UIImage *) resizedImage:(UIImage *)anImage{
    return [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(self.frame.size.width, self.frame.size.height) interpolationQuality:kCGInterpolationDefault];
}

- (void)setImageURL:(NSURL *)aURL {
	if(self.imageURL) {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
        [imageURL release];
		imageURL = nil;
	}
	
	if(!aURL) {
        [self setImage:self.placeholderImage forState:UIControlStateNormal];
		imageURL = nil;
		return;
	} else {
		imageURL = [aURL retain];
	}
  
	UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:aURL shouldLoadWithObserver:self];
	
	if(anImage) {
		[self setImage:[self resizedImage:anImage] forState:UIControlStateNormal];
	} else {
        [self setImage:self.placeholderImage forState:UIControlStateNormal];
	}
 
}

- (void)imageLoaderDidLoad:(NSNotification*)notification {
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
	UIImage* anImage = [[notification userInfo] objectForKey:@"image"];
    [self setImage:[self resizedImage:anImage] forState:UIControlStateNormal];
	[self setNeedsDisplay];
	
	if([self.delegate respondsToSelector:@selector(circleImageButtonLoadedImage:)]) {
		[self.delegate imageButtonLoadedImage:self];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
