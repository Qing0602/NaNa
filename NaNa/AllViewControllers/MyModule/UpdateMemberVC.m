//
//  UpdateMemberVC.m
//  NaNa
//
//  Created by dengfang on 13-9-15.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "UpdateMemberVC.h"
#import "UAlertView.h"
@interface UpdateMemberVC ()

@end

@implementation UpdateMemberVC
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userProfile"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].userProfile];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[tempData objectForKey:ASI_REQUEST_DATA]];
            _userNameLabel.text = dic[@"nickname"];
        }else
        {
            
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"userProfile" options:0 context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"userProfile"];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.title = STRING(@"updateMember");
    [[NaNaUIManagement sharedInstance] getUserProfile:[NaNaUIManagement sharedInstance].userAccount.UserID];
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    // 用户名称
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.frame = CGRectMake(25.0, 25.0, screenWidth - 25 * 2, 30.0);
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        //_userNameLabel.text = [NaNaUIManagement sharedInstance].userAccount.NaNaID;
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    [_defaultView addSubview:_userNameLabel];
    
    // 积分
    UIImageView *scoreBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_cell_bg_normal.png"]];
    scoreBg.frame = CGRectMake(15.0, _userNameLabel.frame.origin.y + _userNameLabel.frame.size.height + 10,
                               screenWidth - 15 * 2, 30.0);
    [_defaultView addSubview:scoreBg];
    
    
    UILabel *scoreTitleLabel = [[UILabel alloc] init];
    scoreTitleLabel.frame = CGRectMake(scoreBg.frame.origin.x + 10,
                                       scoreBg.frame.origin.y,
                                       30.0,
                                       scoreBg.frame.size.height);
    scoreTitleLabel.backgroundColor = [UIColor clearColor];
    scoreTitleLabel.text = STRING(@"score");
    scoreTitleLabel.textColor = default_color_dark;
    scoreTitleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    scoreTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_defaultView addSubview:scoreTitleLabel];
    
    
    float tmpX = scoreTitleLabel.frame.origin.x + scoreTitleLabel.frame.size.width + 10;
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.frame = CGRectMake(tmpX,
                                       scoreBg.frame.origin.y,
                                       scoreBg.frame.size.width - tmpX,
                                       scoreBg.frame.size.height);
        _scoreLabel.textColor = default_color_dark;
        _scoreLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.text = @"10000";
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
    }
    [_defaultView addSubview:_scoreLabel];
    
    // 魅力值
    UIImageView *charmBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_cell_bg_normal.png"]];
    charmBg.frame = CGRectMake(scoreBg.frame.origin.x, scoreBg.frame.origin.y + scoreBg.frame.size.height + 10,
                               scoreBg.frame.size.width, scoreBg.frame.size.height);
    [_defaultView addSubview:charmBg];
    
    
    UILabel *charmTitleLabel = [[UILabel alloc] init];
    charmTitleLabel.frame = CGRectMake(charmBg.frame.origin.x + 10,
                                       charmBg.frame.origin.y,
                                       30.0,
                                       charmBg.frame.size.height);
    charmTitleLabel.backgroundColor = [UIColor clearColor];
    charmTitleLabel.text = STRING(@"charm");
    charmTitleLabel.textColor = default_color_dark;
    charmTitleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    charmTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_defaultView addSubview:charmTitleLabel];
    
    
    if (!_charmLabel) {
        _charmLabel = [[UILabel alloc] init];
        _charmLabel.frame = CGRectMake(tmpX,
                                       charmBg.frame.origin.y,
                                       charmBg.frame.size.width - tmpX,
                                       charmBg.frame.size.height);
        _charmLabel.textColor = default_color_dark;
        _charmLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _charmLabel.backgroundColor = [UIColor clearColor];
        _charmLabel.text = @"20000";
        _charmLabel.textAlignment = NSTextAlignmentLeft;
    }
    [_defaultView addSubview:_charmLabel];
    
    
    UILabel *cueLabel = [[UILabel alloc] init];
    cueLabel.frame = CGRectMake(0.0, charmBg.frame.origin.y + charmBg.frame.size.height + 25,
                                _defaultView.frame.size.width, 30);
    cueLabel.textColor = default_color_dark;
    cueLabel.font = [UIFont boldSystemFontOfSize:14];
    cueLabel.backgroundColor = [UIColor clearColor];
    cueLabel.text = STRING(@"updateCue");
    cueLabel.textAlignment = NSTextAlignmentCenter;
    [_defaultView addSubview:cueLabel];
    
    // 立即开通按钮
    if (!_okButton) {
        _okButton = [[UIButton alloc] init];
        _okButton.frame = CGRectMake(40.0,
                                     cueLabel.frame.origin.y + cueLabel.frame.size.height + 6,
                                     240.0, 40.0);
        _okButton.backgroundColor = [UIColor clearColor];
        [_okButton setBackgroundColor:[UIColor blackColor]];
        [_okButton setTitle:STRING(@"immediatelyUpdate") forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_18];
        _okButton.layer.cornerRadius = 5;
        _okButton.layer.borderWidth = 1;
        _okButton.clipsToBounds = YES;
        [_okButton addTarget:self
                      action:@selector(okButtonClick:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    [_defaultView addSubview:_okButton];
    
//    changeButton.frame = CGRectMake(40.0f, line1.frame.origin.y + 20.0f, 240.0f, 40.0f);
//    [changeButton setBackgroundColor:[UIColor blackColor]];
//    [changeButton setTitle:@"兑换" forState:UIControlStateNormal];
//    [changeButton setTitle:@"兑换" forState:UIControlStateHighlighted];
//    changeButton.layer.cornerRadius = 5;
//    changeButton.layer.borderWidth = 1;
//    changeButton.clipsToBounds = YES;
    
    
    [scoreBg release];
    [scoreTitleLabel release];
    [charmBg release];
    [charmTitleLabel release];
    [cueLabel release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    SAFERELEASE(_userNameLabel)
    SAFERELEASE(_scoreLabel)
    SAFERELEASE(_charmLabel)
    SAFERELEASE(_okButton)
    [super dealloc];
}

#pragma mark - button
- (void)okButtonClick:(UIButton *)btn {
    ULog(@"okButtonClick");
    [UAlertView showAlertViewWithTitle:nil message:@"该服务即将上线" delegate:nil cancelButton:@"确定" defaultButton:nil];
}

- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
