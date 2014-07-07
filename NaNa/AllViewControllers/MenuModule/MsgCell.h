//
//  MsgCell.h
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgCell : UITableViewCell {
    UIImageView     *_headImageView;
    UILabel         *_msgLabel;
    UILabel         *_timeLabel;
}

@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *msgLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@end
