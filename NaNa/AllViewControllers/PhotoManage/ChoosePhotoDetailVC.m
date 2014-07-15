//
//  ChoosePhotoDetailVC.m
//  NaNa
//
//  Created by ubox  on 14-2-24.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "ChoosePhotoDetailVC.h"

@interface ChoosePhotoDetailVC ()

@end

@implementation ChoosePhotoDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //监听键盘高度的变换
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        // 键盘高度变化通知，ios5.0新增的
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetWidth(self.navBarView.frame) - 60, 7, 60, 30);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:btn];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:_defaultView.bounds];
    _scrollView.contentSize = CGSizeMake(320, CGRectGetHeight(_defaultView.frame));
    _scrollView.delegate = self;
    [_defaultView addSubview:_scrollView];

    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.delegate = self;
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView becomeFirstResponder];
    [_scrollView addSubview:_textView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textView.frame)+20, 300, 300)];
    imageView.image = self.chooseImage;
    imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:imageView];



    UITapGestureRecognizer *ge = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reveceKeyBoard)];
    [imageView addGestureRecognizer:ge];
    [ge release];
    
    [imageView release];
	// Do any additional setup after loading the view.
}

- (void)reveceKeyBoard
{
    if ([_textView becomeFirstResponder])
    {
        [_textView resignFirstResponder];
    }
}

- (void)completeAction
{
    self.choosedImageBlock(_textView.text.length ?_textView.text : @"");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftItemPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
     [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self completeAction];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_scrollView release];
    [_textView release];
    [super dealloc];
}

@end
