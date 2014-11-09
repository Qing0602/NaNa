//
//  MoreVC.h
//  NaNa
//
//  Created by singlew on 14/11/9.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "UBasicViewController.h"

@interface MoreVC : UBasicViewController<UIWebViewDelegate>{
    UIWebView                   *_myWebView;
    UIActivityIndicatorView     *_activityView;
}
-(id) initMore : (NSURL *) url withTitle : (NSString *) title;
@end
