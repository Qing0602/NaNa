//
//  NotificationSettingVCViewController.m
//  NaNa
//
//  Created by shenran on 10/31/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "NotificationSettingVC.h"

@interface NotificationSettingVC()

@end
#define kSettingEditCellHeight          40.0
#define kSettingEditCellWidth           40.0
#define kSettingEditCellShowHeight      40.0
#define kSettingEditCellSildWidth       15.0
#define kSettingEditCellShowWidth       320.0
#define kSettingEditCellTypeNumber      4
#define kSettingEditCellModeNumber      2
#define kSettingEditSectionNumber       1

typedef enum {
    SettingEditRowMessage     = 0,
    SettingEditRowVisitor     = 1,
    SettingEditRowLove        = 2,
    SettingEditRowFriend      = 3,
} SettingEditTypeRow;

typedef enum {
    SettingEditRowSound     = 0,
    SettingEditRowRock      =1,
} SettingEditModeRow;

@implementation NotificationSettingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userPushSetting"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].userPushSetting];
        if (![[tempData objectForKey:Http_Has_Error_Key] boolValue]) {
            NSDictionary *data = tempData[@"data"];
            for (int i =0; i < 6; i++) {
                NSIndexPath *indexPath ;
                if (i<4) {
                    indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                }else
                {
                    indexPath = [NSIndexPath indexPathForRow:i-4 inSection:1];
                }
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                NSInteger switchTag = indexPath.section*1000 + indexPath.row+10;
                UISwitch *notifySwitch = (UISwitch *)[cell.contentView viewWithTag:switchTag];
                switch (switchTag) {
                    case 10:
                    {
                        notifySwitch.on = [data[@"message_push"] boolValue];
                    }
                        break;
                    case 11:
                    {
                        notifySwitch.on = [data[@"visit_push"] boolValue];
                    }
                        break;
                    case 12:
                    {
                        notifySwitch.on = [data[@"love_push"] boolValue];
                    }
                        break;
                    case 13:
                    {
                        notifySwitch.on = [data[@"friend_push"] boolValue];
                    }
                        break;
                    case 1014:
                    {
                        
                    }
                        break;
                    case 1015:
                    {
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
        }else
        {
            
        }
    }else if ([keyPath isEqualToString:@"updateUserPushSetting"])
    {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].updateUserPushSetting];
        if (![[tempData objectForKey:Http_Has_Error_Key] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            NSLog(@"error == %@",tempData[@"errorMessage"]);
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"updateUserPushSetting" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"userPushSetting" options:0 context:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"updateUserPushSetting"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"userPushSetting"];
}
- (void)loadView {
    [super loadView];
    // title
    self.title = STRING(@"notification");
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeSubmit];
    
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
    }
    // 填充资料的tableView
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,
                                                                   0.0f,
                                                                   self.defaultView.frame.size.width,
                                                                   self.defaultView.frame.size.height)
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
    }
    [_defaultView addSubview:_tableView];
    
    
    
    [[NaNaUIManagement sharedInstance] getUserPushSetting];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSettingEditSectionNumber;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return kSettingEditCellTypeNumber;
            break;
            
        case 1:
            return kSettingEditCellModeNumber;
            break;
        default:
            return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 25.0;
            break;
            
        case 1:
            return 15.0;
            break;
        default:
            return 0;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //被选中cell容器
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        [cell autorelease];
        
    }
    
    if (![cell.contentView viewWithTag:100+indexPath.row])
    {
        // 名称
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 100+indexPath.row;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.frame = CGRectMake(15.0, 0.0, kSettingEditCellShowWidth, kSettingEditCellShowHeight);
        titleLabel.textColor = default_color_dark;
        titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case SettingEditRowMessage: {
                        [titleLabel setText:STRING(@"messageNotification")];
                        break;
                    }
                    case SettingEditRowVisitor: {
                        [titleLabel setText:STRING(@"visitorNotification")];
                        break;
                    }
                    case SettingEditRowLove: {
                        [titleLabel setText:STRING(@"loveNotification")];
                        break;
                    }
                    case SettingEditRowFriend: {
                        [titleLabel setText:STRING(@"friendNotification")];
                        break;
                    }
                }
                break;
            }
            case 1:
            {
                switch (indexPath.row) {
                    case SettingEditRowSound: {
                        [titleLabel setText:STRING(@"soundMode")];
                        break;
                    }
                    case SettingEditRowRock: {
                        [titleLabel setText:STRING(@"rockMode")];
                        break;
                    }
                }
                break;
            }
        }
        [cell.contentView addSubview:titleLabel];
        [titleLabel release];
    }
    
    if (![cell.contentView viewWithTag:indexPath.section*1000 + indexPath.row+10])
    {
        //开关
        UISwitch *notifySwitch=[[UISwitch alloc] init];
        notifySwitch.tag = indexPath.section*1000 + indexPath.row+10;
        notifySwitch.frame = CGRectMake(self.currentDeviceLateriOS7 ? 250: 200.0, (kSettingEditCellHeight-notifySwitch.frame.size.height)/2, 0, kSettingEditCellShowHeight);
        [notifySwitch setOn:true];
        [notifySwitch addTarget:self action:@selector(switchNotify:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:notifySwitch];
        [notifySwitch release];
    }

    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSettingEditCellHeight;
}
#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemPressed:(UIButton *)btn {
    if (_tableView) {
        BOOL canMessagePush = NO;
        BOOL canVisitPush = NO;
        BOOL canLovePush = NO;
        BOOL canFriendPush = NO;
        for (int i =0; i < 6; i++) {
            NSIndexPath *indexPath ;
            if (i<4) {
                indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            }else
            {
                indexPath = [NSIndexPath indexPathForRow:i-4 inSection:1];
            }
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            NSInteger switchTag = indexPath.section*1000 + indexPath.row+10;
            UISwitch *notifySwitch = (UISwitch *)[cell.contentView viewWithTag:switchTag];
            switch (switchTag) {
                case 10:
                {
                    canMessagePush = notifySwitch.on;
                }
                    break;
                case 11:
                {
                    canVisitPush = notifySwitch.on;
                }
                    break;
                case 12:
                {
                    canLovePush = notifySwitch.on;
                }
                    break;
                case 13:
                {
                    canFriendPush = notifySwitch.on;
                }
                    break;
                case 1014:
                {
                    
                }
                    break;
                case 1015:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        [[NaNaUIManagement sharedInstance] updateUserPushSetting:canMessagePush withCanVisitPush:canVisitPush withCanLovePush:canLovePush withCanFriendPush:canFriendPush];
    }
}

- (void)switchNotify:(UISwitch *)sw
{
    int section = sw.tag/1000;
    int row = sw.tag%1000-10;
    ULog(@"section = %d   row = %d  %@",section,row,sw.on ? @"开" : @"关");
}
@end
