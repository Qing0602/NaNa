//
//  PasswordLockManagementViewController.m
//  NaNa
//
//  Created by ZhangQing on 14-9-27.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "PasswordLockManagementViewController.h"
#import "PasswordLockViewController.h"
@interface PasswordLockManagementViewController ()
{
    BOOL tempLockStatus;
}
@end

@implementation PasswordLockManagementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary *lockData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
    if (lockData) {
        tempLockStatus = [lockData[PWD_LOCK_STATUS] boolValue];
    }else
    {
        NSLog(@"something worng");
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSDictionary *lockData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
    if (lockData) {
        NSMutableDictionary *temdic = [NSMutableDictionary dictionaryWithDictionary:lockData];
        [temdic setValue:[NSNumber numberWithBool:tempLockStatus] forKey:PWD_LOCK_STATUS];
        lockData = [NSDictionary dictionaryWithDictionary:temdic];
        [[NSUserDefaults standardUserDefaults] setObject:lockData forKey:[NSString stringWithFormat:@"%d",[NaNaUIManagement sharedInstance].userAccount.UserID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else
    {
        NSLog(@"something worng");
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 20.f, 320.f, 80.f) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableview.scrollEnabled = NO;
    [self.defaultView addSubview:tableview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            tempLockStatus = !tempLockStatus;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = tempLockStatus?@"关闭密码锁":@"打开密码锁";
        }
            break;
        case 1:
        {
            PasswordLockViewController *passwordLock = [[PasswordLockViewController alloc] initWithType:VERIFY_TYPE_CHANGE];
            [self.navigationController pushViewController:passwordLock animated:YES];
        }
            break;
        default:
            break;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"lockManageCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = indexPath.row == 0 ?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.textLabel.textColor = [self colorWithHexString:@"#1e1e1e"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = indexPath.row == 0?(tempLockStatus?@"关闭密码锁":@"打开密码锁"):@"修改密码";

    return cell;
}
#pragma mark - Nav
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
