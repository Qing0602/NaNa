//
//  UTabBtn.h
//  UBoxOnline
//
//  Created by 苏颖 on 13-3-27.
//  Copyright (c) 2013年 ubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UTabBtn : UIButton
{
    UIImageView *_bgImageView;
    UILabel     *_titleLabel;
}
@property (nonatomic,retain)UIImageView *bgImageView;
@property (nonatomic,retain)UILabel *titleLabel;

@end
