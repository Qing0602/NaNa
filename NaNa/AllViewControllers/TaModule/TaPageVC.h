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
    TaPageTabItemAlbum          = 0,
    TaPageTabItemInfo           = 1,
    TaPageTabItemLike           = 2,
    TaPageTabItemChat           = 3,
} TaPageTabItem;

@interface TaPageVC : UBasicViewController <UITabBarDelegate, UIWebViewDelegate> {
    UIWebView                   *_myWebView;
    UIActivityIndicatorView     *_activityView;
    NSURL                       *_url;
    NSInteger targetID;
}

- (id)initWithURL:(NSString *)url;
@end
