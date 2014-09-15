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

#define TOOLBARTAG		200
#define TABLEVIEWTAG	300

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 150

#define BEGIN_FLAG @"[/"
#define END_FLAG @"]"

@interface ChatVC ()
@property (nonatomic,strong) NaNaUserProfileModel *otherProfile;
@property (nonatomic,strong) NSArray *messageArray;
@property (nonatomic,strong) NSArray *sendingMessageArray;
@property (nonatomic) BOOL isMore;
@property (nonatomic,strong) NSTimer *timer;
-(void) handleTimerGetNewMessage :(NSTimer *)theTimer;
-(void) messageBuffer;
@end

@implementation ChatVC

@synthesize chatArray = _chatArray;
@synthesize chatTableView = _chatTableView;
@synthesize messageTextField = _messageTextField;
@synthesize udpSocket = _udpSocket;
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
}

-(void) dealloc{
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"messagesDic"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"sendMessageResult"];
    [[NaNaUIManagement sharedInstance] removeObserver:self forKeyPath:@"historyMessage"];
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
    
    self.title = self.otherProfile.userNickName;
    self.isMore = YES;
    self.messageArray = [[NSArray alloc] init];
    self.messageArray = [NaNaMessageModel deserializeModel:[NSString stringWithFormat: @"%d.msg",self.otherProfile.userID]];
    self.sendingMessageArray = [[NSArray alloc] init];
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
    textFieldBg.image = [UIImage imageNamed:@"chat_textfield_bg.png"];
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
}

-(void) handleTimerGetNewMessage :(NSTimer *)theTimer{
    [[NaNaUIManagement sharedInstance] getNewMessageWithTargetID:self.otherProfile.userID];
}

-(void) refreshMeetData{
    __weak ChatVC *weakSelf = self;
    // 如果有历史聊天数据，但是当前设备获取不到timestamp如何处理？
    if (weakSelf.messageArray != nil && [weakSelf.messageArray count] != 0) {
        NaNaMessageModel *model = weakSelf.messageArray[0];
        [[NaNaUIManagement sharedInstance] getHistoryMessageWithTargetID:weakSelf.otherProfile.userID withTimeStemp:model.creattime];
    }else{
        if (self.chatTableView.pullToRefreshView.state == SVPullToRefreshStateLoading ||
            self.chatTableView.pullToRefreshView.state == SVPullToRefreshStateTriggered) {
            [self.chatTableView.pullToRefreshView stopAnimating];
        }
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
                UIView *returnView =  [self assembleMessageAtIndex:msg.content from:msg.isBlongMe];
                msg.height = returnView.frame.size.height + 80.0f;
                [msgArray addObject:msg];
            }
            self.messageArray = [[NSArray alloc] initWithArray:msgArray];
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
                    msg.creattime = [data[@"creattime"] integerValue];
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
            
            [self.chatTableView reloadData];
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messageArray count]-1 inSection:0]
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
                [temp addObject:model];
            }
            [temp addObjectsFromArray:self.messageArray];
            self.messageArray = [[NSArray alloc] initWithArray:temp];
            self.isMore = [dic[@"more"] boolValue];
            [self.chatTableView reloadData];
        }
        if (self.chatTableView.pullToRefreshView.state == SVPullToRefreshStateLoading ||
            self.chatTableView.pullToRefreshView.state == SVPullToRefreshStateTriggered) {
            [self.chatTableView.pullToRefreshView stopAnimating];
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

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	[self openUDPServer];
	[self.chatTableView reloadData];
}

- (void)leftItemPressed:(UIButton *)btn
{
    [self.timer invalidate];
    self.timer = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.navigationController popViewControllerAnimated:YES];
}

//建立基于UDP的Socket连接
-(void)openUDPServer{
	//初始化udp
	AsyncUdpSocket *tempSocket=[[AsyncUdpSocket alloc] initWithDelegate:self];
	self.udpSocket=tempSocket;
	//绑定端口
	NSError *error = nil;
	[self.udpSocket bindToPort:4333 error:&error];
    [self.udpSocket joinMulticastGroup:@"224.0.0.1" error:&error];
    
   	//启动接收线程
	[self.udpSocket receiveWithTimeout:-1 tag:0];
    
}

- (NSInteger )getCurrentKeyboardStatus
{
    NSInteger tag = 0;
    if (_messageTextField.inputView == _faceAndeOtherView)
    {
        if (_faceAndeOtherView.viewType == FaceType) {
            tag = 1;
        }
        else
        {
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
    model.height = returnView.frame.size.height + 80.0f;
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.sendingMessageArray];
    [temp addObject:model];
    self.sendingMessageArray = [[NSArray alloc] initWithArray:temp];
    /*
	NSDate *nowTime = [NSDate date];
	NSMutableString *sendString=[NSMutableString stringWithCapacity:100];
	[sendString appendString:message];
	//开始发送
	BOOL res = [self.udpSocket sendData:[sendString dataUsingEncoding:NSUTF8StringEncoding]
								 toHost:@"224.0.0.1"
								   port:4333
							withTimeout:-1
                                    tag:0];
    
   	if (!res)
    {
        [UAlertView showAlertViewWithMessage:@"发送失败" delegate:nil cancelButton:@"确定" defaultButton:nil];
        return;
	}
	
	if ([self.chatArray lastObject] == nil)
    {
		self.lastTime = nowTime;
		[self.chatArray addObject:nowTime];
	}
	// 发送后生成泡泡显示出来
	NSTimeInterval timeInterval = [nowTime timeIntervalSinceDate:self.lastTime];
	if (timeInterval > 60*5)
    {
		self.lastTime = nowTime;
		[self.chatArray addObject:nowTime];
	}
    UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"陆小凤",nil), message]
								   from:YES];
	[self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:message, @"text", @"self", @"speaker", chatView, @"view", nil]];
    
	[self.chatTableView reloadData];
	[self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0]
							  atScrollPosition:UITableViewScrollPositionBottom
									  animated:YES];
     */
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
        case OptionsGift:
            ULog(@"礼物");
            break;
        case OptionsOnThings:
            ULog(@"摸头");
            break;
        case OptionsKey:
            ULog(@"钥匙");
            break;
        default:
            break;
    }
}

#pragma mark - UDP Delegate Methods
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
//    ULog(@"host---->%@",host);
//    [self.udpSocket receiveWithTimeout:-1 tag:0];
//   	//接收到数据回调，用泡泡VIEW显示出来
//	NSString *info=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
//    UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@:%@",@"西门吹雪", info]
//								   from:NO];
//	[self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:info, @"text", @"other", @"speaker", chatView, @"view", nil]];
//	[self.chatTableView reloadData];
//	[self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0]
//							  atScrollPosition: UITableViewScrollPositionBottom
//									  animated:YES];
//	//已经处理完毕
	return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	//无法发送时,返回的异常提示信息
    [UAlertView showAlertViewWithMessage:[error description] delegate:nil cancelButton:@"确定" defaultButton:nil];
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
	//无法接收时，返回异常提示信息
    [UAlertView showAlertViewWithMessage:[error description] delegate:nil cancelButton:@"确定" defaultButton:nil];
}

#pragma mark -
#pragma mark Table View DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    int i = 0;
//    for (NaNaMessageModel *model in self.messageArray) {
//        if (model.state == kSend) {
//            i++;
//        }
//    }
    return [self.messageArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if ([[self.messageArray objectAtIndex:[indexPath row]] isKindOfClass:[NSDate class]]){
		return 30;
	}
    else{
        NaNaMessageModel *model = self.messageArray[indexPath.row];
        return model.height + 10.0f;
//		UIView *chatView = [[self.chatArray objectAtIndex:[indexPath row]] objectForKey:@"view"];
//		return chatView.frame.size.height + 10;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *chatCellIdentifier = @"chatCellIdentifier";
    static NSString *dateCellIdentifier = @"dateCellIdentifier";
	UITableViewCell *chatCell = [tableView dequeueReusableCellWithIdentifier:chatCellIdentifier];
    UITableViewCell *dateCell = [tableView dequeueReusableCellWithIdentifier:dateCellIdentifier];
    UITableViewCell *cell = nil;
    
    if ([[self.messageArray objectAtIndex:[indexPath row]] isKindOfClass:[NSDate class]]){
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
		NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:[self.chatArray objectAtIndex:[indexPath row]]]];
        [dateL setText:timeString];
        dateL.frame = CGRectMake((320-[timeString sizeWithFont:dateL.font].width)/2-5, 5, [timeString sizeWithFont:dateL.font].width+10, 20);
        dateL.layer.cornerRadius = 5;

	}else{
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
        NaNaMessageModel *model = self.messageArray[indexPath.row];
		UIView *chatV = [self bubbleView:model];
        [chatView setFrame:CGRectMake(0, 0, 320, CGRectGetHeight(chatV.frame))];
        [chatView addSubview:chatV];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length)
    {
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
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubble_self":@"bubble_friend" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
    // 头像
    UIImageView *headImageView = [[UIImageView alloc] init];
    
    if(fromSelf)
    {
        // 内容
        returnView.frame= CGRectMake(15.0f, 15.0f, returnView.frame.size.width, returnView.frame.size.height);
        // 气泡
        bubbleImageView.frame = CGRectMake(0.0f, 10.0f, returnView.frame.size.width + 30.0f, returnView.frame.size.height + 10.0f);
        // 所有内容
        cellView.frame = CGRectMake(265.0f-bubbleImageView.frame.size.width, 0.0f,bubbleImageView.frame.size.width + 50.0f, bubbleImageView.frame.size.height+30.0f);
        // 头像
        [headImageView setImage:[UIImage imageNamed:@"one_self_icon.png"]];
        headImageView.frame = CGRectMake(bubbleImageView.frame.size.width, 0.0f, 50.0f, 50.0f);
    }
	else
    {
        // 内容
        returnView.frame= CGRectMake(65.0f, 15.0f, returnView.frame.size.width, returnView.frame.size.height);
        // 气泡
        bubbleImageView.frame = CGRectMake(50.0f, 10.0f, returnView.frame.size.width + 30.0f, returnView.frame.size.height+10.0f);
		// 所有内容
        cellView.frame = CGRectMake(0.0f, 0.0f, bubbleImageView.frame.size.width + 50.0f,bubbleImageView.frame.size.height + 30.0f);
        // 头像
        [headImageView setImage:[UIImage imageNamed:@"friends_icon.png"]];
        headImageView.frame = CGRectMake(0.0f,0.0f, 50.0f, 50.0f);
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

