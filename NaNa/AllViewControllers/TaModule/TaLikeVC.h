//
//  TaLikeVC.h
//  NaNa
//
//  Created by dengfang on 14-1-16.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBasicViewController.h"

@interface TaLikeVC : UBasicViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIWebView                   *_myWebView;
    UIActivityIndicatorView     *_activityView;
}
-(id)initWithUserID:(NSInteger)userID;
@end
