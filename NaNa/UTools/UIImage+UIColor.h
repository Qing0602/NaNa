//
//  UIImage+UIColor.h
//  NaNa
//
//  Created by dengfang on 13-3-21.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 用于扩展UIImage,转换背景色
@interface UIImage (UIColor)

// 给透明区域上上色
- (UIImage *)changeImageColor:(UIColor *)theColor;
@end


// 通过颜色返回一个1*1大小的纯色图片
@interface UIColor (UIImage)

// 通过颜色返回一个1*1大小的纯色图片
- (UIImage *)image;

@end
