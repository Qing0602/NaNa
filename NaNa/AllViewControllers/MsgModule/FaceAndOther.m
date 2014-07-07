//
//  FaceAndOther.m
//  NaNa
//
//  Created by ubox  on 14-1-15.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "FaceAndOther.h"

@implementation FaceAndOther

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        
        self.viewType = FaceType;
        _phraseArray = [[NSMutableArray alloc] init];
        
        _otherView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        [self addSubview:_otherView];
        
        _faceView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_faceView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 34)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [_faceView addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - 50)/2, CGRectGetHeight(self.bounds) - 34, 50, 10)];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        [_faceView addSubview:_pageControl];
        
        UIButton *sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendMessageBtn.layer.cornerRadius = 2;
        sendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sendMessageBtn.backgroundColor = [UIColor blueColor];
        sendMessageBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 62, CGRectGetHeight(self.bounds) - 32, 60, 30);
        [sendMessageBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendMessageBtn addTarget:self action:@selector(sendMesageAction:) forControlEvents:UIControlEventTouchUpInside];
        sendMessageBtn.showsTouchWhenHighlighted = YES;
        [_faceView addSubview:sendMessageBtn];
        
        [self scrollViewAddFace];
        [self otherViewAddOther];
    }
    return self;
}

- (void)otherViewAddOther
{
    NSArray *btnNo1 = [NSArray arrayWithObjects:@"album_normal",@"photo_normal",@"gift_normal",nil];
    NSArray *btnSe1 = [NSArray arrayWithObjects:@"album_pressed",@"photo_pressed",@"gift_pressed",nil];
   
    NSArray *btnNo2 = [NSArray arrayWithObjects:@"on_things_normal",@"key_normal", nil];
    NSArray *btnSe2 = [NSArray arrayWithObjects:@"on_things_pressed",@"key_pressed", nil];
    for (int i = 0; i < 3; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30 + (70 + 25)*i, 30, 70, 70);
        [btn setBackgroundImage:[UIImage imageNamed:[btnNo1 objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[btnSe1 objectAtIndex:i]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(otherAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10000+i;
        [_otherView addSubview:btn];
    }
    for (int i = 0; i < 2; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30 + (70 + 25)*i, 130, 70, 70);
        [btn setBackgroundImage:[UIImage imageNamed:[btnNo2 objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[btnSe2 objectAtIndex:i]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(otherAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10003+i;
        [_otherView addSubview:btn];
    }
}

- (void)scrollViewAddFace
{
    for (int i = 0; i<105 ;i++)
    {
        UIImage *face = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        NSMutableDictionary *dicFace = [NSMutableDictionary dictionary];
        [dicFace setValue:face forKey:[NSString stringWithFormat:@"[/%d]",i]];
        [_phraseArray addObject:dicFace];
    }
    UIImage *face = [UIImage imageNamed:[NSString stringWithFormat:@"chat_photo_btn.png"]];
    NSMutableDictionary *dicFace = [NSMutableDictionary dictionary];
    [dicFace setValue:face forKey:[NSString stringWithFormat:@"delete"]];
    [_phraseArray insertObject:dicFace atIndex:35];
    [_phraseArray insertObject:dicFace atIndex:71];
    [_phraseArray addObject:dicFace];

    CGFloat x = 0;CGFloat y = 0;
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j< 4; j++)
        {
            for (int m = 0; m < 9; m ++)
            {
                int index = m + 9*j +i*36;
                x = i*320 + m * (10 + 24) + 10;
                y = j*(18 + 24) + 18;
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                NSMutableDictionary *tempdic = [_phraseArray objectAtIndex:index];
                UIImage *tempImage = [tempdic valueForKey:[[tempdic allKeys] objectAtIndex:0]];
                [btn setBackgroundImage:tempImage forState:UIControlStateNormal];
                btn.frame = CGRectMake(x, y, 24, 24);
                btn.tag = index;
                [btn addTarget:self action:(index == 35 || index == 71 || index == 107) ? @selector(deleteAction:) : @selector(selectFaceAction:) forControlEvents:UIControlEventTouchUpInside];
                [_scrollView addSubview:btn];
            }
        }
    }
    _scrollView.contentSize = CGSizeMake(320 * 3, 216-34);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/320;
}

- (void)showFaceAndeOther:(FaceAndOtherType)type animation:(BOOL)animation
{
    self.viewType = type;
    [UIView animateWithDuration:animation ? 0.3 :0.0 animations:^{
        if (type == FaceType)
        {
            _otherView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        }
        else if (type == OtherType)
        {
            _faceView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            if (type == FaceType)
            {
                _faceView.frame = self.bounds;
            }
            else if (type == OtherType)
            {
                _otherView.frame = self.bounds;
            }
        }];
    }];
}

- (void)otherAction:(UIButton *)btn
{
    OtherActionOptions option = btn.tag - 10000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOtherOption:)])
    {
        [self.delegate didSelectOtherOption:option];
    }
}

- (void)selectFaceAction:(UIButton *)btn
{
    NSMutableDictionary *tempdic = [_phraseArray objectAtIndex:btn.tag];
    NSString *faceStr= [NSString stringWithFormat:@"%@",[[tempdic allKeys] objectAtIndex:0]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFace:)])
    {
        [self.delegate didSelectFace:faceStr];
    }
}

- (void)deleteAction:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDelete)])
    {
        [self.delegate didSelectDelete];
    }
}

- (void)sendMesageAction:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSendMessage)])
    {
        [self.delegate didSelectSendMessage];
    }
}

- (void)dealloc
{
    [_scrollView release];
    [_pageControl release];
    [_otherView release];
    [_phraseArray release];
    [_faceView release];
    [super dealloc];
}

@end
