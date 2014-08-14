//
//  MsgCell.h
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgCell : UITableViewCell {
}

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *msgLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIImageView *unReaderImage;
@property (nonatomic,strong) UILabel *unReaderCount;

@property (nonatomic,strong) UIImageView *cellLine;
@end
