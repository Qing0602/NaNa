//
//  UTabbar.m
//  UBoxOnline
//
//  Created by ubox on 13-3-13.
//  Copyright (c) 2013年 ubox. All rights reserved.
//

#import "UTabbar.h"
#import "AppDelegate.h"
#import "UTabBtn.h"


#define statusBarWidth 320.0

#pragma mark - UTabbar

@implementation UTabbar

- (void)dealloc {

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        // 创建Buttons
        _tabbarBtnArray = [[NSMutableArray alloc] init];
        self.image = [UIImage imageNamed:@"navbar_bg.png"];
    }
    return self;
}
- (id)initWithTitleArray:(NSArray *)titleArray
              imageArray:(NSArray *)imageArray
        selectImageArray:(NSArray *)selectImageArray
{
    CGRect rect = CGRectMake(0, windowHeight - 50, 320, 50);
    if (self = [self initWithFrame:rect])
    {
        [self createBtnsTitleArray:titleArray imageArray:imageArray selectImageArray:selectImageArray];
    }
    return self;
}
// 创建Btn
- (void)createBtnsTitleArray:(NSArray *)titleArray
                  imageArray:(NSArray *)imageArray
            selectImageArray:(NSArray *)selectImageArray
{

    // 默认下面Tab的个数
    int tabsCount = MIN(MIN(titleArray.count, imageArray.count), selectImageArray.count);
    
    // 根据个数自动计算Tab的位置
    for (int i = 0; i < tabsCount; i++)
    {
        UTabBtn *btn = [[UTabBtn alloc] initWithFrame:CGRectMake(i * 80, 0, 80, 50)];
        btn.backgroundColor = [UIColor clearColor];
        btn.bgImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        btn.bgImageView.highlightedImage = [UIImage imageNamed:[selectImageArray objectAtIndex:i]];
        btn.titleLabel.text = [titleArray objectAtIndex:i];
        [btn addTarget:self action:@selector(tabbuttonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [_tabbarBtnArray addObject:btn];
        [self addSubview:btn];
    }
}

// Btn的响应事件
- (void)tabbuttonDidSelected:(UTabBtn *)sender
{    
    if (self.didSelectTabBlock)
    {
        self.didSelectTabBlock(sender.tag);
    }
}

@end
