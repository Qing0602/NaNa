//
//  SetupVC.h
//  NaNa
//
//  Created by shenran on 10/30/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBasicViewController.h"
@interface SettingVC : UBasicViewController <UITabBarDelegate,
UITableViewDelegate,
UITableViewDataSource>{
//    UIActivityIndicatorView     *_activityView;
    UITableView         *_tableView;                        // 修改信息
//    UILabel             *_notificationSetupLabel;           // 通知设置
//    UILabel             *_passwordLockLabel;                // 密码锁
//    UILabel             *_blackListLabel;                   // 黑名单
//    UILabel             *_suggestionLabel;                  // 意见
//    UILabel             *_gradeLabel;                       // 打分
    UIButton            *_logoutButton;                     //登出
    
    
}

@end
