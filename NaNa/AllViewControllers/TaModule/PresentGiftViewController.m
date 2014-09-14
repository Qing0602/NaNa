//
//  PresentGiftViewController.m
//  NaNa
//
//  Created by ZhangQing on 14-8-18.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "PresentGiftViewController.h"
#import "MMGridViewDefaultCell.h"
#import "UAlertView.h"
@interface PresentGiftViewController ()
{
    MMGridView *_gridView;
    NSInteger targetID;
}
@property (nonatomic, strong)NSArray *gridviewData;
@end

@implementation PresentGiftViewController

-(NSArray *)gridviewData
{
    if (!_gridviewData) {
        _gridviewData = [[NSArray alloc] init];
    }
    return _gridviewData;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"giftStoreDic"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].giftStoreDic];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            self.gridviewData = [[NSArray alloc]initWithArray:tempData[@"data"]];
            [_gridView reloadData];
        }else
        {
            
        }
    }else if ([keyPath isEqualToString:@"presentGift"])
    {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].presentGift];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [UAlertView showAlertViewWithMessage:tempData[ASI_REQUEST_ERROR_MESSAGE] delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        }
    }
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
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    _gridView = [[MMGridView alloc] initWithFrame:CGRectMake(0.f, 60.f, 320.f, [UIScreen mainScreen].bounds.size.height-60.f)];
    // _gridView.cellMargin = 5;
    _gridView.numberOfRows = 4;
    _gridView.numberOfColumns = 3;
    _gridView.layoutStyle = VerticalLayout;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    [self.view addSubview:_gridView];
    
    [[NaNaUIManagement sharedInstance] getGiftStoreList];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"giftStoreDic" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"presentGift" options:0 context:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"giftStoreDic"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"presentGift"];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
// ----------------------------------------------------------------------------------

#pragma - MMGridViewDataSource

- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return self.gridviewData.count;
}


- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    MMGridViewDefaultCell *cell = [[MMGridViewDefaultCell alloc] initWithFrame:CGRectNull];
    NSDictionary *data = self.gridviewData[index];
    cell.textLabel.text = [NSString stringWithFormat:@"%@       %@", data[@"title"],data[@"price"]];
    [cell.imageview setImageURL:[NSURL URLWithString:data[@"imageurl"]]];
    return cell;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    NSDictionary *tempData = self.gridviewData[index];
    [self showProgressWithText:@"正在赠送"];
    [[NaNaUIManagement sharedInstance] presentGift:[tempData[@"id"] integerValue] withTargetID:targetID];
}


- (void)gridView:(MMGridView *)gridView didDoubleTapCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    
    
}

#pragma mark - viewController
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
