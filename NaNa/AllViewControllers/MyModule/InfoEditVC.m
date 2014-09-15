//
//  InfoEditVC.m
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "InfoEditVC.h"

#import "UserAgreementVC.h"
#import "HeadCartoonVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UCityVC.h"
#import "UAlertView.h"
#import "URequest.h"
#import "URequestManager.h"
#import "AppDelegate.h"
#import "NaNaUIManagement.h"
#import "NaNaUserProfileModel.h"
#define kInfoEditCellHeight         40.0
#define kInfoEditCellShowHeight     30.0
#define kInfoEditCellSildWidth      15.0
#define kInfoEditCellShowWidth      290.0
#define kInfoEditCellNumber         4
#define kInfoRecodingViewHeight     200.0

#define kInfoRecoderTimeKey @"kInfoRecoderTimeKey"

typedef enum {
    InfoEditRowName     = 0,
    InfoEditRowRole     = 1,
    InfoEditRowAge      = 2,
    InfoEditRowCity     = 3,
} InfoEditRow;

@implementation InfoEditVC
@synthesize headButton = _headButton;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userProfile"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].userProfile];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            self.infoData = [[NSDictionary alloc] initWithDictionary:[[tempData objectForKey:ASI_REQUEST_DATA] objectForKey:@"body"]];
            
        }else
        {

        }
    }else if([keyPath isEqualToString:@"updateUserProfile"])
    {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].updateUserProfile];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            
            [UAlertView showAlertViewWithMessage:@"修改成功" delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
            if (enterPathType == TYPE_LOGIN) {
                [APP_DELEGATE loadMainView];
            }else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else
        {
            
            [UAlertView showAlertViewWithMessage:tempData[@"errorMessage"] delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        }
    }
}
-(void)setInfoData:(NSDictionary *)infoData
{
    if (infoData && infoData.allKeys.count > 0) {
        NaNaUserProfileModel *model = [[[NaNaUserProfileModel alloc] init] converJson:infoData];
        _nameTextField.text = model.userNickName;
        _roleLabel.text = _roleArray[[infoData[@"role"] integerValue]];
        _city.cityID = model.userCityID;
        _city.cityName = model.userCityName;
        [_headButton setImageURL:[NSURL URLWithString:model.userAvatarURL]];
        
    }
    
    _infoData = infoData;

}
-(id)initWithType:(enterType)type
{
    self = [super init];
    if (self) {
        enterPathType = type;
    }
    return self;
}
- (void)loadView {
    [super loadView];
    self.title = STRING(@"info");
    _defaultView.backgroundColor = [UIColor whiteColor];
    
    [[NaNaUIManagement sharedInstance] getUserProfile:[NaNaUIManagement sharedInstance].userAccount.UserID];
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeNext];
    
    NSString *recordTime = [UStaticData getObjectForKey:kInfoRecoderTimeKey];
    if (recordTime && ![recordTime isEqualToString:@"00:00"])
    {
        _isExistRecord = YES;
    }
    else
    {
        _isExistRecord = NO;
    }
    // 头像
    if (!_headButton) {
        // 圆形按钮
        //_headButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 15.0, 110.0, 110.0)];
        _headButton = [[CircleImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"DefineHeader.png"] withFrame:CGRectMake(20.0, 15.0, 110.0, 110.0)];
        [_headButton setBackgroundImage:[UIImage imageNamed:@"head_bg.png"] forState:UIControlStateNormal];
        [_headButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_headButton addTarget:self
                        action:@selector(uRoundButtonTouchUpInside)
              forControlEvents:UIControlEventTouchUpInside];
        _headButton.layer.cornerRadius = 55;
        _headButton.clipsToBounds = YES;
    }
    [_defaultView addSubview:_headButton];
    
    
    // 录音时间
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = CGRectMake(180.0, 20.0, 60.0, 25.0);
        _timeLabel.textColor = default_color_dark;
        _timeLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    _timeLabel.text = recordTime.length ? recordTime :@"";
    _timeLabel.hidden = !_isExistRecord;
    [_defaultView addSubview:_timeLabel];
    
    // 录音图标
    if (!_recordImageView) {
        _recordImageView = [[UIButton alloc] init];
        [_recordImageView setBackgroundImage:[UIImage imageNamed:@"speaker.png"] forState:UIControlStateNormal];
        _recordImageView.frame = CGRectMake(240.0, 15.0, 30.0, 30.0);
        [_recordImageView addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
    _recordImageView.hidden = !_isExistRecord;
    [_defaultView addSubview:_recordImageView];
    
    NSString *normalBagNa = _isExistRecord ? @"record_btn.png" : @"record_light blue_btn_lan.png";
    NSString *touchDownBagNa = @"record_light blue_btn_lan.png";
    // 录音按钮
    if (!_recordButton) {
        _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(180.0, 50.0, 100.0, 30.0)];
        _recordButton.backgroundColor = [UIColor clearColor];
        _recordButton.layer.cornerRadius = 5;
        _recordButton.tag = 0xfc;
        [_recordButton setBackgroundImage:[UIImage imageNamed:normalBagNa]
                                  forState:UIControlStateNormal];
        [_recordButton setBackgroundImage:[UIImage imageNamed:touchDownBagNa]
                                  forState:UIControlStateHighlighted];
        [_recordButton addTarget:self action:@selector(beginRecord:) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchCancel];

    }
    [_defaultView addSubview:_recordButton];
    
    NSString *normalTitle = _isExistRecord ? @"按住重录":@"按住录音";
    // 录音按钮上的文案
    if (!_recordButtonLabel) {
        _recordButtonLabel = [[UILabel alloc] init];
        _recordButtonLabel.frame = CGRectMake(_recordButton.frame.origin.x + margin_small,
                                              _recordButton.frame.origin.y,
                                              _recordButton.frame.size.width - 40,
                                              _recordButton.frame.size.height);
        _recordButtonLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _recordButtonLabel.backgroundColor = [UIColor clearColor];
        _recordButtonLabel.textColor = default_color_white;
        _recordButtonLabel.text = normalTitle;
        _recordButtonLabel.textAlignment = NSTextAlignmentCenter;
    }
    [_defaultView addSubview:_recordButtonLabel];
    
    // 录音按钮上的图标
    if (!_recordButtonImageView) {
        _recordButtonImageView = [[UIImageView alloc] init];
        _recordButtonImageView.image = [UIImage imageNamed:@"record.png"];
        _recordButtonImageView.frame = CGRectMake(_recordButtonLabel.frame.origin.x + _recordButtonLabel.frame.size.width + margin_small,
                                                  _recordButtonLabel.frame.origin.y + 4.0,
                                                  25.0, 25.0);
    }
    [_defaultView addSubview:_recordButtonImageView];
    
    // 录音下面的备注文案
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.frame = CGRectMake(_recordButton.frame.origin.x,
                                        _recordButton.frame.origin.y + _recordButton.frame.size.height + margin_micro,
                                        _recordButton.frame.size.width, 45);
        _remarkLabel.textColor = default_color_dark;
        _remarkLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _remarkLabel.backgroundColor = [UIColor clearColor];
        _remarkLabel.text = STRING(@"recordRemark");
        _remarkLabel.numberOfLines = 2;
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
    }
    [_defaultView addSubview:_remarkLabel];
    
    
    // 填充资料的tableView
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,
                                                                   _headButton.frame.origin.y * 2 + _headButton.frame.size.height,
                                                                   self.defaultView.frame.size.width,
                                                                   kInfoEditCellHeight * kInfoEditCellNumber)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
    }
    [_defaultView addSubview:_tableView];
    
    // 修改内容 for cell -------------------------------------------------------------------
    // 计算Cell内变动文字的坐标
    CGRect cellFrame = CGRectMake(70.0, 0.0, 200.0, kInfoEditCellShowHeight);
    
    // nikeName
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.frame = cellFrame;
        _nameTextField.backgroundColor = [UIColor clearColor];
        _nameTextField.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameTextField.placeholder = STRING(@"nikeName");
        _nameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        _nameTextField.delegate = self;
        _nameTextField.returnKeyType = UIReturnKeyDone;
    }
    
    // 角色picker里的数据
    if (!_roleArray) {
        _roleArray = [[NSArray alloc] initWithObjects:@"P", @"T", @"H", nil];
    }
    
    // role
    if (!_roleLabel) {
        _roleLabel = [[UILabel alloc] init];
        _roleLabel.frame = cellFrame;
        _roleLabel.textColor = default_color_dark;
        _roleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _roleLabel.backgroundColor = [UIColor clearColor];
        _roleLabel.text = _roleArray[0];
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
    
    // _birthday
    _birthday = [[NSMutableString alloc] initWithString:@""];
    
    // city
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.frame = cellFrame;
        _cityLabel.textColor = default_color_dark;
        _cityLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.text = STRING(@"city");
    }
    
    if (!_city) {
        _city = [[UCity alloc] init];
        _city.cityName = @"";
        _city.cityID = 0;
    }
    
    // 用户协议组件 --------------------------------------------------------------------------------
    // 是否显示用户协议
    _showAgree = NO;
    
    // 是否同意用户协议
    _isAgree = YES;
    
    // 是否同意用户协议的按钮
    if (!_agreeCheckButton) {
        _agreeCheckButton = [[UIButton alloc] init];
        _agreeCheckButton.frame = CGRectMake(kInfoEditCellSildWidth,
                                             _tableView.frame.origin.y + _tableView.frame.size.height + margin_middle,
                                             25.0, 25.0);
        _agreeCheckButton.backgroundColor = [UIColor clearColor];
        [_agreeCheckButton setBackgroundImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
        [_agreeCheckButton setBackgroundImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateHighlighted];
        [_agreeCheckButton addTarget:self
                          action:@selector(agreeCheckButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    //[_defaultView addSubview:_agreeCheckButton];
    
    // 同意用户协议文案
    if (!_agreeLabel) {
        _agreeLabel = [[TTTAttributedLabel alloc] init];
        _agreeLabel.frame = CGRectMake(_agreeCheckButton.frame.origin.x + _agreeCheckButton.frame.size.width + margin_small,
                                       _agreeCheckButton.frame.origin.y,
                                       _defaultView.frame.size.width - (_ageLabel.frame.origin.x),
                                       _agreeCheckButton.frame.size.height);
        _agreeLabel.userInteractionEnabled = NO;
        _agreeLabel.backgroundColor = [UIColor clearColor];
        _agreeLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _agreeLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        [_agreeLabel setText:STRING(@"isAgreement") afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange blackRange = NSMakeRange(0, 6);
            NSRange orangeRange = NSMakeRange(6, 4);
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)default_color_dark range:blackRange];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)default_color_orange range:orangeRange];
            return mutableAttributedString;
        }];
    }
    //[_defaultView addSubview:_agreeLabel];
    
    // 进入用户协议按钮
    if (!_agreeButton) {
        _agreeButton = [[UIButton alloc] init];
        _agreeButton.frame = CGRectMake(_agreeLabel.frame.origin.x + 80,
                                        _agreeLabel.frame.origin.y,
                                        65,
                                        _agreeLabel.frame.size.height);
        _agreeButton.backgroundColor = [UIColor clearColor];
        [_agreeButton addTarget:self
                         action:@selector(agreeButtonClick:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    //[_defaultView addSubview:_agreeButton];
    
    // 更改角色、更改年龄的picker -------------------------------------------------------------------
    // 角色的底部VIEW
    if (!_roleBottomView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UBottomView" owner:self options:nil];
        _roleBottomView = [[nib lastObject] retain];
        _roleBottomView.backgroundColor = [UIColor whiteColor];
        _roleBottomView.frame = CGRectMake(0.0,
                                           CGRectGetHeight(self.view.frame),
                                           CGRectGetWidth(_roleBottomView.frame),
                                           CGRectGetHeight(_roleBottomView.frame)-1);
        
        [_roleBottomView.finishButton addTarget:self
                                         action:@selector(roleFinishButtonPressed:)
                               forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_roleBottomView];
    
    // 修改角色picker
    if (!_rolePickerView) {
        _rolePickerView = [[UIPickerView alloc] init];
        _rolePickerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _rolePickerView.frame = CGRectMake(0.0, CGRectGetHeight(_roleBottomView.frame) - pickerViewHeight,
                                           pickerViewWidth, pickerViewHeight);
         _rolePickerView.showsSelectionIndicator = YES;
        _rolePickerView.dataSource = self;
        _rolePickerView.delegate = self;
    }
    [_roleBottomView addSubview:_rolePickerView];
    
    // 年龄的底部View
    if (!_ageBottomView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UBottomView" owner:self options:nil];
        _ageBottomView = [[nib lastObject] retain];
        _ageBottomView.backgroundColor = [UIColor whiteColor];
        _ageBottomView.frame = CGRectMake(0.0,
                                          CGRectGetHeight(self.view.frame),
                                          CGRectGetWidth(_ageBottomView.frame),
                                          CGRectGetHeight(_ageBottomView.frame)-1);
        [_ageBottomView.finishButton addTarget:self
                                        action:@selector(ageFinishButtonPressed:)
                               forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_ageBottomView];
    
    // 修改年龄的picker
    if (!_ageDatePicker) {
        _ageDatePicker = [[UIDatePicker alloc] init];
        _ageDatePicker.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _ageDatePicker.frame = CGRectMake(0.0, CGRectGetHeight(_ageBottomView.frame) - pickerViewHeight,
                                          pickerViewWidth, pickerViewHeight);
        _ageDatePicker.datePickerMode = UIDatePickerModeDate;
        [_ageDatePicker setAccessibilityLanguage:@"cn-China"];  //设置时间选取器的语言
        [_ageDatePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];  // 设置时区
        [_ageDatePicker setDate:[NSDate date] animated:YES];    // 设置当前显示时间
        [_ageDatePicker setMaximumDate:[NSDate date]];  // 设置显示最大时间（此处为当前时间）
        [_ageDatePicker setDatePickerMode:UIDatePickerModeDate];    // 设置UIDatePicker的显示模式
        [_ageDatePicker addTarget:self
                           action:@selector(agePickerValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
        
        // 设置生日参数
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [_birthday setString:[dateFormatter stringFromDate:[NSDate date]]];
        ULog(@"_birthday ======= %@", _birthday);
        [dateFormatter release];
    }
    [_ageBottomView addSubview:_ageDatePicker];
    

    
    // 修改头像的菜单视图
    if (!_photoMenuView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoMenuView" owner:self options:nil];
        _photoMenuView = [[nib lastObject] retain];
        
        _photoMenuHideRect = CGRectMake(0.0,
                                        self.view.frame.size.height,
                                        self.view.frame.size.width,
                                        _photoMenuView.frame.size.height);
        _photoMenuShowRect = CGRectMake(0.0,
                                        self.view.frame.size.height - _photoMenuView.frame.size.height,
                                        _photoMenuView.frame.size.width,
                                        _photoMenuView.frame.size.height);
        _photoMenuView.frame = _photoMenuHideRect;
        _photoMenuView.photoMenuDelegate = self;
    }
    [self.view addSubview:_photoMenuView];
    
    // 录音中图片
    if (!_recordingView) {
        _recordingView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-kInfoRecodingViewHeight)/2,
                                                                  (CGRectGetHeight(_defaultView.frame)-kInfoRecodingViewHeight)/2,
                                                                  kInfoRecodingViewHeight,
                                                                  kInfoRecodingViewHeight)];
        _recordingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _recordingView.layer.cornerRadius = 10;
        UIImageView *record = [[UIImageView alloc] initWithFrame:CGRectMake(75, 65, 50, 50)];
        record.image = [UIImage imageNamed:@"record.png"];
        [_recordingView addSubview:record];
        [record release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 115, 200, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"录音中...";
        [_recordingView addSubview:label];
        [label release];
    }
    
    // 城市
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uGetCityFinishedNotify:)
                                                 name:UGetSelectedCityFinishedNotify
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"userProfile" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"updateUserProfile" options:0 context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"userProfile"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"updateUserProfile"];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    ULog(@"audioRecorderDidFinishRecording successfully flag = %d",flag);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    ULog(@"audioPlayerDidFinishPlaying successfully flag = %d",flag);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    SAFERELEASE(_headButton)
    SAFERELEASE(_timeLabel)
    SAFERELEASE(_recordImageView)
    SAFERELEASE(_recordButton)
    SAFERELEASE(_recordButtonLabel)
    SAFERELEASE(_recordButtonImageView)
    SAFERELEASE(_remarkLabel)
    SAFERELEASE(_tableView)
    SAFERELEASE(_infoArray)
    
    SAFERELEASE(_nameTextField)
    SAFERELEASE(_ageLabel)
    SAFERELEASE(_birthday)
    SAFERELEASE(_roleLabel)
    SAFERELEASE(_cityLabel)
    SAFERELEASE(_city)
    
    SAFERELEASE(_agreeCheckButton)
    SAFERELEASE(_agreeLabel)
    SAFERELEASE(_agreeButton)
    
    SAFERELEASE(_roleBottomView)
    SAFERELEASE(_rolePickerView)
    SAFERELEASE(_ageBottomView)
    SAFERELEASE(_ageDatePicker)
    SAFERELEASE(_roleArray)
    
    SAFERELEASE(_photoMenuView)
    SAFERELEASE(_recordingView)
    SAFERELEASE(_audioPlayer)
    SAFERELEASE(_recorder)
    
    SAFERELEASE(_infoData)
    [super dealloc];
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
    UIImageView *bgImageView = [[[UIImageView alloc] init] autorelease];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.frame = CGRectMake(kInfoEditCellSildWidth, 0.0, kInfoEditCellShowWidth, kInfoEditCellShowHeight);
    bgImageView.image = [UIImage imageNamed:@"info_cell_bg_normal.png"];
    [cell.contentView addSubview:bgImageView];
    bgImageView.highlightedImage = [UIImage imageNamed:@"info_cell_bg_selected.png"];
    
    
    // 名称
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.frame = CGRectMake(30.0, 0.0, 30.0, kInfoEditCellShowHeight);
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
            [titleLabel setText:STRING(@"infoCity")];
            [cell.contentView addSubview:_cityLabel];
            break;
        }
    }
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    // 箭头
    if (indexPath.row != 0) {
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        arrow.frame = CGRectMake(_nameTextField.frame.origin.x + _nameTextField.frame.size.width + margin_small,
                                 (kInfoEditCellShowHeight - 14.0) / 2,
                                 14.0, 14.0);
        
        [cell.contentView addSubview:arrow];
        [arrow release];
    }
     NSString *urlStr = @"aaa";
    NSString *unicodeStr = [NSString stringWithCString:[urlStr UTF8String] encoding:NSUnicodeStringEncoding];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kInfoEditCellHeight;
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case InfoEditRowName: {
            ULog(@"nickname");
            
            break;
        }
        case InfoEditRowRole: {
            ULog(@"role");
            [self textFieldResignFirstResponder];
            _defaultView.userInteractionEnabled = NO;
            [UIView animateWithDuration:default_duration
                             animations:^{
                                 _roleBottomView.frame = CGRectMake(_roleBottomView.frame.origin.x,
                                                                    CGRectGetHeight(self.view.frame) - CGRectGetHeight(_roleBottomView.frame),
                                                                    CGRectGetWidth(_roleBottomView.frame),
                                                                    CGRectGetHeight(_roleBottomView.frame));
                             }];
            break;
        }
        case InfoEditRowAge: {
            ULog(@"age");
            [self textFieldResignFirstResponder];
            _defaultView.userInteractionEnabled = NO;
            [UIView animateWithDuration:default_duration
                             animations:^{
                                 _ageBottomView.frame = CGRectMake(_roleBottomView.frame.origin.x,
                                                                   CGRectGetHeight(self.view.frame) - CGRectGetHeight(_ageBottomView.frame),
                                                                   CGRectGetWidth(_ageBottomView.frame),
                                                                   CGRectGetHeight(_ageBottomView.frame));
                             }];
            break;
        }
        case InfoEditRowCity: {
            ULog(@"city");
            [self textFieldResignFirstResponder];
            
            // select city
            UCityVC * uCityVC = [[UCityVC alloc] init];
            [self.navigationController pushViewController:uCityVC animated:YES];
            [uCityVC release];
            break;
        }
    }
}

#pragma mark - UITextFieldDelegate
// 点背景时收加键盘
- (void)textFieldResignFirstResponder {
    if (_nameTextField.becomeFirstResponder) {
        [_nameTextField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark UIPickerView Data Methods
// 返回当前列显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    // 角色picker
	return 1;
}

// 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // 角色picker
    return [_roleArray count];
}


#pragma mark UIPickerView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // 角色picker
    return [_roleArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _roleLabel.text = [_roleArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 250;
}

#pragma mark - UIDatePicker
- (void)agePickerValueChanged:(UIDatePicker *)picker {
    // 计算年龄
    NSTimeInterval selectDate = [picker.date timeIntervalSinceNow];
    int age = trunc(selectDate / (60 * 60 * 24)) / 365 * (-1);
    _ageLabel.text = [NSString stringWithFormat:@"%d", age];
    ULog(@"agePickerValueChanged ========= %d", age);
}


// 手势操作会截取UITableView里的touch事件，因此需要重写此方法来处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
   if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) { //如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}

#pragma mark - HeadCartoonDelegate
- (void)currentHeadImage:(NSString *)headName {
    [[NaNaUIManagement sharedInstance] uploadFile:UIImageJPEGRepresentation([UIImage imageNamed:headName], 1.f) withUploadType:UploadAvatar withUserID:[self getAccountValueByKey:ACCOUNT_INFO_TYPE_USERID] withDesc:@""];
    [_headButton setBackgroundImage:[UIImage imageNamed:headName]
                           forState:UIControlStateNormal];
}

- (void)albumButtonPressed:(UIButton *)btn {
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuHideRect;
                     }
                     completion:^(BOOL finished) {
                         _defaultView.userInteractionEnabled = YES;
                         
                         if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                             
                             UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                             picker.delegate = self;
                             picker.allowsEditing = YES;
                             picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                             [self presentViewController:picker animated:YES completion:nil];
                             [picker release];
                         }
                     }];
}

- (void)photoButtonPressed:(UIButton *)btn {
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuHideRect;
                     }
                     completion:^(BOOL finished) {
                         _defaultView.userInteractionEnabled = YES;
                         
                         if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                             
                             UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                             picker.delegate = self;
                             picker.allowsEditing = YES;
                             picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                             [self presentViewController:picker animated:YES completion:nil];
                             [picker release];
                         }
                     }];
}

- (void)cartoonButtonPressed:(UIButton *)btn {
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuHideRect;
                     }
                     completion:^(BOOL finished) {
                         _defaultView.userInteractionEnabled = YES;
                         
                         HeadCartoonVC *controller = [[HeadCartoonVC alloc] init];
                         controller.headCartoonDelegate = self;
                         [self.navigationController pushViewController:controller animated:YES];
                         [controller release];
                     }];
}

- (void)cancelButtonPressed:(UIButton *)btn {
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuHideRect;
                     }
                     completion:^(BOOL finished) {
                         _defaultView.userInteractionEnabled = YES;
                     }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
    [_headButton setBackgroundImage:image forState:UIControlStateNormal];
    [[NaNaUIManagement sharedInstance] uploadFile:UIImageJPEGRepresentation(image, 0.5) withUploadType:UploadAvatar withUserID:[NaNaUIManagement sharedInstance].userAccount.UserID withDesc:@""];
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - city
- (void)uGetCityFinishedNotify:(NSNotification *)notify {
    if([notify object]) {
        _city = [notify object];
        _cityLabel.text = _city.cityName;
        ULog(@"City.CityID is %d", _city.cityID);
        ULog(@"City.CityName is %@", _city.cityName);
    }
}

#pragma mark - Resquest
- (void)requestFinished:(URequest *)request {
    ULog(@"requestFinished ------- %@", request.parsedDict);
    if (request.isError) {
        [self requestFailed:request];
        return;
    }

    [UAlertView showAlertViewWithMessage:@"修改成功" delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
    if (enterPathType == TYPE_LOGIN) {
        [APP_DELEGATE loadMainView];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)requestFailed:(URequest *)request {
    
    [UAlertView showAlertViewWithMessage:[[request.parsedDict objectForKey:@"header"] objectForKey:@"message"] delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
}

#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    if (enterPathType == TYPE_LOGIN) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)rightItemPressed:(UIButton *)btn {
    // 判断昵称是否填写
    if ([_nameTextField.text length] == 0) {
        // 未填写昵称，Alert报错
        [UAlertView showAlertViewWithMessage:@"昵称不能为空"
                                    delegate:nil
                                cancelButton:@"确定"
                               defaultButton:nil];
        return;
    }
    
    // 判断角色选择的项目
    int roleInt = 0;
    for (int i=0; i<[_roleArray count]; i++) {
        if ([_roleLabel.text isEqualToString:[_roleArray objectAtIndex:i]]) {
            roleInt = i;
            break;
        }
    }
    
    // 判断城市是否选择
    int cityId = _city.cityID;
    if (_city.cityID == 0 && [_city.cityName isEqualToString:@""]) {
        // 城市未选择，Alert报错
        [UAlertView showAlertViewWithMessage:@"请选择城市" delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        return;
    }
    
    //判断用户协议是否勾选
    if (!_isAgree) {
        [UAlertView showAlertViewWithMessage:@"请勾选已阅读并同意用户协议" delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        return;
    }

    
    
    /*
    // 提交request请求

    
    NSString *param = [NSString stringWithFormat:@"userId=%d&nickname=%@&role=%d&birthday=%@&city_id=%d", [NaNaUIManagement sharedInstance].userAccount.UserID,_nameTextField.text, roleInt, _birthday, cityId];
    URequest *request = [[URequest alloc] initWithDomain:K_DOMAIN_NANA
                                                withPath:k_URL_USER_UPDATE_INFO
                                               withParam:param];
    request.allowedAlert = NO;
    request.allowedToast = NO;
    request.delegate = self;
    [URequestManager addCommonRequest:request];
    [request release];
     */
    
    [[NaNaUIManagement sharedInstance] updateUserProfile:_nameTextField.text withRole:_roleLabel.text withCityID:cityId];
}

- (NSString *)getMinutes:(double)second
{
    double m = 0; NSInteger s = 0; NSString *sStr = @"00"; NSString *mStr = @"00";
    if (second > 0)
    {
        m = second/60.0;
        s = (int)second%60;
    }
    if (s > 0 && s < 10)
    {
        sStr = [NSString stringWithFormat:@"0%d",s];
    }
    else if(s >= 10)
    {
        sStr = [NSString stringWithFormat:@"%d",s];
    }
    
    if (m > 0 && m < 10)
    {
        mStr = [NSString stringWithFormat:@"0%.f",m];
    }
    else if(m >= 10)
    {
        mStr = [NSString stringWithFormat:@"%.f",m];
    }
    return [NSString stringWithFormat:@"%@:%@",mStr,sStr];
}

- (void)playRecord:(UIButton *)btn
{
    [_audioPlayer release];
    _audioPlayer = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSURL *url = [NSURL fileURLWithPath: [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.%@",@"record_NaNa",@"caf"]]];
    NSError *audioPlayerError = nil;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&audioPlayerError];
    _audioPlayer.numberOfLoops = 0;
    _audioPlayer.volume = 1.0f;
    _audioPlayer.delegate = self;
    if (_audioPlayer.prepareToPlay)
    {
        [_audioPlayer play];
         ULog(@"playing");
    }
    else
    {
        int errorCode = CFSwapInt32HostToBig ([audioPlayerError code]);
        ULog(@"Error: %@ [%4.4s])" , [audioPlayerError localizedDescription], (char*)&errorCode);
    }
}

- (void)endRecord:(UIButton *)btn {
    ULog(@"currentTime = %.f",_recorder.currentTime);
    [_recordingView removeFromSuperview];
    NSString *time = [self getMinutes:_recorder.currentTime];
    if (![time isEqualToString:@"00:00"])
    {
        _isExistRecord = YES;
    }
    else
    {
        _isExistRecord = NO;
    }
    [UStaticData saveObject:time forKey:kInfoRecoderTimeKey];
    _timeLabel.text = time;
    NSString *normalTitle = _isExistRecord ? @"按住重录":@"按住录音";
    _recordButtonLabel.text = normalTitle;
    _recordImageView.hidden = !_isExistRecord;
    _timeLabel.hidden = !_isExistRecord;
    NSString *normalBagNa = _isExistRecord ? @"record_btn.png" : @"record_light blue_btn_lan.png";
    [btn setBackgroundImage:[[UIImage imageNamed:normalBagNa] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [_recorder stop];
}

- (void)beginRecord:(UIButton *)btn
{
    _recordButtonLabel.text = @"松开完成";
    [_recorder release];
    _recorder = nil;
    
    NSError *audioSessionError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&audioSessionError];
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];//ID
    [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];//采样率
    [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];//通道的数目,1单声道,2立体声
    [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];//解码率
    [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];//采样位
    [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    NSURL *url = [NSURL fileURLWithPath: [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.%@",@"record_NaNa",@"caf"]]];
    NSError *audioRecorderError = nil;
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&audioRecorderError];
    _recorder.delegate = self;
    if ([_recorder prepareToRecord])
    {
        [_recorder record];
        [_defaultView addSubview:_recordingView];
        ULog(@"recording");
    }else
    {
        int errorCode = CFSwapInt32HostToBig ([audioRecorderError code]);
        ULog(@"Error: %@ [%4.4s])" , [audioRecorderError localizedDescription], (char*)&errorCode);
    }
}

- (void)agreeCheckButtonClick:(UIButton *)btn {
    _isAgree = !_isAgree;
    if (_isAgree) {
        // 同意
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateHighlighted];
        
    } else {
        // 不同意
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateHighlighted];
    }
}

- (void)agreeButtonClick:(UIButton *)btn {
    ULog(@"agreeButtonClick");
    UserAgreementVC *controller = [[[UserAgreementVC alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)uRoundButtonTouchUpInside {
    _defaultView.userInteractionEnabled = NO;
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _photoMenuView.frame = _photoMenuShowRect;
                     }];
}

- (void)roleFinishButtonPressed:(UIButton *)btn {
    ULog(@"roleFinishButtonPressed");
    _defaultView.userInteractionEnabled = NO;
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _roleBottomView.frame = CGRectMake(_roleBottomView.frame.origin.x,
                                                           CGRectGetHeight(self.view.frame),
                                                           CGRectGetWidth(_roleBottomView.frame),
                                                           CGRectGetHeight(_roleBottomView.frame));
                     }
                     completion:^(BOOL finished){
                         _defaultView.userInteractionEnabled = YES;
                     }];
}

- (void)ageFinishButtonPressed:(UIButton *)btn {
    ULog(@"ageFinishButtonPressed");
    _defaultView.userInteractionEnabled = NO;
    [UIView animateWithDuration:default_duration
                     animations:^{
                         _ageBottomView.frame = CGRectMake(_ageBottomView.frame.origin.x,
                                                           CGRectGetHeight(self.view.frame),
                                                           CGRectGetWidth(_ageBottomView.frame),
                                                           CGRectGetHeight(_ageBottomView.frame));
                     }
                     completion:^(BOOL finished){
                         _defaultView.userInteractionEnabled = YES;
                     }];
}
@end
