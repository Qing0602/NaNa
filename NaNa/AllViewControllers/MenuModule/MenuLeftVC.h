//
//  MenuLeftVC.h
//  NaNa
//
//  Created by dengfang on 13-7-2.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuLeftVCLogic.h"
#import "UBasicViewController.h"


// 栏目位置
typedef enum {
    MenuLeftRowRanking = 0,
    MenuLeftRowMyPage,
    MenuLeftRowSetting
} MenuLeftRow;


@class MessageInfoData;
@interface MenuLeftVC : UBasicViewController <UITableViewDataSource,UITableViewDelegate> {
    UITableView         *_tableView;
    MenuLeftVCLogic     *_menuLeftVCLogic;
}

@property (nonatomic, retain) MenuLeftVCLogic *menuLeftVCLogic;

@end
