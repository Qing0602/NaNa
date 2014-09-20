//
//  MenuCell.h
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell {
}

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *cellLine;

@property (nonatomic,strong) UIImageView *unReaderImage;
@property (nonatomic,strong) UILabel *unReaderCount;
@end
