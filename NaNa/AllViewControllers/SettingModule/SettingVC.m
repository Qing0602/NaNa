//
//  SetupVC.m
//  NaNa
//
//  Created by shenran on 10/30/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "SettingVC.h"
#import "NotificationSettingVC.h"
#import "MyBlackListVC.h"
#import "SuggestVC.h"
#import "PasswordLockVC.h"
#import "RedeemcodeVC.h"
@interface SettingVC()
@end
#define kSettingEditCellHeight         40.0
#define kSettingEditCellShowHeight     30.0
#define kSettingEditCellSildWidth      15.0
#define kSettingEditCellShowWidth      290.0
#define kSettingEditCellNumber         6

typedef enum {
    SettingEditRowNontification     = 0,
    SettingEditRowLock              = 2,
    SettingEditRowBlack             = 3,
    SettingEditRowSuggestion        = 4,
    SettingEditRowGrade             = 5,
    SettingEditRowRedeem            = 1,
} SettingEditRow;

@implementation SettingVC 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setSideMenuController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)loadView {
    [super loadView];
    
    _defaultView.backgroundColor = [UIColor colorWithRed:240/225.0 green:245/255.0 blue:255/255.0 alpha:1.0];
    // title
    self.title = STRING(@"setting");
    [self setNavLeftType:UNavBarBtnTypeMenu navRightType:UNavBarBtnTypeTa];
    
    // 填充资料的tableView
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 25.0f,
                                                                   _defaultView.frame.size.width,
                                                                   kSettingEditCellHeight * kSettingEditCellNumber)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
    }
    [_defaultView addSubview:_tableView];
    
    if (!_logoutButton) {
        _logoutButton = [[UIButton alloc] init];
        _logoutButton.frame = CGRectMake(15.0, _tableView.frame.size.height+50.0, kSettingEditCellShowWidth, 50.0);
        [_logoutButton setBackgroundImage:[UIImage imageNamed:@"btn_red_normal.png"] forState:UIControlStateNormal];
        [_logoutButton setBackgroundImage:[UIImage imageNamed:@"btn_red_pressed.png"] forState:UIControlStateHighlighted];
        [_logoutButton setTitle:STRING(@"logout") forState:UIControlStateNormal];
    }
    [_defaultView addSubview:_logoutButton];
}


#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)rightItemPressed:(UIButton *)btn {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    SAFERELEASE(_activityView)
    SAFERELEASE(_tableView)
    SAFERELEASE(_logoutButton)
    [super dealloc];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return kSettingEditCellNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        //被选中cell容器
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        [cell autorelease];
    }
    
    // 背景
    UIImageView *bgImageView = [[[UIImageView alloc] init] autorelease];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.frame = CGRectMake(kSettingEditCellSildWidth, 0.0, kSettingEditCellShowWidth, kSettingEditCellShowHeight);
    bgImageView.image = [UIImage imageNamed:@"info_cell_bg_normal.png"];
    [cell.contentView addSubview:bgImageView];
    bgImageView.highlightedImage = [UIImage imageNamed:@"info_cell_bg_selected.png"];
    
    
    // 名称
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.frame = CGRectMake(20.0, 0.0, kSettingEditCellShowWidth, kSettingEditCellShowHeight);
    titleLabel.textColor = default_color_dark;
    titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    
    switch (indexPath.row) {
        case SettingEditRowNontification: {
            [titleLabel setText:STRING(@"notification")];
            [cell.contentView addSubview:titleLabel];
            break;
        }
        case SettingEditRowLock: {
            [titleLabel setText:STRING(@"lock")];
            [cell.contentView addSubview:titleLabel];
            break;
        }
        case SettingEditRowBlack: {
            [titleLabel setText:STRING(@"black")];
            [cell.contentView addSubview:titleLabel];
            break;
        }
        case SettingEditRowSuggestion: {
            [titleLabel setText:STRING(@"suggestion")];
            [cell.contentView addSubview:titleLabel];
            break;
        }
        case SettingEditRowGrade: {
            [titleLabel setText:STRING(@"grade")];
            [cell.contentView addSubview:titleLabel];
            break;
        }
        case SettingEditRowRedeem: {
            [titleLabel setText:STRING(@"redeemcode")];
            [cell.contentView addSubview:titleLabel];
            break;
        }
       
    }
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    // 箭头
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    arrow.frame = CGRectMake(kSettingEditCellShowWidth-14.0, (kSettingEditCellShowHeight - 14.0) / 2, 14.0, 14.0);
    [cell.contentView addSubview:arrow];
    [arrow release];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSettingEditCellHeight;
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case SettingEditRowNontification: {
            ULog(@"notification");
            NotificationSettingVC *controller = [[[NotificationSettingVC alloc] init] autorelease];
//            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
//            navController.navigationBarHidden = YES;
            
            [self.navigationController pushViewController:controller animated:YES];


            break;
        }
        case SettingEditRowRedeem: {
            ULog(@"redeemcode");
            RedeemcodeVC *controller = [[[RedeemcodeVC alloc] init] autorelease];
//            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
//            navController.navigationBarHidden = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
            
            
            break;
        }

        case SettingEditRowLock: {
            ULog(@"lock");
            PasswordLockVC *controller = [[[PasswordLockVC alloc] init] autorelease];
//            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
//            navController.navigationBarHidden = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
            break;

        }
        case SettingEditRowBlack: {
            ULog(@"black");
            MyBlackListVC *controller = [[[MyBlackListVC alloc] init] autorelease];
//            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
//            navController.navigationBarHidden = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
            break;

        }
        case SettingEditRowSuggestion: {
            ULog(@"suggestion");
            SuggestVC *controller = [[[SuggestVC alloc] init] autorelease];
//            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
//            navController.navigationBarHidden = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
            // select city
            break;
        }
        case SettingEditRowGrade: {
            ULog(@"grade");
            
            
            // select city
            break;
        }

    }
}


@end
