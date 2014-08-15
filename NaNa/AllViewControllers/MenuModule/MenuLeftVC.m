//
//  MenuLeftVC.m
//  NaNa
//
//  Created by dengfang on 13-7-2.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "MenuLeftVC.h"
#import "MessageInfoData.h"
#import "RankingListVC.h"
#import "MyPageVC.h"
#import "SettingVC.h"
#import "MenuCell.h"
#import "MsgCell.h"


#define MENU_ROW_HEIGHT     44.0
#define MSG_ROW_HEIGHT      80.0

@interface MenuLeftVC ()
@property (nonatomic,strong) NSArray *messages;
@end

@implementation MenuLeftVC


-(void) viewDidLoad{
    [super viewDidLoad];
    
    [self.navBarView removeFromSuperview];
    _defaultView.frame = CGRectMake(0, self.currentDeviceLateriOS7 ? 20 : 0, 320, CGRectGetHeight(self.view.frame) - (self.currentDeviceLateriOS7 ? 20 : 0));
    // table
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:_defaultView.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = [UIColor colorWithRed:45.0f/255.0f green:46.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorColor = [UIColor clearColor];
    }
    [_defaultView addSubview:_tableView];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"sideResult" options:0 context:nil];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NaNaUIManagement sharedInstance] getSideMessage];
}

-(void) dealloc{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"sideResult"];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"sideResult"]) {
        
        MessageInfoData *messageInfo = [[MessageInfoData alloc] init];
        messageInfo.avatarUrl = @"aaa";
        messageInfo.content = @"abcdefg";
        messageInfo.count = 10;
        messageInfo.createtime = 0;
        messageInfo.nickname = @"123";
        messageInfo.senderID = 5;
        NSMutableArray *a = [[NSMutableArray alloc] initWithObjects:messageInfo, nil];
        self.messages = a;
        
        [_tableView reloadData];
        
        if (![[[NaNaUIManagement sharedInstance].sideResult objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            messageInfoConver *conver = [[messageInfoConver alloc] init];
            self.messages = [conver createByArray:[[NaNaUIManagement sharedInstance].sideResult objectForKey:ASI_REQUEST_DATA]];
            
            MessageInfoData *messageInfo = [[MessageInfoData alloc] init];
            messageInfo.avatarUrl = @"aaa";
            messageInfo.content = @"abcdefg";
            messageInfo.count = 10;
            messageInfo.createtime = 0;
            messageInfo.nickname = @"123";
            messageInfo.senderID = 5;
            NSMutableArray *a = [[NSMutableArray alloc] initWithObjects:messageInfo, nil];
            self.messages = a;
            
            [_tableView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ((section == 0) ? 3 : [self.messages count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *Menukey = @"Menukey";
        
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:Menukey];
        if (cell == nil) {
            cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:Menukey];
        }
        
        switch (indexPath.row) {
            case MenuLeftRowRanking: {
                cell.iconImageView.image = [UIImage imageNamed:@"icon_meila_normal.png"];
                cell.nameLabel.text = STRING(@"rank");
                [cell.nameLabel setTextColor:[UIColor whiteColor]];
                break;
            }
            case MenuLeftRowMyPage: {
                cell.iconImageView.image = [UIImage imageNamed:@"icon_head_normal.png"];
                [cell.nameLabel setTextColor:[UIColor whiteColor]];
                cell.nameLabel.text = STRING(@"myPage");
                break;
            }
            case MenuLeftRowSetting: {
                cell.iconImageView.image = [UIImage imageNamed:@"icon_setting_normal.png"];
                [cell.nameLabel setTextColor:[UIColor whiteColor]];
                cell.nameLabel.text = STRING(@"setting");
                break;
            }
        }
        return cell;
        
    } else {
        static NSString *Msgkey = @"MsgKey";
        
        MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:Msgkey];
        if (cell == nil) {
            cell = [[MsgCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:Msgkey];
        }
        
        cell.headImageView.image = [UIImage imageNamed:@"icon.png"];
        cell.msgLabel.text = [NSString stringWithFormat:@"%@: %@", @"name", @"测试测试， 测试测试， 测试测试， 测试测试， 测试测试， 测试测试， 测试测试"];
        cell.timeLabel.text = @"1分钟前";
        [cell setModel:[self.messages objectAtIndex:indexPath.row]];
        cell.contentView.backgroundColor = RGBA(57.0,56.0,60.0,1.0);
        cell.cellLine.frame = CGRectMake(0.0f, 80.0f - 3.0f, 320.0f, 3.0f);
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return STRING(@"msg");
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView * header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 20.0f)];
        header.backgroundColor = RGBA(70.0,71.0,75.0,1.0);
       
        UILabel * title =  [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 20.0f)];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        title.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
        title.font = [UIFont boldSystemFontOfSize:13];
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        
        UIButton * fresh=[[UIButton alloc] initWithFrame:CGRectMake(250, 3, 25, 25)];
        fresh.backgroundColor = [UIColor clearColor];
        [fresh setBackgroundImage:[UIImage imageNamed:@"btn_fresh_normal.png"] forState:UIControlStateNormal];
        [fresh setBackgroundImage:[UIImage imageNamed:@"btn_fresh_pressed.png"] forState:UIControlStateHighlighted];
        
        [fresh addTarget:self action:@selector(refreshMessage) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:title];
        [header addSubview:fresh];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return MENU_ROW_HEIGHT;
    } else {
        return MSG_ROW_HEIGHT;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case MenuLeftRowRanking: {
                RankingListVC *controller = [[RankingListVC alloc] init];
                [self pushPage:controller];
                break;
            }
            case MenuLeftRowMyPage: {
                MyPageVC *controller = [[MyPageVC alloc] init];
                [self pushPage:controller];
                break;
            }
            case MenuLeftRowSetting: {
                SettingVC *controller = [[SettingVC alloc] init];
                [self pushPage:controller];
                break;
            }
            default:
                break;
        }
    }
}

- (void)refreshMessage
{
    ULog(@"刷新消息");
}

@end
