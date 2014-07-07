//
//  MenuCell.h
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell {
    UIImageView     *_iconImageView;
    UILabel         *_nameLabel;
}

@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@end
