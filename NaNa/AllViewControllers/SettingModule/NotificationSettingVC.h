//
//  NotificationSettingVCViewController.h
//  NaNa
//
//  Created by shenran on 10/31/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "UBasicViewController.h"

@interface NotificationSettingVC : UBasicViewController<UITabBarDelegate,
UITableViewDelegate,
UITableViewDataSource>
{
    UIActivityIndicatorView     *_activityView;
    UITableView         *_tableView;
}

@end
