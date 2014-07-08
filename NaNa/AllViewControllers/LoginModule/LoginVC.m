//
//  LoginVC.m
//  NaNa
//
//  Created by shenran on 11/18/13.
//  Copyright (c) 2013 dengfang. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "WebLoginVC.h"
@interface LoginVC ()

@end

@implementation LoginVC

@synthesize imageList=_imageList;
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

-(void)dealloc
{
    [super dealloc];
}

- (void)loadView {
    [super loadView];
    // title
    self.title = STRING(@"login");
    //定义UIScrollView
    //NSArray * imageArray=[NSArray arrayWithArray:_imageList];
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-_navBarView.frame.size.height)];
    _scrollview.backgroundColor=[UIColor redColor];
    _scrollview.contentSize = CGSizeMake(320, 1405);  //scrollview的滚动范围
    _scrollview.showsVerticalScrollIndicator = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.delegate = self;
    _scrollview.scrollEnabled = YES;
    //_scrollview.pagingEnabled = YES; //使用翻页属性
    _scrollview.bounces = NO;
   
    UIImageView * image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1405)];
    image.image=[UIImage imageNamed:@"login.png"];
    [_scrollview addSubview:image];
    
    UIView * tabbar=[[UIView alloc] initWithFrame:CGRectMake(0,
                                                             self.defaultView.frame.size.height - 122,
                                                             self.defaultView.frame.size.width, 122)];
    [tabbar setBackgroundColor:[UIColor blackColor]];
    UIView * qqLogin=[self AddTabbutton:STRING(@"QQ") NormalImage:@"qq.png" SelectedImage:@"qq_press.png" TAG:1];
    qqLogin.frame=CGRectMake(40, 0, 100, 110);
    [tabbar addSubview:qqLogin];
    SAFERELEASE(qqLogin);
    
    UIView * weiboLogin=[self AddTabbutton:STRING(@"weibo") NormalImage:@"weibo.png" SelectedImage:@"weibo_press.png" TAG:2];
    weiboLogin.frame=CGRectMake(170, 0, 100, 110);
    [tabbar addSubview:weiboLogin];
    SAFERELEASE(weiboLogin);
    
//    UIView * weixinLogin=[self AddTabbutton:STRING(@"weixin") NormalImage:@"weixin.png" SelectedImage:@"weixin_press.png" TAG:3];
//    weixinLogin.frame=CGRectMake(210, 0, 100, 110);
//    [tabbar addSubview:weixinLogin];
//    SAFERELEASE(weixinLogin);
    [self.defaultView addSubview:_scrollview];
    [self.defaultView addSubview:tabbar];
    

}

-(UIView*)AddTabbutton:(NSString*) mTitle
                        NormalImage:(NSString *)normalImage
                        SelectedImage:(NSString* )selectedImage
                        TAG:(int)tag{
//UIView * AddTabbutton(NSString* mTitle,NSString * normalImage,NSString* selectedImage,int tag)

    UIView * buttonView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 110)];
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(20, 10, 60, 60);;
    [button setTitle:mTitle forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    button.tag=tag;
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:button];
    
    
    UILabel * btnLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 80, 100, 20)];
    [btnLable setBackgroundColor:[UIColor clearColor]];
    btnLable.textAlignment=UITextAlignmentCenter;
    btnLable.text=mTitle;
    [btnLable setTextColor:[UIColor grayColor]];
    [buttonView addSubview:btnLable];
    SAFERELEASE(btnLable);
    return buttonView;

}

-(void)onClick:(UIButton *)sender
{
    int TAG=sender.tag;
    switch (TAG) {
        case 1:
        {
            ULog(@"qq");
            //           WebLoginVC *webQQLogin =  [[WebLoginVC alloc] init];
            //            [webQQLogin setURL:@"http://api.local.ishenran.cn/qqlogin/index.php"];
            //            [self.navigationController pushViewController:webQQLogin animated:YES];
            [APP_DELEGATE loadMainView];
        }
            break;
        case 2:
        {
            WebLoginVC *webWeiBoLogin =  [[WebLoginVC alloc] init];
            [webWeiBoLogin setURL:@"http://api.local.ishenran.cn/wblogin/index.php"];
            [self.navigationController pushViewController:webWeiBoLogin animated:YES];
            ULog(@"weibo");
        }
            break;
        case 3:
            ULog(@"weixin");
            break;
        default:
            break;
    }
}

@end
