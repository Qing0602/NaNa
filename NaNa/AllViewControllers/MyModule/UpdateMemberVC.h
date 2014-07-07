//
//  UpdateMemberVC.h
//  NaNa
//
//  Created by dengfang on 13-9-15.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBasicViewController.h"

@interface UpdateMemberVC : UBasicViewController {
    UILabel     *_userNameLabel;    // 用户名称
    UILabel     *_scoreLabel;       // 积分
    UILabel     *_charmLabel;       // 魅力值
    UIButton    *_okButton;         // 立即充值
}

@end
