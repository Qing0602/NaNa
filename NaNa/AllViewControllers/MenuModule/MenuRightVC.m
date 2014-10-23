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

@interface MenuRightVC ()
@property (nonatomic) NSUInteger guestCount;
@property (nonatomic) NSUInteger likeCount;
@property (nonatomic) NSUInteger friendCount;
@end

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

-(void) viewDidLoad{
    [super viewDidLoad];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"friendsOfNew" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"lovedOfNew" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"visitorOfNew" options:0 context:nil];
}

- (void)dealloc {
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"friendsOfNew"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"lovedOfNew"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"visitorOfNew"];
    SAFERELEASE(_tableView)
    [super dealloc];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"friendsOfNew"]) {
        self.friendCount = [[NaNaUIManagement sharedInstance].friendsOfNew integerValue];
        [_tableView reloadData];
    }else if ([keyPath isEqualToString:@"lovedOfNew"]){
        self.likeCount = [[NaNaUIManagement sharedInstance].lovedOfNew integerValue];
        [_tableView reloadData];
    }else if ([keyPath isEqualToString:@"visitorOfNew"]){
        self.guestCount = [[NaNaUIManagement sharedInstance].visitorOfNew integerValue];
        [_tableView reloadData];
    }
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
    }
    
    if(indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_visitor_normal.png"];
        cell.nameLabel.text = STRING(@"guest");
        if (self.guestCount != 0) {
            cell.unReaderCount.text = [NSString stringWithFormat:@"%d",self.guestCount];
            [cell.unReaderCount sizeToFit];
            cell.unReaderCount.center = CGPointMake(16.0f/2.0f, 16.0f/2.0f);
            cell.unReaderImage.hidden = NO;
        }else{
            cell.unReaderImage.hidden = YES;
        }
        cell.cellLine.frame = CGRectMake(cell.frame.origin.x, 46.0f, cell.cellLine.frame.size.width, cell.cellLine.frame.size.height);
    } else if(indexPath.row == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_like_normal.png"];
        cell.nameLabel.text = STRING(@"like");
        if (self.likeCount != 0) {
            cell.unReaderCount.text = [NSString stringWithFormat:@"%d",self.likeCount];
            [cell.unReaderCount sizeToFit];
            cell.unReaderCount.center = CGPointMake(16.0f/2.0f, 16.0f/2.0f);
            cell.unReaderImage.hidden = NO;
        }else{
            cell.unReaderImage.hidden = YES;
        }
        cell.cellLine.frame = CGRectMake(cell.frame.origin.x, 46.0f, cell.cellLine.frame.size.width, cell.cellLine.frame.size.height);
    } else {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_friend_normal.png"];
        cell.nameLabel.text = STRING(@"friend");
        if (self.friendCount != 0) {
            cell.unReaderCount.text = [NSString stringWithFormat:@"%d",self.friendCount];
            [cell.unReaderCount sizeToFit];
            cell.unReaderCount.center = CGPointMake(16.0f/2.0f, 16.0f/2.0f);
            cell.unReaderImage.hidden = NO;
        }else{
            cell.unReaderImage.hidden = YES;
        }
        cell.cellLine.frame = CGRectMake(cell.frame.origin.x, 46.0f, cell.cellLine.frame.size.width, cell.cellLine.frame.size.height);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.0;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case SettingEditRowVisitor: {
            ULog(@"SettingEditRowVisitor");
            [NaNaUIManagement sharedInstance].visitorOfNew = [NSNumber numberWithInt:0];
            VisitorVC  *controller = [[[VisitorVC alloc] init] autorelease];
            [self pushPage:controller];
            break;
        }
        case SettingEditRowLove: {
            ULog(@"SettingEditRowLove");
            [NaNaUIManagement sharedInstance].lovedOfNew = [NSNumber numberWithInt:0];
            LikeVC *controller = [[[LikeVC alloc] init] autorelease];
            [self pushPage:controller];
            break;
        }
        case SettingEditRowFriend: {
            ULog(@"SettingEditRowFriend");
            [NaNaUIManagement sharedInstance].friendsOfNew = [NSNumber numberWithInt:0];
            FriendVC *controller = [[[FriendVC alloc] init] autorelease];
            [self pushPage:controller];
            break;
        }
    }
}

@end
