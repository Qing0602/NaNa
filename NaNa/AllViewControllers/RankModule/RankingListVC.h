//
//  RankingListVC.h
//  NaNa
//
//  Created by dengfang on 13-7-2.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBasicViewController.h"


@interface RankingListVC : UBasicViewController <UIWebViewDelegate> {
    
    UIButton        *_leftButton;       // 同城
    UIButton        *_centerButton;     // 周边
    UIButton        *_rightButton;      // 全部
    UIImageView     *_lineImageView;    // 分类按钮下方的线
    int             _currentType;       // 当前选择的
    
    UIWebView       *_leftWebview;      // 同城webview
    UIWebView       *_centerWebview;    // 周边webview
    UIWebView       *_rightWebview;     // 全部webview
    UIActivityIndicatorView     *_leftActivityView;     // _leftWebview载入时loading样式
    UIActivityIndicatorView     *_centerActivityView;   // _centerWebview载入时loading样式
    UIActivityIndicatorView     *_rightActivityView;    // _rightWebview载入时loading样式
}

typedef enum {
    RankTypeNone    = 0,
	RankTypeCity    = 1,
    RankTypeNear    = 2,
    RankTypeAll     = 3,
} RankType;

@end
