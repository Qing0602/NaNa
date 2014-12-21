//
// Copyright (c) 2010-2011 René Sprotte, Provideal GmbH
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#define K_DEFAULT_LABEL_HEIGHT  31
#define K_DEFAULT_LABEL_INSET   0

#import "MMGridViewDefaultCell.h"

@implementation MMGridViewDefaultCell

@synthesize textLabel;
@synthesize textLabelBackgroundView;
@synthesize backgroundView;

- (void)dealloc
{
    [textLabel release];
    [textLabelBackgroundView release];
    [backgroundView release];
    [textPrice release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
        // Background view
        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectNull] autorelease];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundView];
        
        self.imageview = [[[EGOImageView alloc] initWithFrame:CGRectNull] autorelease];
        [self.imageview setPlaceholderImage:[UIImage imageNamed:@""]];
        [self addSubview:self.imageview];
        
        // Label
        self.textLabelBackgroundView = [[[UIView alloc] initWithFrame:CGRectNull] autorelease];
        self.textLabelBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        self.textLabel = [[[UILabel alloc] initWithFrame:CGRectNull] autorelease];
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:12];
        
        self.textPrice = [[[UILabel alloc] initWithFrame:CGRectNull] autorelease];
        self.textPrice.textAlignment = UITextAlignmentLeft;
        self.textPrice.backgroundColor = [UIColor clearColor];
        self.textPrice.textColor = [UIColor whiteColor];
        self.textPrice.font = [UIFont boldSystemFontOfSize:12.0f];
        
        [self.textLabelBackgroundView addSubview:self.textLabel];
        [self.textLabelBackgroundView addSubview:self.textPrice];
        [self addSubview:self.textLabelBackgroundView];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    labelHeight = K_DEFAULT_LABEL_HEIGHT;
    labelInset = K_DEFAULT_LABEL_INSET;
    
    // Background view
    self.backgroundView.frame = self.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.imageview.frame = self.bounds;
    self.imageview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Layout label
    self.textLabelBackgroundView.frame = CGRectMake(0, 
                                                    self.bounds.size.height - labelHeight - labelInset, 
                                                    self.bounds.size.width, 
                                                    labelHeight);
    self.textLabelBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Layout label background
    CGRect f = CGRectMake(0, 
                          0, 
                          self.textLabel.superview.bounds.size.width,
                          16.0f);
    self.textLabel.frame = CGRectInset(f, labelInset, 0);
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.textPrice.frame = CGRectMake(0.0f, 16.0f, self.textLabel.superview.bounds.size.width, 15.0f);
}

@end
