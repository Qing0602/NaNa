//
//  MyPageVC.h
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBasicViewController.h"

// 栏目位置
typedef enum {
    MyPageTabItemAlbum          = 0,
    MyPageTabItemInfoEdit       = 1,
    MyPageTabItemSetPrivate     = 2,
    MyPageTabItemUpdateMember   = 3,
} MyPageTabItem;

@interface MyPageVC : UBasicViewController <UITabBarDelegate, UIWebViewDelegate> {
    UIWebView                   *_myWebView;
    UIActivityIndicatorView     *_activityView;
    UITabBar                    *_tabBar;
}

@end
