//
//  TaInfoVC.m
//  NaNa
//
//  Created by ubox  on 14-1-21.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "TaInfoVC.h"
#import "NaNaUserProfileModel.h"
#import <AVFoundation/AVFoundation.h>

#define kInfoEditCellHeight         40.0
#define kInfoEditCellShowHeight     30.0
#define kInfoEditCellSildWidth      15.0
#define kInfoEditCellShowWidth      290.0
#define kInfoEditCellNumber         4

@interface TaInfoVC ()<AVAudioPlayerDelegate>
{
    NSInteger targetID;
    NSString *_voiceUrl;
    AVAudioPlayer *_audioPlayer;
    NSString *_filePath;
}
@end

@implementation TaInfoVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"userProfile" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"downloadVoiceResult" options:0 context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"userProfile"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"downloadVoiceResult"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self closeProgress];
    if ([keyPath isEqualToString:@"userProfile"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].userProfile];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            self.infoData = [[NSDictionary alloc] initWithDictionary:[tempData objectForKey:ASI_REQUEST_DATA]];
            
        }
    }else if ([keyPath isEqualToString:@"downloadVoiceResult"]){
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
            [self closeProgress];
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            
            NSURL *url = [NSURL URLWithString:_filePath];
            
            NSError *audioPlayerError = nil;
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&audioPlayerError];
            _audioPlayer.numberOfLoops = 0;
            _audioPlayer.volume = 1.0f;
            _audioPlayer.delegate = self;
            if (_audioPlayer.prepareToPlay){
                [_audioPlayer play];
            }
        }else{
            [self showProgressWithText:@"声音下载失败，请重试" withDelayTime:1.5f];
        }
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithUserID:(NSInteger)userID
{
    self = [super init];
    if (self) {
        targetID = userID;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"她的资料";
    
    //_defaultView.backgroundColor = [UIColor whiteColor];
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    // 头像
    if (!_headButton) {
        // 圆形按钮
        //_headButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 15.0, 110.0, 110.0)];
        _headButton = [[CircleImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"head_cartoon_1.png"] withFrame:CGRectMake(105.0, 15.0, 110.0, 110.0)];
        //[_headButton setBackgroundImage:[UIImage imageNamed:@"head_bg.png"] forState:UIControlStateNormal];
        [_headButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _headButton.layer.cornerRadius = 55;
        _headButton.clipsToBounds = YES;
    }
    [_defaultView addSubview:_headButton];
    
    if (!_playButton)
    {
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(105.0, CGRectGetMaxY(_headButton.frame) + 10.0, 110.0, 30.0)];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"record_btn.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"btn_voice_play"] forState:UIControlStateNormal];
        _playButton.tag = 1;
        [_playButton setImageEdgeInsets:UIEdgeInsetsMake(7.f, 75.f, 7.f, 20.f)];
        [_playButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playTaSound:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_defaultView addSubview:_playButton];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 70.0, 20.0)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    label.text = @"她的声音";
    [_playButton addSubview:label];
    [label release];
    
    // 填充资料的tableView
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,
                                                                   CGRectGetMaxY(_playButton.frame) + 10,
                                                                   self.defaultView.frame.size.width,
                                                                   kInfoEditCellHeight * kInfoEditCellNumber + 10)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
       // _tableView.separatorColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.userInteractionEnabled = NO;
    }
    [_defaultView addSubview:_tableView];
    
    // 修改内容 for cell -------------------------------------------------------------------
    // 计算Cell内变动文字的坐标
    CGRect cellFrame = CGRectMake(70.0, 5.0, 200.0, kInfoEditCellShowHeight);
    
    // nikeName
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.frame = cellFrame;
        _nameTextField.backgroundColor = [UIColor clearColor];
        _nameTextField.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameTextField.placeholder = STRING(@"nikeName");
        _nameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        _nameTextField.returnKeyType = UIReturnKeyDone;
    }
    // role
    if (!_roleLabel) {
        _roleLabel = [[UILabel alloc] init];
        _roleLabel.frame = cellFrame;
        _roleLabel.textColor = default_color_dark;
        _roleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _roleLabel.backgroundColor = [UIColor clearColor];
        _roleLabel.text = STRING(@"role");
    }
    // age
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.frame = cellFrame;
        _ageLabel.textColor = default_color_dark;
        _ageLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _ageLabel.backgroundColor = [UIColor clearColor];
        _ageLabel.text = STRING(@"age");
    }
    // city
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.frame = cellFrame;
        _cityLabel.textColor = default_color_dark;
        _cityLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.text = STRING(@"city");
    }
    [self showProgressWithText:@"正在加载"];
    [[NaNaUIManagement sharedInstance] getUserProfile:targetID];
}

- (void)leftItemPressed:(UIButton *)btn {
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return kInfoEditCellNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        //被选中cell容器
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        [cell autorelease];
    }
    
    // 背景
//    UIImageView *bgImageView = [[[UIImageView alloc] init] autorelease];
//    bgImageView.backgroundColor = [UIColor clearColor];
//    bgImageView.frame = CGRectMake(kInfoEditCellSildWidth, 0.0, kInfoEditCellShowWidth, kInfoEditCellShowHeight);
//    bgImageView.image = [UIImage imageNamed:@"info_cell_bg_normal.png"];
//    [cell.contentView addSubview:bgImageView];
//    bgImageView.highlightedImage = [UIImage imageNamed:@"info_cell_bg_selected.png"];
    
    
    // 名称
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.frame = CGRectMake(30.0, 5.0, 30.0, kInfoEditCellShowHeight);
    titleLabel.textColor = default_color_dark;
    titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    
    switch (indexPath.row) {
        case InfoEditRowName: {
            [titleLabel setText:STRING(@"nickname")];
            [cell.contentView addSubview:_nameTextField];
            break;
        }
        case InfoEditRowRole: {
            [titleLabel setText:STRING(@"role")];
            [cell.contentView addSubview:_roleLabel];
            break;
        }
        case InfoEditRowAge: {
            [titleLabel setText:STRING(@"age")];
            [cell.contentView addSubview:_ageLabel];
            break;
        }
        case InfoEditRowCity: {
            [titleLabel setText:STRING(@"city")];
            [cell.contentView addSubview:_cityLabel];
            break;
        }
    }
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    return cell;
}
-(void)setInfoData:(NSDictionary *)infoData{
    if (infoData && infoData.allKeys.count > 0) {
        NaNaUserProfileModel *model = [[[NaNaUserProfileModel alloc] init] converJson:infoData];
        _nameTextField.text = model.userNickName;
        NSArray *roleArray = [[NSArray alloc] initWithObjects:@"P", @"T", @"H", nil];
        _roleLabel.text = roleArray[model.role];
        //_city.cityID = model.userCityID;
        _cityLabel.text = model.userCityName;
        _ageLabel.text = [self transformIntToAge:model.userBirthday];
        _voiceUrl = model.voiceURL;
        [_playButton setEnabled:[_voiceUrl isEqualToString:@""]?NO:YES];
        [_headButton setImageURL:[NSURL URLWithString:model.userAvatarURL]];
        [roleArray release];
    }
    
    _infoData = infoData;
    
}
-(NSString *)transformIntToAge:(NSString *)birthday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateBirthday = [formatter dateFromString:birthday];
    NSDate *dateNow = [NSDate date];
    NSTimeInterval timeNow = [dateNow timeIntervalSince1970];
    NSTimeInterval birthdayTime = [dateBirthday timeIntervalSince1970];
    int age = trunc((birthdayTime - timeNow) / (60 * 60 * 24)) / 365 * (-1);
    return  [NSString stringWithFormat:@"%d", age];
    
}
- (void)playTaSound:(UIButton *)sender{
    if (sender.tag == 1) {
        ULog(@"播放");
        [self showProgressWithText:@"声音加载中..."];
        [_playButton setImage:[UIImage imageNamed:@"btn_voice_stop"] forState:UIControlStateNormal];
        
        NSString *writeFileName = [NSString stringWithFormat:@"temp%@",@".caf"];
        NSString *fileDir = [NSString stringWithFormat:@"/Voice/"];
        [NaNaUIManagement createPath:fileDir];
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths objectAtIndex:0];
        _filePath = [NSString stringWithFormat:@"%@/%@%@",documentPath,fileDir,writeFileName];
        [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
        [[NaNaUIManagement sharedInstance] downLoadUserVoiceFile:_voiceUrl withFilePath:_filePath];
        sender.tag = 2;
    }else{
        ULog(@"停止");
        [_playButton setImage:[UIImage imageNamed:@"btn_voice_play"] forState:UIControlStateNormal];
        [_audioPlayer stop];
        sender.tag = 1;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_playButton setImage:[UIImage imageNamed:@"btn_voice_play"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    SAFERELEASE(_headButton)
    SAFERELEASE(_playButton)
    SAFERELEASE(_tableView)
    SAFERELEASE(_nameTextField)
    SAFERELEASE(_ageLabel)
    SAFERELEASE(_roleLabel)
    SAFERELEASE(_cityLabel)
    [super dealloc];
}

@end
