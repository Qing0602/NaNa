//
//  SetPrivateVC.m
//  NaNa
//
//  Created by dengfang on 12/8/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "SetPrivateVC.h"

@implementation SetPrivateVC
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userPrivacySetting"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].userPrivacySetting];
        if (![[tempData objectForKey:Http_Has_Error_Key] boolValue]) {
            NSDictionary *data = tempData[@"data"];
            _photoSwitch.on = [data[@"show_avata"] boolValue];
            _infoSwitch.on = [data[@"show_info"] boolValue];
        }else
        {
            
        }
    }else if ([keyPath isEqualToString:@"updateUserPrivacySetting"])
    {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].updateUserPrivacySetting];
        if (![[tempData objectForKey:Http_Has_Error_Key] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            NSLog(@"error == %@",tempData[@"errorMessage"]);
        }
    }
}
- (void)loadView {
    [super loadView];
    self.title = STRING(@"private");
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetWidth(self.navBarView.frame) - 60, 7, 60, 30);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:btn];
    
    float offsetX = 15.0;
    float offsetY = 20.0;
    float offsetW = 290.0;
    float offsetH = 95.0;
    
    // 文字背景
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(offsetX, offsetY, offsetW, offsetH);
    bgImageView.image = [UIImage imageNamed:@"bg_line2.png"];
    [_defaultView addSubview:bgImageView];
    
    offsetX = 25.0;
    offsetW = 230.0;
    offsetH = 40.0;
    
    // 照片对陌生人开放
    UILabel *photoLabel = [[UILabel alloc] init];
    photoLabel.frame = CGRectMake(offsetX, offsetY, offsetW, offsetH);
    photoLabel.backgroundColor = [UIColor clearColor];
    photoLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    photoLabel.textColor = default_color_deep_dark;
    photoLabel.text = @"照片对陌生人开放";
    [_defaultView addSubview:photoLabel];
    
    // 资料对陌生人开放（录音、标签、你问我答等）
    offsetY = offsetY + offsetH + 10.0;
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.frame = CGRectMake(offsetX, offsetY, offsetW, offsetH);
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    infoLabel.textColor = default_color_deep_dark;
    infoLabel.text = @"资料对陌生人开放";
    infoLabel.frame = [infoLabel textRectForBounds:infoLabel.frame limitedToNumberOfLines:0];
    [_defaultView addSubview:infoLabel];
    
    offsetH = infoLabel.frame.size.height;
    offsetY += offsetH;
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.frame = CGRectMake(offsetX, offsetY, offsetW, offsetH);
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont boldSystemFontOfSize:default_font_size_12];
    detailLabel.textColor = default_color_dark;
    detailLabel.text = @"录音、标签、你问我答等";
    detailLabel.frame = [detailLabel textRectForBounds:detailLabel.frame limitedToNumberOfLines:0];
    [_defaultView addSubview:detailLabel];
    
    
    // 未开放的隐私，陌生人需要钥匙才能打开
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.frame = CGRectMake(0.0, bgImageView.frame.origin.y + bgImageView.frame.size.height + 10.0,
                                _defaultView.frame.size.width, 30.0);
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    msgLabel.textColor = default_color_deep_dark;
    msgLabel.text = @"未开放的隐私，陌生人需要钥匙才能打开";
    msgLabel.textAlignment = UITextAlignmentCenter;
    [_defaultView addSubview:msgLabel];
    
    
    // 照片开关
    offsetX = 220.0;
    if (!_photoSwitch) {
        _photoSwitch = [[UISwitch alloc] init];
        _photoSwitch.frame = CGRectMake(offsetX, bgImageView.frame.origin.y + 6, 10, 10);
        [_photoSwitch addTarget:self action:@selector(photoSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_defaultView addSubview:_photoSwitch];
    
    // 资料开关
    if (!_infoSwitch) {
        _infoSwitch = [[UISwitch alloc] init];
        _infoSwitch.frame = CGRectMake(offsetX, bgImageView.frame.origin.y + 53.0, 10, 10);
        [_infoSwitch addTarget:self action:@selector(infoSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_defaultView addSubview:_infoSwitch];
    
    [[NaNaUIManagement sharedInstance] getUserPrivacySetting];
    
    // 内存释放
    [bgImageView release];
    [photoLabel release];
    [infoLabel release];
    [detailLabel release];
    [msgLabel release];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"userPrivacySetting" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"updateUserPrivacySetting" options:0 context:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"userPrivacySetting"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"updateUserPrivacySetting"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    SAFERELEASE(_photoSwitch)
    SAFERELEASE(_infoSwitch)
    [super dealloc];
}

#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)completeAction
{
    
    
    [[NaNaUIManagement sharedInstance] updateUserPrivacySetting:_photoSwitch.on withIsShowUserInfo:_infoSwitch.on withIsShowUserAvatar:YES withIsShowVoice:YES];
}
#pragma mark - SwitchClick
- (void)photoSwitchClick:(UISwitch *)theSwitch {
    ULog(@"photoSwitchClick ======= %d", theSwitch.on);
}

- (void)infoSwitchClick:(UISwitch *)theSwitch {
    ULog(@"infoSwitchClick ======= %d", theSwitch.on);
}

@end
