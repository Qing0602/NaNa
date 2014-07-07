//
//  SignVC.m
//  NaNa
//
//  Created by shenran on 11/28/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "SignVC.h"

@interface SignVC ()

@end

@implementation SignVC

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
    [super loadView];
    // title
    self.title = STRING(@"black");
    self.URL=@"";
}
@end
