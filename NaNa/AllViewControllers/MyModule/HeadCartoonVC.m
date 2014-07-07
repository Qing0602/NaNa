//
//  HeadCartoonVC.m
//  NaNa
//
//  Created by dengfang on 13-8-18.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "HeadCartoonVC.h"

@implementation HeadCartoonVC
@synthesize headCartoonDelegate = _headCartoonDelegate;


- (void)loadView {
    [super loadView];
    self.title = STRING(@"selectHead");
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    if (!_imageArray) {
        _imageArray = [[NSArray alloc] initWithObjects:@"head_cartoon_1.png",
                       @"head_cartoon_2.png", @"head_cartoon_3.png",
                       @"head_cartoon_4.png", @"head_cartoon_5.png",
                       @"head_cartoon_6.png", nil];
    }
    
    if (!_gridView) {
        _gridView = [[KKGridView alloc] initWithFrame:_defaultView.bounds];
        _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _gridView.cellSize = CGSizeMake(110, 110);
        _gridView.cellPadding = CGSizeMake(35, 20);
        _gridView.backgroundColor = [UIColor clearColor];
        _gridView.scrollsToTop = YES;
        _gridView.dataSource = self;
        _gridView.delegate = self;
    }
    [_defaultView addSubview:_gridView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    SAFERELEASE(_gridView)
    SAFERELEASE(_imageArray)
    [super dealloc];
}

#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KKGridViewDataSource
- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section {
    return [_imageArray count];
}

- (KKGridViewCell *)gridView:(KKGridView *)gridView cellForItemAtIndexPath:(KKIndexPath *)indexPath {
    KKGridViewCell *cell = [KKGridViewCell cellForGridView:gridView];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    NSInteger index = indexPath.index;
    UIImageView *imageView = [[UIImageView alloc] init];
    cell.imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:index]];
    [imageView release];
    
    return cell;
}

#pragma mark - KKGridViewDelegate
- (void)gridView:(KKGridView *)gridView didSelectItemAtIndexPath:(KKIndexPath *)indexPath {
    [gridView deselectItemsAtIndexPaths:[NSArray arrayWithObject:indexPath] animated:YES];
    
    NSInteger index = indexPath.index;
    if (_headCartoonDelegate != nil &&
        [_headCartoonDelegate respondsToSelector:@selector(currentHeadImage:)]) {
        
        [_headCartoonDelegate currentHeadImage:[_imageArray objectAtIndex:index]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
