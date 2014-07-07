//
//  UWebViewController.h
//  NaNa
//
//  Created by shenran on 11/3/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "UBasicViewController.h"

@interface UWebViewController : UBasicViewController<UIWebViewDelegate>
{
    UIWebView                   *_myWebView;
    UIActivityIndicatorView     *_activityView;
    NSString * _URL;
    NSString * _TITLE;
}

@property (nonatomic, retain) IBOutlet NSString *URL;
@property (nonatomic, retain) IBOutlet NSString *TITLE;


@end
