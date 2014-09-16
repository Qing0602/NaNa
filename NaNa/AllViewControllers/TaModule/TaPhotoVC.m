//
//  TaPhotoVC.m
//  NaNa
//
//  Created by ubox  on 14-2-20.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "TaPhotoVC.h"
#import "PhotosModel.h"
#import "photoDetailManagementVC.h"
@interface TaPhotoVC ()
{
    NSInteger targetID;
}
@end

@implementation TaPhotoVC
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userPhotoesList"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].userPhotoesList];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            [_photosArray removeAllObjects];
            for (NSDictionary *info in tempData[ASI_REQUEST_DATA]) {
                PhotosModel *model = [[PhotosModel alloc] init];
                model.imageDes = info[@"description"];
                model.imagePath = info[@"imageurl"];
                model.imageID = info[@"id"];
                NSURL *imageUrl = [NSURL URLWithString:info[@"imageurl"]];
                if (![[EGOImageLoader sharedImageLoader] hasLoadedImageURL:imageUrl] && ![[EGOImageLoader sharedImageLoader] isLoadingImageURL:imageUrl]) {
                    [[EGOImageLoader sharedImageLoader] loadImageForURL:imageUrl observer:self];
                }
                [_photosArray addObject:model];
            }
            
            [_gridView reloadData];
        }else
        {
            
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"userPhotoesList" options:0 context:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"userPhotoesList"];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithUserID:(NSInteger)userID
{
    self = [super init];
    if (self) {
        targetID = userID;
        
        _photosArray = [[NSMutableArray alloc] init];
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
    _gridView.cellSize = CGSizeMake(100, 100);
    _gridView.cellPadding = CGSizeMake(5, 5);
    _gridView.delegate = self;
    _gridView.dataSource = self;
    [_defaultView addSubview:_gridView];
    
    [[NaNaUIManagement sharedInstance] getuserPhotoesList:targetID];
}

- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section
{
    return [_photosArray count];
}

- (KKGridViewCell *)gridView:(KKGridView *)gridView cellForItemAtIndexPath:(KKIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    PhotoCell *cell = (PhotoCell *)[gridView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[PhotoCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100) reuseIdentifier:identifier] autorelease];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    //cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:0xfd0];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:0xfd1];
    UILabel *addLabel = (UILabel *)[cell.contentView viewWithTag:0xfd2];

    PhotosModel *model = [_photosArray objectAtIndex:indexPath.index];
    
    image.hidden = NO;
    label.hidden = NO;
    addLabel.hidden = YES;
    cell.contentView.layer.borderWidth = 0;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    //NSInteger index = indexPath.index - 1;
    //NSDictionary *dic = [_photosArray objectAtIndex:index];
    if (!image) {
        image = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
        image.tag = 0xfd0;
        [cell.contentView addSubview:image];
    }
    UIImage *tempImage = [[EGOImageLoader sharedImageLoader] imageForURL:[NSURL URLWithString:model.imagePath] shouldLoadWithObserver:self];
    if (!tempImage) {
        
    }else
    {
        image.image = tempImage;
    }
    
    //SAFERELEASE(tempImage);
    
    if (!label) {
        label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 80, 100, 20)] autorelease];
        label.tag =  0xfd1;
        label.font = [UIFont systemFontOfSize:12];
        //label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
        label.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
    }
    [cell.contentView addSubview:label];
    //        label.text = [NSString stringWithFormat:@"你好,这是第%d照片",indexPath.index];
    if ([model.imageDes isEqualToString:@""] || !model.imageDes)  label.hidden = YES;
    else label.hidden = NO;
    
    label.text = model.imageDes;
    
    return cell;
}

- (void)gridView:(KKGridView *)gridView didSelectItemAtIndexPath:(KKIndexPath *)indexPath
{
    [gridView deselectAll:YES];

    PhotosModel *model = [_photosArray objectAtIndex:indexPath.index];
    photoDetailManagementVC *photoDetail = [[photoDetailManagementVC alloc] initWithModel:model andIsMyPhoto:NO];
    [self.navigationController pushViewController:photoDetail animated:YES];
    [photoDetail release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_gridView release];
    [_photosArray release];
    [super dealloc];
}
#pragma mark EgoDelegate
-(void)imageLoaderDidLoad:(NSNotification *)notification
{
    [_gridView reloadData];
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
