//
//  LoginVC.h
//  NaNa
//
//  Created by shenran on 11/18/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "UBasicViewController.h"


// 栏目位置
typedef enum {
    LoginTabItemQQ          = 0,
    LoginTabItemWeibo       = 1,
    LoginTabItemWeixin      = 2,
} LoginTabItem;

@interface LoginVC : UBasicViewController <UIScrollViewDelegate,UITabBarDelegate >
{

    UIScrollView    * _scrollview;
    NSMutableArray  * _imageList;
    UITabBar        *_tabBar;
}

@property(nonatomic,retain)NSMutableArray * imageList;
@end
