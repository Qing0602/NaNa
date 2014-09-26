//
//  UCityVC.m
//  Test
//
//  Created by 陈浩男 on 13-8-16.
//  Copyright (c) 2013年 陈浩男. All rights reserved.
//

#import "UCityVC.h"

#define kTagBackButton  1024

@interface UCityVC ()

@end

@implementation UCityVC

@synthesize cityTable = _cityTable;
@synthesize searchCity = _searchCity;
@synthesize sadFace = _sadFace;
@synthesize sadMessage = _sadMessage;
@synthesize uCity;
@synthesize hotArray;
@synthesize allArray;
@synthesize searchedArray;
@synthesize searchedCity;
@synthesize GPSInfo;
@synthesize isSearchState;
@synthesize tap = _tap;


#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = STRING(@"cityList");
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getcurrentCityFinishedNotify:)
                                                 name:UGetCurrentCityFinishedNotify
                                               object:nil];
    uCity = [[UCity alloc] init];
    isSearchState = NO;
    if (!_tap) {
        _tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        _tap.delegate = self;
    }
    [self.view addGestureRecognizer:_tap];
    
    
    if (!_searchCity) {
        _searchCity = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 55, 320, 45)];
        _searchCity.placeholder = STRING(@"inputCitySearch");
        _searchCity.delegate = self;
        
        _searchCity.barStyle = UIBarStyleBlackTranslucent;
        _searchCity.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchCity.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    
    
    UIView *segment = [_searchCity.subviews objectAtIndex:0];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar.png"]];
    bgImage.frame = CGRectMake(0,10,320,45);
    [segment addSubview: bgImage];
    [bgImage release];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 55, 320, 45)];
    [btn addTarget:self action:@selector(toSearchVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn release];
    
    if (!_cityTable) {
        _cityTable = [[UITableView alloc] init];
        _cityTable.frame = CGRectMake(0, 100, 320, [UIScreen mainScreen].bounds.size.height -100);
        _cityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cityTable.delegate = self;
        _cityTable.dataSource = self;
    }
    

    self.allArray = [uCity getAllCities];
    self.hotArray = [uCity getHotCities];
    self.searchedArray = [uCity getSearchedCities];
    self.searchedCity = [NSMutableArray array];
    
    if (!_sadFace) {
        _sadFace = [[UIImageView alloc] initWithFrame:CGRectMake(136, 100, 48, 48)];
        _sadFace.image = [UIImage imageNamed:@"face_sad.png"];
        _sadFace.hidden = YES;
    }
    
    if (!_sadMessage) {
        _sadMessage = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, 220, 60)];
        _sadMessage.backgroundColor = [UIColor clearColor];
        _sadMessage.numberOfLines = 2;
        _sadMessage.textAlignment = UITextAlignmentCenter;
        _sadMessage.textColor = [UIColor lightGrayColor];
        _sadMessage.text = STRING(@"inputCityCue");
        _sadMessage.hidden = YES;
    }
    

    NSDictionary *hotDic = [NSDictionary dictionaryWithObjectsAndKeys:self.hotArray,
                            STRING(@"hot"), STRING(@"hot"), @"cityType",nil];
    [self.allArray insertObject:hotDic atIndex:0];
    
    GPSInfo = STRING(@"location");
    [uCity getCurrentCity];
    [self.view addSubview:_searchCity];
    [self.view addSubview:_sadFace];
    [self.view addSubview:_sadMessage];
    [self.view addSubview:_cityTable];
    
    if (!_indexBar) {
        _indexBar = [[CMIndexBar alloc] init];
        _indexBar.frame = CGRectMake(self.cityTable.frame.size.width - 27,
                                    self.cityTable.frame.origin.y,
                                    26.0,
                                    self.cityTable.frame.size.height-10);
    }
    [self.view addSubview:_indexBar];
    _indexBar.delegate = self;
    _indexBar.hidden = YES;
    [_indexBar setIndexes:[NSArray arrayWithArray:self.allArray]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload {
    _cityTable = nil;
    _sadFace = nil;
    _sadMessage = nil;
    _searchCity = nil;
    if (_tap) {
        _tap = nil;
    }
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_cityTable release];
    [_searchCity release];
    [_sadFace release];
    [_sadMessage release];
    [uCity release];
    [hotArray release];
    [allArray release];
    [searchedArray release];
    [searchedCity release];
    [_tap release];
    [super dealloc];
}

#pragma mark - gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSString *touchObject = NSStringFromClass([touch.view class]);
    //点击的是CMIndexBar
    if ([touchObject isEqualToString:@"CMIndexBar"]) {
        
        return NO;
    }
    //点击到空白的时候
    else if ([touchObject isEqualToString:@"UIView"]) {
        [_searchCity resignFirstResponder];
        return NO;
    }
    //点击的是返回按钮 或者 搜索X
    else if ([touchObject isEqualToString:@"UIButton"]) {
        UIButton *btn = (UIButton *)touch.view;
        if (btn.tag == kTagBackButton) {
            [self leftItemPressed:_leftItem];
            return NO;
        }
        else {
            _searchCity.text = @"";
            isSearchState = NO;
            [self judgeHiddenOrShow];
            return NO;
        }
    }
    //点击的是UITableView的空白
    else if ([touchObject isEqualToString:@"UITableView"]) {
        [_searchCity resignFirstResponder];
        return NO;
    }
    //点击的是UITableView的Cell的contentView
    else if ([touchObject isEqualToString:@"UITableViewCellContentView"]) {
        if (isSearchState) {
            if (searchedCity.count) {
                return NO;
            }
            [_searchCity resignFirstResponder];
        }
        else {
            return NO;
        }
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _indexBar.hidden = YES;
    if(searchText.length == 0) {
        [self judgeHiddenOrShow];
        return;
    }
    else {
        isSearchState = YES;
        [self.searchedCity removeAllObjects];
    }
    NSMutableString * str = [NSMutableString stringWithString:@""];
    for (UCity * city in self.searchedArray) {
        NSString * cityName = city.cityName;
        unichar c = [searchText characterAtIndex:0];
        
        if (c >=0x4E00 && c <=0x9FFF) {    
            [str appendFormat:@"%c", pinyinFirstLetter([cityName characterAtIndex:0])];
            if (([[cityName uppercaseString] rangeOfString:searchText].location!= NSNotFound)
               || ([[cityName lowercaseString] rangeOfString:searchText].location!= NSNotFound)) {
                
                [searchedCity addObject:city];
            }
        }
        else {
            unichar pinyin = pinyinFirstLetter([cityName characterAtIndex:0]);
            if(c == pinyin) {
                [searchedCity addObject:city];
            }
        }
    }
    [self judgeHiddenOrShow];
}

- (void)judgeHiddenOrShow {
    if (isSearchState) {
        if (searchedCity.count) {
            _sadFace.hidden = YES;
            _sadMessage.hidden = YES;
            _cityTable.hidden = NO;
        }
        else {
            _cityTable.hidden = YES;
            _sadFace.hidden = NO;
            _sadMessage.hidden = NO;
        }
    }
    else {
        _sadFace.hidden = YES;
        _sadMessage.hidden = YES;
        _cityTable.hidden = NO;
    }
    [_cityTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    isSearchState = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchCity resignFirstResponder];
}

- (void)viewTapped:(id)sender {
    [_searchCity resignFirstResponder];
    [_cityTable reloadData];
}

- (void)getcurrentCityFinishedNotify:(NSNotification *)notify {
    if (notify.object) {
        GPSInfo = notify.object;
        [_cityTable reloadData];
    }
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isSearchState) {
        return 1;
    }
    return self.allArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (isSearchState || section == 0) {
        return 0;
    }
    if (section != 1) {
        section -= 2;
        NSString *key = [[self.allArray objectAtIndex:section] objectForKey:@"cityType"];
        NSArray *arr = (NSArray *)[[self.allArray objectAtIndex:section] objectForKey:key];
        if (!arr.count) {
            return 0;
        }
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    backImage.image = [UIImage imageNamed:@"section_banner.png"];
    [view addSubview:backImage];
    [backImage release];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:default_font_size_14];
    if (section > 0) {
        NSString *key = [[self.allArray objectAtIndex:section-1] objectForKey:@"cityType"];
        cityLabel.text = [key uppercaseString];
    }
    [view addSubview:cityLabel];
    [cityLabel release];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearchState) {
        return self.searchedCity.count;
    }
    if (section == 0) {
        return 1;
    }
    section -= 1;
    NSString *key = [[self.allArray objectAtIndex:section] objectForKey:@"cityType"];
    NSArray *arr = (NSArray *)[[self.allArray objectAtIndex:section] objectForKey:key];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 320, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:default_font_size_14];
    if (isSearchState) {
        _indexBar.hidden = YES;
        UCity *city = [self.searchedCity objectAtIndex:indexPath.row];
        cityLabel.text = city.cityName;
    }
    else {
        _indexBar.hidden = NO;
        if (indexPath.section == 0) {
            cityLabel.text = GPSInfo;
        }
        else {
            NSDictionary *dict = [self.allArray objectAtIndex:indexPath.section-1];
            NSString *key = [dict objectForKey:@"cityType"];
            NSArray *arr = [dict objectForKey:key];
            UCity *city = [arr objectAtIndex:indexPath.row];
            cityLabel.text = city.cityName;
        }
    }
    
    [cell addSubview:cityLabel];
    [cityLabel release];
    
    UIImageView *downLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 31, 320, 1)];
    downLineImage.image = [UIImage imageNamed:@"cell_line.png"];
    [cell addSubview:downLineImage];
    [downLineImage release];
    
    return [cell autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_searchCity resignFirstResponder];
    if (isSearchState) {
        if (self.searchedCity.count) {
            UCity *city = [self.searchedCity objectAtIndex:indexPath.row];
            [self ULogCityID:city];
        }
    }
    else {
        if (indexPath.section > 0) {
            NSDictionary *dict = [self.allArray objectAtIndex:indexPath.section -1];
            NSString *key = [dict objectForKey:@"cityType"];
            NSArray *cityArray = [dict objectForKey:key];
            UCity *city = [cityArray objectAtIndex:indexPath.row];
            [self ULogCityID:city];
        }
    }
}


- (void)ULogCityID:(UCity *)city {
    [[NSNotificationCenter defaultCenter] postNotificationName:UGetSelectedCityFinishedNotify
                                                        object:city
                                                      userInfo:nil];
    [self leftItemPressed:_leftItem];
    ULog(@"city.cityID is %d",city.cityID);
}


#pragma mark - index
// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)indexSelectionDidChange:(CMIndexBar *)IndexBar :(int)index :(NSString*)title {
    [self.cityTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                          atScrollPosition:UITableViewScrollPositionNone
                                  animated:NO];
}

#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
