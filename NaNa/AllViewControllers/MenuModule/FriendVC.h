//
//  FriendVC.h
//  NaNa
//
//  Created by shenran on 10/31/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "UBasicViewController.h"

@interface FriendVC : UBasicViewController <UIWebViewDelegate> {
    UIWebView                   *_myWebView;
    UIActivityIndicatorView     *_activityView;
}

@end
