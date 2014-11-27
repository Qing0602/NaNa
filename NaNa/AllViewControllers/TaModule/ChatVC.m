//
//  ChatViewController.m
//  NaNa
//
//  Created by ubox  on 14-1-13.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "ChatVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UAlertView.h"
#import "FaceAndOther.h"
#import "NaNaUIManagement.h"
#import "SVPullToRefresh.h"
#import "RoundRectEGOImageButton.h"
#import "PresentGiftViewController.h"
#import "CircleImageButton.h"

#define TOOLBARTAG		200
#define TABLEVIEWTAG	300

#define KFacialSizeWidth  22
#define KFacialSizeHeight 22
#define MAX_WIDTH 150

#define BEGIN_FLAG @"[/"
#define END_FLAG @"]"

@interface ChatVC ()
@property (nonatomic,strong) NaNaUserProfileModel *otherProfile;
@property (nonatomic,strong) NSArray *messageArray;
@property (nonatomic,strong) NSArray *meesageAndDate;
@property (nonatomic,strong) NSArray *sendingMessageArray;
@property (nonatomic) BOOL isMore;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) BOOL isEmptyToGetHistroy;
-(void) handleTimerGetNewMessage :(NSTimer *)theTimer;
-(void) messageBuffer;
-(void) messageDate;
@end

@implementation ChatVC

@synthesize chatArray = _chatArray;
@synthesize chatTableView = _chatTableView;
@synthesize messageTextField = _messageTextField;
@synthesize phraseString = _phraseString;
@synthesize lastTime = _lastTime;


-(ChatVC *) initChatVC : (NaNaUserProfileModel *)otherProfileModel{
    self = [self init];
    if (self) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.chatArray = tempArray;
        
        NSDate *tempDate = [[NSDate alloc] init];
        self.lastTime = tempDate;
        
        self.otherProfile = otherProfileModel;
        [self registerNotification];
    }
    return self;
}

- (void)registerNotification{
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 键盘高度变化通知，ios5.0新增的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"messagesDic" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"sendMessageResult" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"historyMessage" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"touchHeadDic" options:0 context:nil];
    [[NaNaUIManagement sharedInstance] addObserver:self forKeyPath:@"giveKey" options:0 context:nil];
}

-(void) dealloc{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"messagesDic"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"sendMessageResult"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"historyMessage"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"touchHeadDic"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"giveKey"];
}

- (void)move:(BOOL)isMove toolbarHeight:(float)height
{
    if (isMove)
    {
        [UIView animateWithDuration:0.2 animations:^{
            _toolbar.frame = CGRectMake(0.0f, (float)(CGRectGetHeight(_defaultView.frame) - height - 44.0f), 320.0f, 44.0f + 216);
            _chatTableView.frame = CGRectMake(0.0f, 0.0f, 320.0f,(float)(CGRectGetHeight(_defaultView.frame) - height - 44.0f));
        }];
    }
}

#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    [self move:YES toolbarHeight:keyboardRect.size.height];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self move:NO toolbarHeight:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEmptyToGetHistroy = NO;
    self.title = self.otherProfile.userNickName;
    self.isMore = YES;
    self.meesageAndDate = [[NSArray alloc] init];
    self.messageArray = [[NSArray alloc] init];
    self.messageArray = [NaNaMessageModel deserializeModel:[NSString stringWithFormat: @"%d.msg",self.otherProfile.userID]];
    for (NaNaMessageModel *model in self.messageArray) {
        if (model != nil) {
            if (model.isBlongMe) {
                model.avatar = [NaNaUIManagement sharedInstance].userProfileCache.userAvatarURL;
            }else{
                model.avatar = self.otherProfile.userAvatarURL;
            }
        }
    }
    
    self.sendingMessageArray = [[NSArray alloc] init];
    [self messageDate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(handleTimerGetNewMessage:) userInfo:nil repeats:YES];
    [self.timer fire];
    _defaultView.backgroundColor = [UIColor colorWithRed:240/255.0 green:245/255.0 blue:255/255.0 alpha:1.0f];
    
    if (!_faceAndeOtherView)
    {
        _faceAndeOtherView = [[FaceAndOther alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        _faceAndeOtherView.delegate = self;
    }
    
    [self setNavLeftType:UNavBarBtnTypeBack navRightType:UNavBarBtnTypeHide];
   
    if (!_chatTableView)
    {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(_defaultView.frame) - 44)style:UITableViewStylePlain];
        _chatTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:245/255.0 blue:255/255.0 alpha:1.0f];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [_defaultView addSubview:_chatTableView];
    __weak ChatVC *weakSelf = self;
    
    // 下拉刷新
    [self.chatTableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshMeetData];
    }];
    
    self.chatTableView.showsInfiniteScrolling = NO;
    
    if (!_toolbar)
    {
        _toolbar = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_defaultView.frame) - CGRectGetHeight(self.navBarView.frame), 320, 44 + 216)];
        _toolbar.backgroundColor = [UIColor clearColor];
        UIImageView *bgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        bgv.image = [UIImage imageNamed:@"chat_toolbar_bg.png"];
        [_toolbar addSubview:bgv];
    }
    [_defaultView addSubview:_toolbar];

    
    UIImageView *textFieldBg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 7, 222, 30)];
    textFieldBg.image = [[UIImage imageNamed:@"chat_textfield_bg.png"] stretchableImageWithLeftCapWidth:30.0f topCapHeight:15.0f];
    [_toolbar addSubview:textFieldBg];
    
    if (!_messageTextField)
    {
        _messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 220, 30)];
        _messageTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //_messageTextField.placeholder = @"请输入内容...";
        _messageTextField.font = [UIFont systemFontOfSize:12];
        [_messageTextField setReturnKeyType:UIReturnKeyDone];
        _messageTextField.delegate = self;
    }
    [_toolbar addSubview:_messageTextField];
    
    UIButton *facialButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [facialButton setBackgroundImage:[UIImage imageNamed:@"chat_face.png"] forState:UIControlStateNormal];
    facialButton.frame = CGRectMake(CGRectGetMaxX(_messageTextField.frame) + 10, 5, 34, 34);
    [facialButton addTarget:self action:@selector(faceAction:) forControlEvents:UIControlEventTouchUpInside];
    facialButton.tag = 0xbfc;
    [_toolbar addSubview:facialButton];
    
    UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherButton setBackgroundImage:[UIImage imageNamed:@"chat_other.png"] forState:UIControlStateNormal];
    otherButton.frame = CGRectMake(CGRectGetMaxX(facialButton.frame) + 10, 5, 34, 34);
    [otherButton addTarget:self action:@selector(otherAction:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:otherButton];
    
//    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messageArray count]-1 inSection:0]
//                              atScrollPosition:UITableViewScrollPositionBottom
//                                      animated:YES];
}

-(void) handleTimerGetNewMessage :(NSTimer *)theTimer{
    [[NaNaUIManagement sharedInstance] getNewMessageWithTargetID:self.otherProfile.userID];
}

-(void) refreshMeetData{
    if(!self.isMore){
        if (self.chatTableView.pullToRefreshView.state == SVPullToRefreshStateLoading ||
            self.chatTableView.pullToRefreshView.state == SVPullToRefreshStateTriggered) {
            [self.chatTableView.pullToRefreshView stopAnimating];
        }
        return;
    }

    __weak ChatVC *weakSelf = self;
    if (weakSelf.messageArray != nil || [weakSelf.messageArray count] != 0) {
        NaNaMessageModel *model = weakSelf.messageArray[0];
        [[NaNaUIManagement sharedInstance] getHistoryMessageWithTargetID:weakSelf.otherProfile.userID withTimeStemp:model.createmicrotime];
    }else{
        self.isEmptyToGetHistroy = YES;
        [[NaNaUIManagement sharedInstance] getHistoryMessageWithTargetID:weakSelf.otherProfile.userID withTimeStemp:0];
    }
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"messagesDic"]) {
        if (![[NaNaUIManagement sharedInstance].messagesDic[ASI_REQUEST_HAS_ERROR] boolValue]) {
            NSArray *messagesOfJson = [NaNaUIManagement sharedInstance].messagesDic[ASI_REQUEST_DATA];
            if ([messagesOfJson count] == 0) {
                return;
            }
            NSMutableArray *msgArray = [[NSMutableArray alloc] initWithArray:self.messageArray];
            for (int i = 0; i<[messagesOfJson count]; i++) {
                NaNaMessageModel *msg = [[NaNaMessageModel alloc] init];
                [msg coverJson:messagesOfJson[i]];
                if ([msg.type isEqualToString: @"文字消息"]) {
                    UIView *returnView =  [self assembleMessageAtIndex:msg.content from:msg.isBlongMe];
                    msg.height = returnView.frame.size.height + 50.0f;
                }
                [msgArray addObject:msg];
            }
            self.messageArray = [[NSArray alloc] initWithArray:msgArray];
            [self messageDate];
            [self.chatTableView reloadData];
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messageArray count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:YES];
            [self messageBuffer];
        }
    }else if ([keyPath isEqualToString:@"sendMessageResult"]){
        if (![[NaNaUIManagement sharedInstance].sendMessageResult[ASI_REQUEST_HAS_ERROR] boolValue]) {
            NSDictionary *data = [NaNaUIManagement sharedInstance].sendMessageResult[ASI_REQUEST_DATA];
            NaNaMessageModel *removeModel = nil;
            for (NaNaMessageModel *model in self.sendingMessageArray) {
                if ([model.content isEqualToString:data[@"content"]]) {
                    NaNaMessageModel *msg = [[NaNaMessageModel alloc] init];
                    msg.content = model.content;
                    msg.creattime = [data[@"createtime"] longLongValue];
                    msg.createmicrotime = [data[@"createmicrotime"] longLongValue];
                    msg.avatar = data[@"avatar"];
                    msg.isBlongMe = model.isBlongMe;
                    msg.height = model.height;
                    msg.state = kSend;
                    removeModel = model;
                    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.messageArray];
                    [temp addObject:msg];
                    self.messageArray = [[NSArray alloc] initWithArray:temp];
                }
            }
            NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.sendingMessageArray];
            [temp removeObject:removeModel];
            self.sendingMessageArray = [[NSArray alloc] initWithArray:temp];
            [self messageDate];
            
            [self.chatTableView reloadData];
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.meesageAndDate count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:YES];
            [self messageBuffer];
        }
    }else if ([keyPath isEqualToString:@"historyMessage"]){
        if (![[NaNaUIManagement sharedInstance].historyMessage[ASI_REQUEST_HAS_ERROR] boolValue]) {
            NSDictionary *dic = [NaNaUIManagement sharedInstance].historyMessage[ASI_REQUEST_DATA];
            NSArray *msg = dic[@"message"];
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (NSDictionary *m in msg) {
                NaNaMessageModel *model = [[NaNaMessageModel alloc] init];
                [model coverJson:m];
                UIView *returnView =  [self assembleMessageAtIndex:model.content from:model.isBlongMe];
                model.height = returnView.frame.size.height + 50.0f;
                [temp addObject:model];
            }
            [temp addObjectsFromArray:self.messageArray];
            self.messageArray = [[NSArray alloc] initWithArray:temp];
            self.isMore = [dic[@"more"] boolValue];
            [self messageDate];
            [self.chatTableView reloadData];
        }
        if (self.chatTableView.pullToRefreshView.state == SVPullToRefreshStateLoading ||
            self.chatTableView.pullToRefreshView.state == SVPullToRefreshStateTriggered) {
            [self.chatTableView.pullToRefreshView stopAnimating];
        }
        
        if (self.isEmptyToGetHistroy) {
            [self messageBuffer];
            self.isEmptyToGetHistroy = NO;
        }
        
    }else if ([keyPath isEqualToString:@"touchHeadDic"]){
        if (![[NaNaUIManagement sharedInstance].touchHeadDic[ASI_REQUEST_HAS_ERROR] boolValue]) {
            NSString *message = [NaNaUIManagement sharedInstance].touchHeadDic[@"data"][@"message"];
            [self showProgressOnwindowsWithText:message withDelayTime:2.0f];
        }else{
            [self showProgressOnwindowsWithText:[NaNaUIManagement sharedInstance].touchHeadDic[ASI_REQUEST_ERROR_MESSAGE] withDelayTime:2.0f];
        }
    }else if ([keyPath isEqualToString:@"giveKey"]){
        if (![[NaNaUIManagement sharedInstance].giveKey[ASI_REQUEST_HAS_ERROR] boolValue]) {
            NSString *message = [NaNaUIManagement sharedInstance].giveKey[@"data"][@"message"];
            [self showProgressOnwindowsWithText:message withDelayTime:2.0f];
        }else{
            [self showProgressOnwindowsWithText:[NaNaUIManagement sharedInstance].giveKey[ASI_REQUEST_ERROR_MESSAGE] withDelayTime:2.0f];
        }
    }
}


-(void) messageBuffer{
    if (nil != self.messageArray && [self.messageArray count] != 0) {
        if ([self.messageArray count]<=5) {
            [NaNaMessageModel serializeModel:self.messageArray withFileName:[NSString stringWithFormat:@"%d.msg",self.otherProfile.userID]];
        }else{
            int count = [self.messageArray count];
            NSMutableArray *buffer = [[NSMutableArray alloc] init];
            for (int i = count - 5; i<count; i++) {
                [buffer addObject:self.messageArray[i]];
            }
            [NaNaMessageModel serializeModel:buffer withFileName:[NSString stringWithFormat:@"%d.msg",self.otherProfile.userID]];
        }
    }
}

-(void) messageDate{
    if (nil != self.messageArray && [self.messageArray count] != 0) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.messageArray];
        NSDate *today = [NSDate date];
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
        NSString *todayString = [[today description] substringToIndex:10];
        NSString *yesterdayString = [[yesterday description] substringToIndex:10];
        int five = 300;

        for (int i = 0; i<[self.messageArray count]; i++) {
            NaNaMessageModel *model = (NaNaMessageModel *)[self.messageArray objectAtIndex:i];
            NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:model.creattime];
            NSString *currentDate = [[messageDate description] substringToIndex:10];
            i+=1;
            NaNaMessageModel *next;
            while (i<[self.messageArray count]) {
                next = (NaNaMessageModel *)[self.messageArray objectAtIndex:i];
                if (next.creattime - model.creattime >= five) {
                    break;
                }else{
                    i++;
                }
            }
            
            NaNaMessageDateModel *dateModel = [[NaNaMessageDateModel alloc] init];
            dateModel.date = model.creattime;
            if([currentDate isEqualToString:todayString]){
                dateModel.type = kToday;
            }else if ([currentDate isEqualToString:yesterdayString]){
                dateModel.type = kYesterday;
            }else{
                dateModel.type = kOtherDay;
            }
            NSUInteger row = [tempArray indexOfObject:model];
            [tempArray insertObject:dateModel atIndex:row];
        }
        self.meesageAndDate = [NSArray arrayWithArray:tempArray];
    }
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	[self.chatTableView reloadData];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.messageTextField resignFirstResponder];
    self.messageTextField.inputView = nil;
    [self move:YES toolbarHeight:0];
}

- (void)leftItemPressed:(UIButton *)btn
{
    [self.timer invalidate];
    self.timer = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger )getCurrentKeyboardStatus{
    NSInteger tag = 0;
    if (_messageTextField.inputView == _faceAndeOtherView){
        if (_faceAndeOtherView.viewType == FaceType) {
            tag = 1;
        }else{
            tag = 2;
        }
    }
    return tag;
}

-(void)otherAction:(UIButton *)sender
{
    NSInteger keyboardStatus = [self getCurrentKeyboardStatus];
    UIButton *btn = (UIButton *)[_defaultView viewWithTag:0xbfc];
    switch (keyboardStatus)
    {
        case 0://系统->其他
        {
            [self.messageTextField resignFirstResponder];
            BOOL toolbarIsBottom = CGRectGetMinY(_toolbar.frame) == CGRectGetHeight(_defaultView.frame) - CGRectGetHeight(self.navBarView.frame);
            ULog(@"%d",toolbarIsBottom);
            double delayInSeconds = toolbarIsBottom ? 0 : 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [btn setBackgroundImage:[UIImage imageNamed:@"chat_face.png"] forState:UIControlStateNormal];
                _messageTextField.inputView = _faceAndeOtherView;
                if (_faceAndeOtherView.viewType != OtherType)
                {
                    [_faceAndeOtherView showFaceAndeOther:OtherType animation:NO];
                }
                [self.messageTextField becomeFirstResponder];
            });
        }
            break;
        case 1://表情->其他
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"chat_face.png"] forState:UIControlStateNormal];
            [_faceAndeOtherView showFaceAndeOther:OtherType animation:YES];
        }
            break;
    }
}

-(void)faceAction:(UIButton *)sender
{
    
    NSInteger keyboardStatus = [self getCurrentKeyboardStatus];
    switch (keyboardStatus)
    {
        case 0://系统->表情
        {
            [self.messageTextField resignFirstResponder];
            BOOL toolbarIsBottom = CGRectGetMinY(_toolbar.frame) == CGRectGetHeight(_defaultView.frame) - CGRectGetHeight(self.navBarView.frame);
            ULog(@"%d",toolbarIsBottom);
            double delayInSeconds = toolbarIsBottom ? 0 : 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [sender setBackgroundImage:[UIImage imageNamed:@"chat_keyboard.png"] forState:UIControlStateNormal];
                _messageTextField.inputView = _faceAndeOtherView;
                if (_faceAndeOtherView.viewType != OtherType)
                {
                    [_faceAndeOtherView showFaceAndeOther:FaceType animation:NO];
                }
                [self.messageTextField becomeFirstResponder];
            });
        }
            break;
        case 2:// 其他->表情
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"chat_keyboard.png"] forState:UIControlStateNormal];
            [_faceAndeOtherView showFaceAndeOther:FaceType animation:YES];
        }
            break;
        case 1:// 表情->系统
        {
            [self.messageTextField resignFirstResponder];
            self.messageTextField.inputView = nil;
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [sender setBackgroundImage:[UIImage imageNamed:@"chat_face.png"] forState:UIControlStateNormal];
                [self.messageTextField becomeFirstResponder];
            });
        }
            break;
    }

}

//通过UDP,发送消息
-(void)sendMassage:(NSString *)message{
    [[NaNaUIManagement sharedInstance] sendMessage:message withTarGetID:self.otherProfile.userID];
    NaNaMessageModel *model = [[NaNaMessageModel alloc] init];
    model.content = message;
    model.creattime = 0;
    model.isBlongMe = YES;
    model.state = kSending;
    UIView *returnView =  [self assembleMessageAtIndex:message from:YES];
    model.height = returnView.frame.size.height + 50.0f;
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.sendingMessageArray];
    [temp addObject:model];
    self.sendingMessageArray = [[NSArray alloc] initWithArray:temp];
}

- (void)didSelectSendMessage
{
    if (_messageTextField.text.length)
    {
        [self sendMassage:_messageTextField.text];
    }
	self.messageTextField.text = @"";
	[_messageTextField resignFirstResponder];
    self.messageTextField.inputView = nil;
    [self move:YES toolbarHeight:0];
}

- (void)didSelectFace:(NSString *)face
{
    NSMutableString *tem = [NSMutableString stringWithString:_messageTextField.text];
    [tem appendString:face];
    [self.messageTextField setText:tem];
}

- (void)didSelectDelete
{
  NSMutableString *tem = [NSMutableString stringWithString:_messageTextField.text];
    if ([tem hasSuffix:END_FLAG])
    {
        NSArray *temArray = [tem componentsSeparatedByString:BEGIN_FLAG];
        NSString *subString =[temArray lastObject];
        NSRange range = [tem rangeOfString:[NSString stringWithFormat:@"%@%@",BEGIN_FLAG,subString] options:NSBackwardsSearch];
        [tem deleteCharactersInRange:range];
        [self.messageTextField setText:tem];
    }
    else if (tem.length >= 1)
    {
        
        [tem deleteCharactersInRange:NSMakeRange(tem.length-1, 1)];
        [self.messageTextField setText:tem];
    }
}

- (void)didSelectOtherOption:(OtherActionOptions)option
{
    switch (option) {
        case OptionsPhoth:
            ULog(@"照片");
            break;
        case OptionsPhotograph:
            ULog(@"拍照");
            break;
        case OptionsGift:{
            PresentGiftViewController *presentGift = [[PresentGiftViewController alloc] initWithUserID:self.otherProfile.userID];
            [self.navigationController pushViewController:presentGift animated:YES];
            break;
        }
        case OptionsOnThings:{
            ULog(@"摸头");
            [[NaNaUIManagement sharedInstance] touchHead:self.otherProfile.userID];
            break;
        }
        case OptionsKey:{
            ULog(@"钥匙");
            [[NaNaUIManagement sharedInstance] giveKey:self.otherProfile.userID];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark Table View DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.meesageAndDate count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([[self.meesageAndDate objectAtIndex:[indexPath row]] isMemberOfClass:[NaNaMessageDateModel class]]){
		return 30;
	}else{
        NaNaMessageModel *model = self.meesageAndDate[indexPath.row];
        if ([model.type isEqualToString:@"文字消息"]) {
            return model.height;
        }else{
            return 30.0f;
        }
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *chatCellIdentifier = @"chatCellIdentifier";
    static NSString *dateCellIdentifier = @"dateCellIdentifier";
    static NSString *giftCellIdentifier = @"giftCellIdentifier";
	UITableViewCell *chatCell = [tableView dequeueReusableCellWithIdentifier:chatCellIdentifier];
    UITableViewCell *dateCell = [tableView dequeueReusableCellWithIdentifier:dateCellIdentifier];
    UITableViewCell *giftCell = [tableView dequeueReusableCellWithIdentifier:giftCellIdentifier];
    UITableViewCell *cell = nil;
    
    if ([[self.meesageAndDate objectAtIndex:[indexPath row]] isMemberOfClass:[NaNaMessageDateModel class]]){
        NaNaMessageDateModel *date = [self.meesageAndDate objectAtIndex:[indexPath row]];
        if (!dateCell){
            dateCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dateCellIdentifier];
            dateCell.selectionStyle = UITableViewCellSelectionStyleNone;
            dateCell.backgroundColor = [UIColor clearColor];
        }
        cell = dateCell;
        
        UILabel *dateL = (UILabel *)[cell.contentView viewWithTag:0xFB];
        if (!dateL){
            dateL = [[UILabel alloc] initWithFrame:CGRectZero];
            dateL.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            dateL.font = [UIFont systemFontOfSize:12];
            dateL.textAlignment = NSTextAlignmentCenter;
            dateL.tag = 0xFB;
            [cell.contentView addSubview:dateL];
        }
        NSMutableString *timeString;
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:date.date];
        if (date.type == kToday) {
            [formatter setDateFormat:@"HH:mm"];
            timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:currentDate]];
        }else if(date.type == kYesterday){
            [formatter setDateFormat:@"HH:mm"];
            timeString = [NSMutableString stringWithFormat:@"昨天 %@",[formatter stringFromDate:currentDate]];
        }else{
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:currentDate]];
        }
        [dateL setText:timeString];
        dateL.frame = CGRectMake((320-[timeString sizeWithFont:dateL.font].width)/2-5, 10, [timeString sizeWithFont:dateL.font].width+10, 20);
        dateL.alpha = 0.7f;
        dateL.layer.cornerRadius = 5;
        dateL.layer.masksToBounds = YES;
        dateL.textColor = [UIColor whiteColor];
	}else{
        
        NaNaMessageModel *model = self.meesageAndDate[indexPath.row];
        if ([model.type isEqualToString:@"文字消息"]) {
            if (!chatCell){
                chatCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatCellIdentifier];
                chatCell.selectionStyle = UITableViewCellSelectionStyleNone;
                chatCell.backgroundColor = [UIColor clearColor];
            }
            cell = chatCell;
            
            UIView *chatView = [cell.contentView viewWithTag:0xFD];
            [chatView removeFromSuperview];
            chatView = nil;
            if (!chatView){
                chatView = [[UIView alloc] initWithFrame:CGRectZero];
                chatView.tag = 0xFD;
                [cell.contentView addSubview:chatView];
            }
            
            // Set up the cell...
            UIView *chatV = [self bubbleView:model];
            [chatView setFrame:CGRectMake(0, 0, 320, CGRectGetHeight(chatV.frame))];
            [chatView addSubview:chatV];
        }else{
            if (!giftCell) {
                giftCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:giftCellIdentifier];
                giftCell.selectionStyle = UITableViewCellSelectionStyleNone;
                giftCell.backgroundColor = [UIColor clearColor];
            }
            cell = giftCell;
            UILabel *giftLabel = (UILabel *)[cell.contentView viewWithTag:0xFE];
            if (!giftLabel){
                giftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                giftLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
                giftLabel.font = [UIFont systemFontOfSize:12];
                giftLabel.textAlignment = NSTextAlignmentCenter;
                giftLabel.tag = 0xFE;
                [cell.contentView addSubview:giftLabel];
            }
            [giftLabel setText:model.content];
            giftLabel.frame = CGRectMake((320-[model.content sizeWithFont:giftLabel.font].width)/2-5, 10, [model.content sizeWithFont:giftLabel.font].width+10, 20);
            giftLabel.alpha = 0.7f;
            giftLabel.layer.cornerRadius = 5;
            giftLabel.layer.masksToBounds = YES;
            giftLabel.textColor = [UIColor whiteColor];
        }
	}
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.messageTextField resignFirstResponder];
    self.messageTextField.inputView = nil;
    [self move:YES toolbarHeight:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.messageTextField resignFirstResponder];
    self.messageTextField.inputView = nil;
    [self move:YES toolbarHeight:0];
}

#pragma mark -
#pragma mark TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length){
        [self sendMassage:textField.text];
    }
    _messageTextField.text = @"";
    [textField resignFirstResponder];
    self.messageTextField.inputView = nil;
    [self move:YES toolbarHeight:0];
    return NO;
}

/*
 生成泡泡UIView
 */
#pragma mark -
#pragma mark Table view methods
//- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf
-(UIView *)bubbleView : (NaNaMessageModel *)messageModel{
    NSString *text = messageModel.content;
    BOOL fromSelf = messageModel.isBlongMe;
	
    // 聊天内容view
    UIView *returnView =  [self assembleMessageAtIndex:text from:fromSelf];
    
    // 头像、气泡、聊天内容 view
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectZero];
    cellView.backgroundColor = [UIColor clearColor];
    // 气泡
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubble_self2":@"bubble_friend2" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:10.0f topCapHeight:22.0f]];
    // 头像
    CircleImageButton *headImageView = [[CircleImageButton alloc] init];
    
    if(fromSelf){
        // 内容
        returnView.frame= CGRectMake(8.0f, 20.0f, returnView.frame.size.width, returnView.frame.size.height);
        // 气泡
        bubbleImageView.frame = CGRectMake(-7.0f, 15.0f, returnView.frame.size.width + 30.0f, returnView.frame.size.height + 10.0f);
        // 所有内容
        cellView.frame = CGRectMake(265.0f-bubbleImageView.frame.size.width - 10.0f, 0.0f,bubbleImageView.frame.size.width + 50.0f, bubbleImageView.frame.size.height+30.0f);
        // 头像
        headImageView = [[CircleImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"head_bg.png"] withFrame:CGRectMake(bubbleImageView.frame.size.width, 0.0f, 57.0f, 57.0f)];
        [headImageView setImageURL:[NSURL URLWithString:messageModel.avatar]];
    }else{
        // 内容
        returnView.frame= CGRectMake(79.0f, 22.0f, returnView.frame.size.width, returnView.frame.size.height);
        // 气泡
        bubbleImageView.frame = CGRectMake(64.0f, 17.0f, returnView.frame.size.width + 30.0f, returnView.frame.size.height+10.0f);
		// 所有内容
        cellView.frame = CGRectMake(10.0f, 0.0f, bubbleImageView.frame.size.width + 50.0f,bubbleImageView.frame.size.height + 30.0f);
        // 头像
        headImageView = [[CircleImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"head_bg.png"] withFrame:CGRectMake(0.0f,0.0f, 57.0f, 57.0f)];
        [headImageView setImageURL:[NSURL URLWithString:messageModel.avatar]];
    }
    
    [cellView addSubview:bubbleImageView];
    [cellView addSubview:headImageView];
    [cellView addSubview:returnView];
    
	return cellView;
}

//图文混排
-(void)getImageRange:(NSString*)message tempArray:(NSMutableArray*)array
{
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0)
    {
        if (range.location > 0)
        {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str tempArray:array];
        }
        else
        {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""])
            {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str tempArray:array];
            }
            else
            {
                return;
            }
        }
    }
    else if (message != nil)
    {
        [array addObject:message];
    }
}

-(UIView *)assembleMessageAtIndex:(NSString *) message from:(BOOL)fromself
{
    CGFloat contentWidth = 0;
    CGFloat contentHeight = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *subViewAndLabelArray = [[NSMutableArray alloc] init];
    [self getImageRange:message tempArray:array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    if (data)
    {
        for (int i=0;i < [data count];i++)
        {
            NSString *str=[data objectAtIndex:i];
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                }
                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX=KFacialSizeWidth+upX;
                contentWidth = MAX(upX, contentWidth);
                [subViewAndLabelArray addObject:img];
            } else {
                for (int j = 0; j < [str length]; j++)
                {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    //la.backgroundColor = [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1.0f];
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX= upX + size.width;
                    contentWidth = MAX(upX, contentWidth);
                    [subViewAndLabelArray addObject:la];
                }
            }
        }
    }
    // 需要将该view的尺寸记下，方便以后使用
    contentHeight = CGRectGetMaxY([[subViewAndLabelArray lastObject] frame]);
    returnView.frame = CGRectMake(15.0f, 1.0f, contentWidth, contentHeight);
    return returnView;
}

@end

