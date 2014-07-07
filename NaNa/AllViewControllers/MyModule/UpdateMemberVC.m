//
//  UpdateMemberVC.m
//  NaNa
//
//  Created by dengfang on 13-9-15.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "UpdateMemberVC.h"

@interface UpdateMemberVC ()

@end

@implementation UpdateMemberVC

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
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    // 用户名称
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.frame = CGRectMake(25.0, 25.0, screenWidth - 25 * 2, 30.0);
        _userNameLabel.textColor = default_color_dark;
        _userNameLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.text = @"临时用户名称";
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
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
    cueLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
    cueLabel.backgroundColor = [UIColor clearColor];
    cueLabel.text = STRING(@"updateCue");
    cueLabel.textAlignment = NSTextAlignmentCenter;
    [_defaultView addSubview:cueLabel];
    
    // 立即开通按钮
    if (!_okButton) {
        _okButton = [[UIButton alloc] init];
        _okButton.frame = CGRectMake(40.0,
                                     cueLabel.frame.origin.y + cueLabel.frame.size.height + 15,
                                     240.0, 40.0);
        _okButton.backgroundColor = [UIColor clearColor];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"btn_green_normal.png"] forState:UIControlStateNormal];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"btn_green_pressed.png"] forState:UIControlStateHighlighted];
        [_okButton setTitle:STRING(@"immediatelyUpdate") forState:UIControlStateNormal];
        [_okButton setTitleColor:default_color_deep_dark forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_18];
        [_okButton addTarget:self
                      action:@selector(okButtonClick:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    [_defaultView addSubview:_okButton];
    
    
    
    
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
}

- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
