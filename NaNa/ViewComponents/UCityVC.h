//
//  UCityVC.h
//  Test
//
//  Created by 陈浩男 on 13-8-16.
//  Copyright (c) 2013年 陈浩男. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UCity.h"
#import "CMIndexBar.h"
#import "UBasicViewController.h"

@interface UCityVC : UBasicViewController <UITableViewDataSource,
  UITableViewDelegate,
  CMIndexBarDelegate,
  UISearchBarDelegate,
  UIGestureRecognizerDelegate> {
      
    CMIndexBar *_indexBar;
    UIGestureRecognizer *_tap;
}
@property (nonatomic, retain) UITableView *cityTable;
@property (nonatomic, retain) UIImageView *sadFace;
@property (nonatomic, retain) UILabel *sadMessage;
@property (nonatomic, retain) UCity *uCity;
@property (nonatomic, retain) NSMutableArray *hotArray;
@property (nonatomic, retain) NSMutableArray *allArray;
@property (nonatomic, retain) NSMutableArray *searchedArray;
@property (nonatomic, retain) NSMutableArray *searchedCity;
@property (nonatomic, retain) UISearchBar *searchCity;
@property (nonatomic, copy) NSString *GPSInfo;
@property (nonatomic, assign) BOOL isSearchState;
@property (nonatomic, retain) UIGestureRecognizer *tap;

@end
