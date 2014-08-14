//
//  MsgCell.m
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "MsgCell.h"

@implementation MsgCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.frame = CGRectMake(0.0, 0.0, sideWidth, self.frame.size.height);
        self.contentView.backgroundColor = [UIColor grayColor];
        
        // icon
        _headImageView = [[UIImageView alloc] init];
        float headHeight = self.frame.size.height - margin_middle;
        _headImageView.frame = CGRectMake(margin_middle, margin_middle, headHeight, headHeight);
        [self.contentView addSubview:_headImageView];
        
        // 计算坐标
        float offsetX = _headImageView.frame.origin.x + _headImageView.frame.size.width + margin_middle;
        float offsetWidth = self.contentView.frame.size.width - offsetX - margin_small;
        
        // 名称 + 消息
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.frame = CGRectMake(offsetX, 0, offsetWidth, 45);
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _msgLabel.textColor = default_color_light_dark;
        _msgLabel.numberOfLines = 2;
        [self.contentView addSubview:_msgLabel];
        
        // 计算坐标
        float offsetY = _msgLabel.frame.origin.y + _msgLabel.frame.size.height + margin_small;
        
        // 时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = CGRectMake(_msgLabel.frame.origin.x, offsetY,
                                      _msgLabel.frame.size.width, 25);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _timeLabel.textColor = default_color_light_dark;
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
