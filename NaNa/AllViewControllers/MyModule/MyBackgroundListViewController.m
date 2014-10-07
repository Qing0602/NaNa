//
//  MyBackgroundListViewController.m
//  NaNa
//
//  Created by ZhangQing on 14-9-11.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "MyBackgroundListViewController.h"
#import "MMGridViewDefaultCell.h"
#import "UAlertView.h"
@interface MyBackgroundListViewController ()
{
    MMGridView *_gridView;
    NSInteger tempBackgroundID;
}
@property (nonatomic, strong)NSArray *gridviewData;
@end

@implementation MyBackgroundListViewController

-(NSArray *)gridviewData
{
    if (!_gridviewData) {
        _gridviewData = [[NSArray alloc] init];
    }
    return _gridviewData;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userBackGroundDic"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].userBackGroundDic];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            self.gridviewData = [[NSArray alloc]initWithArray:tempData[@"data"]];
            [_gridView reloadData];
        }else
        {
            
        }
    }else if ([keyPath isEqualToString:@"buyBackGroundDic"])
    {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].buyBackGroundDic];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [UAlertView showAlertViewWithMessage:tempData[ASI_REQUEST_ERROR_MESSAGE] delegate:nil cancelButton:STRING(@"ok") defaultButton:nil];
        }
        [self closeProgress];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"更换背景";
    
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    _gridView = [[MMGridView alloc] initWithFrame:CGRectMake(0.f, 65.f, 320.f, [UIScreen mainScreen].bounds.size.height-65.f)];
     _gridView.cellMargin = 1;
    _gridView.numberOfRows = 4;
    _gridView.numberOfColumns = 3;
    _gridView.layoutStyle = VerticalLayout;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    [self.view addSubview:_gridView];
    
    [[NaNaUIManagement sharedInstance] getUserBackGround];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"userBackGroundDic" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"buyBackGroundDic" options:0 context:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"userBackGroundDic"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"buyBackGroundDic"];
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
    cell.textLabel.textColor = [UIColor colorWithRed:31/255.f green:208/255.f blue:189/255.f alpha:1.f];
    cell.textLabel.text = [NSString stringWithFormat:@"%@分", data[@"price"]];
    [cell.imageview setImageURL:[NSURL URLWithString:data[@"imageurl"]]];
    return cell;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    NSDictionary *data = self.gridviewData[index];
    tempBackgroundID = [data[@"id"] integerValue];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确认花费%@积分?",data[@"price"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    [alertView show];
}


- (void)gridView:(MMGridView *)gridView didDoubleTapCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    
    
}

#pragma mark - viewController
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIAlertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self showProgressWithText:@"正在购买"];
        [[NaNaUIManagement sharedInstance] buyBackGround:tempBackgroundID];
    }
}
@end
