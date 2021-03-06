//
//  MenuCell.m
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell
@synthesize iconImageView = _iconImageView;
@synthesize nameLabel = _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = RGBA(45.0,46.0,50.0,1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // icon
        _iconImageView = [[UIImageView alloc] init];
//        float iconHeight = self.frame.size.height - 20;
        _iconImageView.frame = CGRectMake(10.0f, 9.0f, 30.0f, 30.0f);
        [self addSubview:_iconImageView];
        
        // 名称
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(_iconImageView.frame.origin.x + _iconImageView.frame.size.width + 10,
                                      2.0f,
                                      self.frame.size.width - _nameLabel.frame.origin.x,
                                      self.frame.size.height);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        
        
        self.unReaderCount = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 16.0f, 16.0f)];
        self.unReaderCount.textAlignment = NSTextAlignmentCenter;
        self.unReaderCount.textColor = [UIColor whiteColor];
        self.unReaderCount.font = [UIFont boldSystemFontOfSize:11.0f];
        self.unReaderCount.backgroundColor = [UIColor clearColor];
        
        self.unReaderImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"NaNaUnReaderCountBG"] stretchableImageWithLeftCapWidth:16.0f topCapHeight:16.0f]];
        self.unReaderImage.frame = CGRectMake(250.0f, 16.0f, 16.0f, 16.0f);
        [self.unReaderImage addSubview:self.unReaderCount];
        self.unReaderImage.hidden = NO;
        [self addSubview:self.unReaderImage];
        
        self.cellLine = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"NaNaCellLine"] stretchableImageWithLeftCapWidth:1.0f topCapHeight:1.0f]];
        self.cellLine.frame = CGRectMake(0.0f, self.frame.size.height - 3.0f, 320.0f, 2.0f);
        [self addSubview:self.cellLine];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = RGBA(34.0,35.0,39.0,1.0);
    }else{
        self.backgroundColor = RGBA(45.0,46.0,50.0,1.0);
    }
}

@end
