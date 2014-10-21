//
//  MyGiftListViewController.m
//  NaNa
//
//  Created by ZhangQing on 14-8-15.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "MyGiftListViewController.h"
#import "MMGridViewDefaultCell.h"

@interface MyGiftListViewController ()
{
    MMGridView *_gridView;
    
}
@property (nonatomic, strong)NSArray *gridviewData;
@end

@implementation MyGiftListViewController
-(NSArray *)gridviewData
{
    if (!_gridviewData) {
        _gridviewData = [[NSArray alloc] init];
    }
    return _gridviewData;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"userGiftListDic"]) {
        NSDictionary *tempData = [NSDictionary dictionaryWithDictionary:[NaNaUIManagement sharedInstance].userGiftListDic];
        if (![[tempData objectForKey:ASI_REQUEST_HAS_ERROR] boolValue]) {
            self.gridviewData = [[NSArray alloc]initWithArray:tempData[@"data"]];
            [_gridView reloadData];
        }else
        {
            
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的礼物";
    
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    _gridView = [[MMGridView alloc] initWithFrame:CGRectMake(0.f, 65.f, 320.f, [UIScreen mainScreen].bounds.size.height-65.f)];
    _gridView.cellMargin = 1;
    _gridView.numberOfRows = 4;
    _gridView.numberOfColumns = 3;
    _gridView.layoutStyle = VerticalLayout;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    [self.view addSubview:_gridView];
    
    [[NaNaUIManagement sharedInstance] getUserGiftList];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"userGiftListDic" options:0 context:nil];
   
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"userGiftListDic"];
   
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@", data[@"source_user_nickname"]];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    [cell.imageview setImageURL:[NSURL URLWithString:data[@"imageurl"]]];
    return cell;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    
}


- (void)gridView:(MMGridView *)gridView didDoubleTapCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{

    
}

#pragma mark - viewController
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
