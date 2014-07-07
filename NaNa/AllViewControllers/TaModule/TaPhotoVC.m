//
//  TaPhotoVC.m
//  NaNa
//
//  Created by ubox  on 14-2-20.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "TaPhotoVC.h"

@interface TaPhotoVC ()

@end

@implementation TaPhotoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = STRING(@"相册");
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
	// Do any additional setup after loading the view.
    _gridView = [[KKGridView alloc] initWithFrame:_defaultView.bounds];
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.cellSize = CGSizeMake(100, 120);
    _gridView.cellPadding = CGSizeMake(5, 5);
    _gridView.delegate = self;
    _gridView.dataSource = self;
    [_defaultView addSubview:_gridView];
}

- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section
{
    return 30;
}

- (KKGridViewCell *)gridView:(KKGridView *)gridView cellForItemAtIndexPath:(KKIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    PhotoCell *cell = (PhotoCell *)[gridView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[PhotoCell alloc] initWithFrame:CGRectMake(0, 0, 100, 120) reuseIdentifier:identifier] autorelease];
    }

    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:0xfd0];
    if (!image) {
        image = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
        image.tag = 0xfd0;
        [cell.contentView addSubview:image];
    }
    image.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:0xfd1];

    if (!label) {
        label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 20)] autorelease];
        label.tag =  0xfd1;
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor clearColor];
    }
    [cell.contentView addSubview:label];
    label.text = [NSString stringWithFormat:@"你好,这是第%d照片",indexPath.index];

    return cell;
}

- (void)gridView:(KKGridView *)gridView didSelectItemAtIndexPath:(KKIndexPath *)indexPath
{
    [gridView deselectAll:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_gridView release];
    [super dealloc];
}

@end

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self bringSubviewToFront:self.contentView];
}

- (void)dealloc
{
    [super dealloc];
}
@end
