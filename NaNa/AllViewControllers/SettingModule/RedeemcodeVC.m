//
//  RedeemcodeVC.m
//  NaNa
//
//  Created by shenran on 12/4/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "RedeemcodeVC.h"

@interface RedeemcodeVC ()

@end

@implementation RedeemcodeVC

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    _URL=K_WEBVIEW_URL_MY_BLACK_LIST;
    _TITLE=@"兑换码";
    [super loadView];
}


@end
