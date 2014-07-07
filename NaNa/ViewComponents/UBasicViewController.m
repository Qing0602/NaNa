//
//  UBasicViewController.m
//  NaNa
//
//  Created by dengfang on 13-7-8.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "UBasicViewController.h"
#import "TTTAttributedLabel.h"
#import "AppDelegate.h"

@interface UBasicViewController ()

@end

@implementation UBasicViewController
@synthesize navBarView = _navBarView;
@synthesize defaultView = _defaultView;
@synthesize titleItem = _titleItem;
@synthesize leftItem = _leftItem;
@synthesize rightItem = _rightItem;

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
	// Do any additional setup after loading the view.
}

- (void)loadView {
    [super loadView];
    
    // IOS7 statusbar辅助view
    UIView *statusbarAidView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.currentDeviceLateriOS7 ? 20 : 0)];
    statusbarAidView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusbarAidView];
    [statusbarAidView release];
    
    // NavBar 标题栏
    if (!_navBarView) {
        _navBarView = [[UIView alloc] init];
        _navBarView.frame = CGRectMake(0, self.currentDeviceLateriOS7 ? 20 : 0, screenWidth, navBarHeight);
        _navBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_bg.png"]];
    }
    [self.view addSubview:_navBarView];
    
    // NavBar 左侧按钮
    if (!_leftItem) {
        _leftItem = [[UIButton alloc] initWithFrame:CGRectMake(0, (navBarHeight - 39)/2, 40, 39)];
        _leftItem.backgroundColor = [UIColor clearColor];
    }
    [_leftItem setBackgroundImage:nil forState:UIControlStateNormal];
    [_leftItem setBackgroundImage:nil forState:UIControlStateHighlighted];
//    _leftItem.titleLabel.shadowOffset = CGSizeMake(0, -1);
//    _leftItem.titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
//    [_leftItem setTitle:STRING(@"back") forState:UIControlStateNormal];
//    [_leftItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
//    [_leftItem setTitleShadowColor:default_color_shadow_light forState:UIControlStateNormal];
//    [_leftItem setTitleShadowColor:default_color_shadow_light forState:UIControlStateHighlighted];
    [_leftItem addTarget:self action:@selector(leftItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:_leftItem];
    
    // NavBar 右侧按钮
    if (!_rightItem) {
        _rightItem = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 40,
                                                                (navBarHeight - 39)/2,
                                                                40, 39)];
        _rightItem.backgroundColor = [UIColor clearColor];
    }
    [_rightItem setBackgroundImage:nil forState:UIControlStateNormal];
    [_rightItem setBackgroundImage:nil forState:UIControlStateHighlighted];
//    _rightItem.titleLabel.shadowOffset = CGSizeMake(0, -1);
//    _rightItem.titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size_14];
//    [_rightItem setTitle:STRING(@"back") forState:UIControlStateNormal];
//    [_rightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
//    [_rightItem setTitleShadowColor:default_color_shadow_light forState:UIControlStateNormal];
//    [_rightItem setTitleShadowColor:default_color_shadow_light forState:UIControlStateHighlighted];
    [_rightItem addTarget:self action:@selector(rightItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:_rightItem];
    
    
    // NavBar 标题
    if (!_titleItem) {
        _titleItem = [[TTTAttributedLabel alloc] init];
        _titleItem.frame = CGRectMake(CGRectGetWidth(_leftItem.frame),
                                      0,
                                      CGRectGetWidth(_navBarView.frame) - CGRectGetWidth(_leftItem.frame) - CGRectGetWidth(_rightItem.frame),
                                      CGRectGetHeight(_navBarView.frame));
    }
    _titleItem.font = [UIFont systemFontOfSize:default_font_size_14];
    _titleItem.textAlignment = UITextAlignmentCenter;
    _titleItem.lineBreakMode = UILineBreakModeWordWrap;
    _titleItem.backgroundColor = [UIColor clearColor];
    _titleItem.textColor = default_color_white;
    _titleItem.numberOfLines = 0;
    _titleItem.leading = -10;
    _titleItem.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    [_navBarView addSubview:_titleItem];
    
    // 内容视图
    if (!_defaultView) {
        _defaultView = [[UIView alloc] initWithFrame:CGRectZero];
        _defaultView.backgroundColor = [UIColor colorWithRed:240/225.0 green:245/255.0 blue:255/255.0 alpha:1.0];
    }
    _defaultView.frame = CGRectMake(0,
                                    CGRectGetMaxY(_navBarView.frame),
                                    screenWidth,
                                    CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_navBarView.frame));
    [self.view insertSubview:_defaultView belowSubview:_navBarView];
}

- (BOOL)currentDeviceLateriOS7
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    SAFERELEASE(_navBarView)
    SAFERELEASE(_titleItem)
    SAFERELEASE(_leftItem)
    SAFERELEASE(_rightItem)
    SAFERELEASE(_defaultView)
    [super dealloc];
}


#pragma mark - ButtonPressed
- (void)leftItemPressed:(UIButton *)btn {
    ULog(@"leftItemPressed");
}


- (void)rightItemPressed:(UIButton *)btn {
    ULog(@"rightItemPressed");
}

#pragma mark - Title
- (void)setTitle:(NSString *)title {
    [((TTTAttributedLabel *)self.titleItem) setText:title afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        // 给主标题上设定一个颜色和字体大小
        NSRange titleRange = NSMakeRange(0, mutableAttributedString.string.length);
        UIFont *titleBoldSystemFont = [UIFont boldSystemFontOfSize:default_font_size_18];
        CTFontRef titleBoldFont = CTFontCreateWithName((CFStringRef)titleBoldSystemFont.fontName, titleBoldSystemFont.pointSize, NULL);
        if (titleBoldFont) {
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:titleRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)titleBoldFont range:titleRange];
            CFRelease(titleBoldFont);
        }
        return mutableAttributedString;
    }];
}

- (void)setNavLeftType:(UNavBarBtnType)leftType navRightType:(UNavBarBtnType)rightType {
    _leftBtnType = leftType;
    _rightBtnType = rightType;
    switch (_leftBtnType) {
        case UNavBarBtnTypeHide: {
            [_leftItem setBackgroundImage:nil forState:UIControlStateNormal];
            [_leftItem setBackgroundImage:nil forState:UIControlStateHighlighted];
            break;
        }
        case UNavBarBtnTypeBack: {
            [_leftItem setBackgroundImage:[UIImage imageNamed:@"navbar_back.png"]
                                 forState:UIControlStateNormal];
            [_leftItem setBackgroundImage:[UIImage imageNamed:@"navbar_back_pressed.png"]
                                 forState:UIControlStateHighlighted];
            break;
        }
        case UNavBarBtnTypeMenu: {
            [_leftItem setBackgroundImage:[UIImage imageNamed:@"navbar_menu.png"]
                                 forState:UIControlStateNormal];
            [_leftItem setBackgroundImage:[UIImage imageNamed:@"navbar_menu_pressed.png"]
                                 forState:UIControlStateHighlighted];
            break;
        }
        case UNavBarBtnTypeTa: {
            [_leftItem setBackgroundImage:[UIImage imageNamed:@"navbar_ta.png"]
                                 forState:UIControlStateNormal];
            [_leftItem setBackgroundImage:[UIImage imageNamed:@"navbar_ta_pressed.png"]
                                 forState:UIControlStateHighlighted];
            break;
        }
        case UNavBarBtnTypeNext: {
            [_leftItem setBackgroundImage:[UIImage imageNamed:@"navbar_next.png"]
                                 forState:UIControlStateNormal];
            [_leftItem setBackgroundImage:[UIImage imageNamed:@"navbar_next_pressed.png"]
                                 forState:UIControlStateHighlighted];
            break;
        }
        case UNavBarBtnTypeSubmit: {
            
            break;
        }
    }
    
    switch (_rightBtnType) {
        case UNavBarBtnTypeHide: {
            [_rightItem setBackgroundImage:nil forState:UIControlStateNormal];
            [_rightItem setBackgroundImage:nil forState:UIControlStateHighlighted];
            break;
        }
        case UNavBarBtnTypeBack: {
            [_rightItem setBackgroundImage:[UIImage imageNamed:@"navbar_back.png"]
                                  forState:UIControlStateNormal];
            [_rightItem setBackgroundImage:[UIImage imageNamed:@"navbar_back_pressed.png"]
                                  forState:UIControlStateHighlighted];
            break;
        }
        case UNavBarBtnTypeMenu: {
            [_rightItem setBackgroundImage:[UIImage imageNamed:@"navbar_menu.png"]
                                  forState:UIControlStateNormal];
            [_rightItem setBackgroundImage:[UIImage imageNamed:@"navbar_menu_pressed.png"]
                                  forState:UIControlStateHighlighted];
            break;
        }
        case UNavBarBtnTypeTa: {
            [_rightItem setBackgroundImage:[UIImage imageNamed:@"navbar_ta.png"]
                                  forState:UIControlStateNormal];
            [_rightItem setBackgroundImage:[UIImage imageNamed:@"navbar_ta_pressed.png"]
                                  forState:UIControlStateHighlighted];
            break;
        }
        case UNavBarBtnTypeNext: {
            [_rightItem setBackgroundImage:[UIImage imageNamed:@"navbar_next.png"]
                                  forState:UIControlStateNormal];
            [_rightItem setBackgroundImage:[UIImage imageNamed:@"navbar_next_pressed.png"]
                                  forState:UIControlStateHighlighted];
            break;
        }
        case UNavBarBtnTypeSubmit: {
            [_rightItem setTitle:@"提交" forState:UIControlStateNormal];
            break;
        }

    }
}

#pragma mark - PushPage
- (void)pushPage:(UBasicViewController *)controller {
    [(UINavigationController *)self.mm_drawerController.centerViewController popToRootViewControllerAnimated:NO];
    [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:controller animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

#pragma mark - SideMenuController
- (void)setSideMenuController {
    if (APP_DELEGATE) {
        if (APP_DELEGATE.rootViewController.leftDrawerViewController == nil) {
            MenuLeftVC *leftController = [[[MenuLeftVC alloc] init] autorelease];
            [APP_DELEGATE.rootViewController setLeftDrawerViewController:leftController];
        }
        if (APP_DELEGATE.rootViewController.rightDrawerViewController == nil) {
            MenuRightVC *rightController = [[[MenuRightVC alloc] init] autorelease];
            [APP_DELEGATE.rootViewController setRightDrawerViewController:rightController];
        }
    }
}

- (void)removeSideMenuController {
    if (APP_DELEGATE.rootViewController) {
        if (APP_DELEGATE.rootViewController.leftDrawerViewController != nil) {
            [APP_DELEGATE.rootViewController setLeftDrawerViewController:nil];
        }
        if (APP_DELEGATE.rootViewController.rightDrawerViewController != nil) {
            [APP_DELEGATE.rootViewController setRightDrawerViewController:nil];
        }
    }
}
@end
