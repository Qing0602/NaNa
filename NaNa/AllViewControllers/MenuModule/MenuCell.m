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
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 背景
//        UIView *bgview = [[UIView alloc] init];
//        bgview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        bgview.backgroundColor = [UIColor blackColor];
//        [self addSubview:bgview];
//        [bgview release];
        
        // icon
        _iconImageView = [[UIImageView alloc] init];
        float iconHeight = self.frame.size.height - 20;
        _iconImageView.frame = CGRectMake(10, 10, iconHeight, iconHeight);
        [self addSubview:_iconImageView];
        
        // 名称
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(_iconImageView.frame.origin.x + _iconImageView.frame.size.width + 10,
                                      0,
                                      self.frame.size.width - _nameLabel.frame.origin.x,
                                      self.frame.size.height);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
        _nameLabel.textColor = default_color_light_dark;
        [self addSubview:_nameLabel]; 
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    SAFERELEASE(_iconImageView)
    SAFERELEASE(_nameLabel)
    [super dealloc];
}
@end
