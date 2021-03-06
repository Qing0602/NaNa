//
//  WebLoginVC.m
//  NaNa
//
//  Created by shenran on 11/28/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "WebLoginVC.h"
#import "InfoEditVC.h"

#import "AppDelegate.h"

#import "NaNaUserAccountModel.h"
@interface WebLoginVC ()

@end

@implementation WebLoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView
{
    [super loadView];
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* rurl=[[request URL] absoluteString];
    NSRange containStrRange = [rurl rangeOfString:@"?code=" options:NSCaseInsensitiveSearch];
    if (containStrRange.length > 0) {
        //有当前关键字结果
        NSURL *url = [NSURL URLWithString:rurl];
        NSURLRequest *neededRequest = [NSURLRequest requestWithURL: url];
        NSHTTPURLResponse *response;
        [NSURLConnection sendSynchronousRequest: neededRequest returningResponse: &response error: nil];
        if ([response respondsToSelector:@selector(allHeaderFields)]) {
            NSDictionary *dictionary = [response allHeaderFields];
            
            NaNaUserAccountModel *userAccount = [[NaNaUserAccountModel alloc] init];
            if ([userAccount convertForDic:dictionary]) {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:userAccount.UserID] forKeyPath:@"UserID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [NaNaUIManagement sharedInstance].userAccount = userAccount;
                [NaNaUserAccountModel serializeModel:userAccount withFileName:@"NaNaUserAccount"];
            }
            
            NSInteger isfirst = [[dictionary objectForKey:@"is_1st"] integerValue];
            if (isfirst == 0) {
                [APP_DELEGATE loadMainView];
            }else{
                InfoEditVC *infoEdit = [[[InfoEditVC alloc] initWithType:TYPE_LOGIN] autorelease];
                [self.navigationController pushViewController:infoEdit animated:YES];
            }
        }
    }
    return YES;
}

-(void) dealloc{
    
}
@end
