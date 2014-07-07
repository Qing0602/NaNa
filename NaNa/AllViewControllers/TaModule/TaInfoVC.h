//
//  TaInfoVC.h
//  NaNa
//
//  Created by ubox  on 14-1-21.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "UBasicViewController.h"

typedef enum {
    InfoEditRowName     = 0,
    InfoEditRowRole     = 1,
    InfoEditRowAge      = 2,
    InfoEditRowCity     = 3,
} InfoEditRow;

@interface TaInfoVC : UBasicViewController<UITableViewDataSource,
UITableViewDelegate>
{
    UIImageView         *_headView;     // 头像
    UIButton            *_playButton;     // 播放
    UITableView         *_tableView;      // 信息
    UITextField         *_nameTextField;  // 名称
    UILabel             *_ageLabel;       // 年龄
    UILabel             *_roleLabel;      // 角色
    UILabel             *_cityLabel;      // 城市
}
@end
