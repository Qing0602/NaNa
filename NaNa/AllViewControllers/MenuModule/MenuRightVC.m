//
//  MenuRightVC.m
//  NaNa
//
//  Created by dengfang on 13-8-8.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "MenuRightVC.h"
#import "MenuCell.h"
#import "VisitorVC.h"
#import "FriendVC.h"
#import "LikeVC.h"

typedef enum {
    SettingEditRowVisitor     = 0,
    SettingEditRowLove        = 1,
    SettingEditRowFriend      = 2,
} SettingEditRow;

@implementation MenuRightVC

- (void)loadView {
    [super loadView];
    [self.navBarView removeFromSuperview];
    _defaultView.frame = CGRectMake(0, self.currentDeviceLateriOS7 ? 20 : 0, 320, CGRectGetHeight(self.view.frame) - (self.currentDeviceLateriOS7 ? 20 : 0));
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:_defaultView.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRed:45.0f/255.0f green:46.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorColor = [UIColor clearColor];
    }
    [_defaultView addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    SAFERELEASE(_tableView)
    [super dealloc];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier] autorelease];
//        cell.contentView.backgroundColor = (indexPath.row%2) ? [UIColor blackColor]:[UIColor grayColor];
    }
    
    if(indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_visitor_normal.png"];
        cell.nameLabel.text = STRING(@"guest");
        
    } else if(indexPath.row == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_like_normal.png"];
        cell.nameLabel.text = STRING(@"like");
        
    } else {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_friend_normal.png"];
        cell.nameLabel.text = STRING(@"friend");
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case SettingEditRowVisitor: {
            ULog(@"SettingEditRowVisitor");
            VisitorVC  *controller = [[[VisitorVC alloc] init] autorelease];
            [self pushPage:controller];
            break;
        }
        case SettingEditRowLove: {
            ULog(@"SettingEditRowLove");
            LikeVC *controller = [[[LikeVC alloc] init] autorelease];
            [self pushPage:controller];
            break;
        }
        case SettingEditRowFriend: {
            ULog(@"SettingEditRowFriend");
            FriendVC *controller = [[[FriendVC alloc] init] autorelease];
            [self pushPage:controller];
            break;
        }
    }
}

@end
