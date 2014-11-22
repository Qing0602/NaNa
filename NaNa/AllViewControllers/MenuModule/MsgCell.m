//
//  MsgCell.m
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "MsgCell.h"
#import "ColorUtil.h"

@implementation MsgCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = RGBA(45.0,46.0,50.0,1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.frame = CGRectMake(0.0, 0.0, sideWidth, self.frame.size.height);
        self.contentView.backgroundColor = [UIColor grayColor];
        
        // icon
        float headHeight = self.frame.size.height - margin_middle;
        _headImageView = [[CircleImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"head_bg.png"] withFrame:CGRectMake(margin_middle, margin_middle, headHeight, headHeight)];
        [self.contentView addSubview:_headImageView];
        
        // 计算坐标
        float offsetX = _headImageView.frame.origin.x + _headImageView.frame.size.width + margin_middle;
        float offsetWidth = self.contentView.frame.size.width - offsetX - margin_small;
        
        // 名称 + 消息
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.frame = CGRectMake(offsetX, 3.0f, offsetWidth - 20.0f, 45);
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.font = [UIFont boldSystemFontOfSize:13];
        _msgLabel.textColor = [UIColor colorWithHexString:@"#cbccce"];
        _msgLabel.numberOfLines = 2;
        [self.contentView addSubview:_msgLabel];
        
        // 计算坐标
        float offsetY = _msgLabel.frame.origin.y + _msgLabel.frame.size.height + margin_small;
        
        // 时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = CGRectMake(_msgLabel.frame.origin.x, offsetY,
                                      _msgLabel.frame.size.width, 25);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont boldSystemFontOfSize:11];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#919294"];
        [self.contentView addSubview:_timeLabel];
        
        
        self.unReaderCount = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 16.0f, 16.0f)];
        self.unReaderCount.textAlignment = NSTextAlignmentCenter;
        self.unReaderCount.textColor = [UIColor whiteColor];
        self.unReaderCount.font = [UIFont boldSystemFontOfSize:11.0f];
        self.unReaderCount.backgroundColor = [UIColor clearColor];
        
        self.unReaderImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"NaNaUnReaderCountBG"] stretchableImageWithLeftCapWidth:16.0f topCapHeight:16.0f]];
        [self.unReaderImage addSubview:self.unReaderCount];
        self.unReaderImage.hidden = YES;
        [self addSubview:self.unReaderImage];
        
        self.cellLine = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"NaNaCellLine"] stretchableImageWithLeftCapWidth:1.0f topCapHeight:1.0f]];
        [self addSubview:self.cellLine];
    }
    return self;
}

-(void) setModel : (MessageInfoData *) model{
    if (model.count != 0) {
        self.unReaderCount.text = [NSString stringWithFormat:@"%d",model.count];
        [self.unReaderCount sizeToFit];
        self.unReaderCount.center = CGPointMake(16.0f/2.0f, 16.0f/2.0f);
        self.unReaderImage.frame = CGRectMake(_msgLabel.frame.origin.x + _msgLabel.frame.size.width, 8.0f, 16.0f, 16.0f);
        self.unReaderImage.hidden = NO;
    }else{
        self.unReaderImage.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
