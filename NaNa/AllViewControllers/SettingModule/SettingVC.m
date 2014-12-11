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
#import "PasswordLockManagementViewController.h"
#import "PasswordLockViewController.h"
#import "AppDelegate.h"
#import "ColorUtil.h"

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
    
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)loadView {
    [super loadView];
    
    //_defaultView.backgroundColor = [UIColor colorWithRed:240/225.0 green:245/255.0 blue:255/255.0 alpha:1.0];
    // title
    self.title = STRING(@"setting");
    [self setNavLeftType:UNavBarBtnTypeMenu navRightType:UNavBarBtnTypeTa];
    
    // 填充资料的tableView
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5.0, 25.0f,
                                                                   _defaultView.frame.size.width-5.f,
                                                                   kSettingEditCellHeight * kSettingEditCellNumber)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.scrollEnabled = NO;
    }
    [_defaultView addSubview:_tableView];
    
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.frame = CGRectMake(15.0f, _tableView.frame.size.height+50.0, kSettingEditCellShowWidth, 40.0);
        [_logoutButton setBackgroundColor:[UIColor colorWithHexString:@"#ff6633"]];
        [_logoutButton setTitle:STRING(@"logout") forState:UIControlStateNormal];
        [_logoutButton setTitle:STRING(@"logout") forState:UIControlStateHighlighted];
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _logoutButton.layer.cornerRadius = 5;
        _logoutButton.clipsToBounds = YES;
        [_logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
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
-(void)logout
{
    [[NaNaUIManagement sharedInstance] quit];
     [APP_DELEGATE loadLoginView];
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
        cell.backgroundColor = [UIColor whiteColor];
        //被选中cell容器
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    // 名称
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.frame = CGRectMake(20.0, 5.0, kSettingEditCellShowWidth, kSettingEditCellShowHeight);
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
            
            NSDictionary *lockData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
            if (![lockData[PWD_LOCK_STATUS] boolValue]) {
                UILabel *pwdLockStatus = [[UILabel alloc] init];
                pwdLockStatus.backgroundColor = [UIColor clearColor];
                pwdLockStatus.frame = CGRectMake(kSettingEditCellShowWidth-48.f, 5.0, 30, kSettingEditCellShowHeight);
                pwdLockStatus.textColor = default_color_empty_gray;
                pwdLockStatus.tag = 1001;
                pwdLockStatus.font = [UIFont boldSystemFontOfSize:default_font_size_14];
                pwdLockStatus.text = @"关闭";
                [cell.contentView addSubview:pwdLockStatus];
            }else
            {
                UILabel *tempPwdLockLabel = (UILabel *)[cell.contentView viewWithTag:1001];
                if (tempPwdLockLabel) [tempPwdLockLabel removeFromSuperview];
            }
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
            NotificationSettingVC *controller = [[NotificationSettingVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];


            break;
        }
        case SettingEditRowRedeem: {
            ULog(@"redeemcode");
            RedeemcodeVC *controller = [[RedeemcodeVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case SettingEditRowLock: {
            ULog(@"lock");
            NSDictionary *lockData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
            if (lockData) {
                PasswordLockManagementViewController *management = [[PasswordLockManagementViewController alloc] init];
                [self.navigationController pushViewController:management animated:YES];
            }else
            {
                PasswordLockViewController *passwordLock = [[PasswordLockViewController alloc] initWithType:VERIFY_TYPE_SETTING];
                [self.navigationController pushViewController:passwordLock animated:YES];
            }
            break;
        }
        case SettingEditRowBlack: {
            ULog(@"black");
            MyBlackListVC *controller = [[MyBlackListVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case SettingEditRowSuggestion: {
            ULog(@"suggestion");
            SuggestVC *controller = [[SuggestVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            // select city
            break;
        }
        case SettingEditRowGrade: {
            ULog(@"grade");
            // select city
            //https://itunes.apple.com/us/app/na-nanana-la-lales-jiao-you/id942256934?l=zh&ls=1&mt=8
            NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=942256934"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
            break;
        }
    }
}


@end
