//
//  UTabbar.h
//  UBoxOnline
//
//  Created by ubox on 13-3-13.
//  Copyright (c) 2013年 ubox. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义TabBar对应各个模块的枚举
typedef enum {
    UTabBarFirst = 0,
    UTabBarSecond,
    UTabBarThird,
    UTabBarFourth,
}UTabBarIndex;

typedef BOOL(^TabBlock)(NSInteger index);
typedef void(^SelectTabbarBlock) (NSInteger index);
// 用于自定义的TabBar
@interface UTabbar : UIImageView {
    NSMutableArray *_tabbarBtnArray;
}
@property (nonatomic,copy) SelectTabbarBlock didSelectTabBlock;

- (id)initWithTitleArray:(NSArray *)titleArray
              imageArray:(NSArray *)imageArray
        selectImageArray:(NSArray *)selectImageArray;


@end