//
//  UserAgreementVC.m
//  NaNa
//
//  Created by dengfang on 13-8-11.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "UserAgreementVC.h"


@implementation UserAgreementVC


- (void)loadView {
    [super loadView];
    self.title = STRING(@"userAgreement");
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];

    UITextView *info = [[UITextView alloc] init];
    info.frame = CGRectMake(0.0, 0.0, _defaultView.frame.size.width, _defaultView.frame.size.height);
    info.backgroundColor = [UIColor clearColor];
    info.text = STRING(@"userAgreementInfo");
    info.userInteractionEnabled = NO;
    [_defaultView addSubview:info];
    [info release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [super dealloc];
}

#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
