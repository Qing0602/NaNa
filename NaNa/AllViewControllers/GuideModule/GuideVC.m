//
//  GuideVC.m
//  NaNa
//
//  Created by shenran on 12/10/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "GuideVC.h"

@interface GuideVC ()

@end

@implementation GuideVC

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
    UIImageView * backImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    [UStaticData saveObject:@"YES" forKey:@"hasLaunch"];
    [self.defaultView addSubview:backImg];
}


@end
