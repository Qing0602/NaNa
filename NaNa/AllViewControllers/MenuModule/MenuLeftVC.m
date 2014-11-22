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
#import "NaNaUserProfileModel.h"
#import "ChatVC.h"
#import "ColorUtil.h"

#define MENU_ROW_HEIGHT     49.0f
#define MSG_ROW_HEIGHT      80.0
#define ONE_DAY_TIMEINTERVAL 24*60*60

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
        if (![[[NaNaUIManagement sharedInstance].sideResult objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            messageInfoConver *conver = [[messageInfoConver alloc] init];
            self.messages = [conver createByArray:[[NaNaUIManagement sharedInstance].sideResult objectForKey:ASI_REQUEST_DATA]];
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
                [cell.nameLabel setTextColor:[UIColor colorWithHexString:@"#c9c9cb"]];
                cell.unReaderImage.hidden = YES;
                cell.cellLine.frame = CGRectMake(cell.frame.origin.x, 46.0f, cell.cellLine.frame.size.width, cell.cellLine.frame.size.height);
                break;
            }
            case MenuLeftRowMyPage: {
                cell.iconImageView.image = [UIImage imageNamed:@"icon_head_normal.png"];
                [cell.nameLabel setTextColor:[UIColor colorWithHexString:@"#c9c9cb"]];
                cell.nameLabel.text = STRING(@"myPage");
                cell.unReaderImage.hidden = YES;
                cell.cellLine.frame = CGRectMake(cell.frame.origin.x, 46.0f, cell.cellLine.frame.size.width, cell.cellLine.frame.size.height);
                break;
            }
            case MenuLeftRowSetting: {
                cell.iconImageView.image = [UIImage imageNamed:@"icon_setting_normal.png"];
                [cell.nameLabel setTextColor:[UIColor colorWithHexString:@"#c9c9cb"]];
                cell.nameLabel.text = STRING(@"setting");
                cell.unReaderImage.hidden = YES;
                cell.cellLine.frame = CGRectMake(cell.frame.origin.x, 46.0f, cell.cellLine.frame.size.width, cell.cellLine.frame.size.height);
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
        MessageInfoData *msg = self.messages[indexPath.row];
        [cell.headImageView setImageURL:[NSURL URLWithString:msg.avatarUrl]];
        cell.msgLabel.text = [NSString stringWithFormat:@"%@: %@", msg.nickname, msg.content];
        cell.timeLabel.text = [self compareDate:msg.createtime];
        [cell setModel:msg];
        cell.contentView.backgroundColor = RGBA(45.0,46.0,50.0,1.0);
        
        CGSize size = [msg.content sizeWithFont:[UIFont boldSystemFontOfSize:13]];
        if (size.width < 201.0f) {
            cell.msgLabel.frame = CGRectMake(cell.msgLabel.frame.origin.x, cell.msgLabel.frame.origin.y, cell.msgLabel.frame.size.width, 25.0f);
            cell.timeLabel.frame = CGRectMake(cell.msgLabel.frame.origin.x, cell.msgLabel.frame.origin.y + cell.msgLabel.frame.size.height + 4.0f,
                                          cell.msgLabel.frame.size.width, 25);
            [cell.timeLabel sizeToFit];
            cell.cellLine.frame = CGRectMake(0.0f, 54.0f - 3.0f, 320.0f, 3.0f);
        }else{
            cell.msgLabel.frame = CGRectMake(cell.msgLabel.frame.origin.x, cell.msgLabel.frame.origin.y, cell.msgLabel.frame.size.width, 45.0f);
            cell.msgLabel.backgroundColor = [UIColor clearColor];
//            float offsetY = cell.msgLabel.frame.origin.y + cell.msgLabel.frame.size.height + margin_small;
            cell.timeLabel.frame = CGRectMake(cell.msgLabel.frame.origin.x, cell.msgLabel.frame.origin.y + cell.msgLabel.frame.size.height,
                                              cell.msgLabel.frame.size.width, 25);
            [cell.timeLabel sizeToFit];
            cell.cellLine.frame = CGRectMake(0.0f, 68.5f - 3.0f, 320.0f, 3.0f);
        }
        
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
        title.textColor = [UIColor colorWithHexString:@"#c9c9cb"];
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
        return 49.0f;
    } else {
        MessageInfoData *msg = self.messages[indexPath.row];
        CGSize size = [msg.content sizeWithFont:[UIFont boldSystemFontOfSize:13]];
        int height = 20.0f;
        if (size.width > 201.0f) {
            height = 68.5f;
        }else{
            height = 54.0f;
        }
        return height;
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
    }else{
        MessageInfoData *msg = self.messages[indexPath.row];
        NaNaUserProfileModel *model = [[NaNaUserProfileModel alloc] init];
        model.userID = msg.senderID;
        model.userNickName = msg.nickname;
        ChatVC *chatVC  =[[ChatVC alloc] initChatVC:model];
        [self pushPage:chatVC];
    }
}

-(NSString *)compareDate:(NSTimeInterval)timeDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateNow = [NSDate date];
    NSTimeInterval timeNow = [dateNow timeIntervalSince1970];
    
    if (timeNow - timeDate < ONE_DAY_TIMEINTERVAL) {
        return @"今天";
    }else if (timeNow - timeDate >= ONE_DAY_TIMEINTERVAL && timeNow - timeDate < ONE_DAY_TIMEINTERVAL*2.0 ){
        return @"昨天";
    }else if (timeNow - timeDate < ONE_DAY_TIMEINTERVAL*7.0 && timeNow - timeDate >= ONE_DAY_TIMEINTERVAL*2.0){
        return @"一周前";
    }else if (timeNow - timeDate < ONE_DAY_TIMEINTERVAL*30.0 && timeNow - timeDate >= ONE_DAY_TIMEINTERVAL*7.0 ){
        return @"一月前";
    }else {
        return @"很久以前";
    }
}

- (void)refreshMessage
{
    ULog(@"刷新消息");
}

@end
