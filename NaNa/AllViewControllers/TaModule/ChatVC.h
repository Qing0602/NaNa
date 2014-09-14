//
//  ChatViewController.h
//  NaNa
//
//  Created by ubox  on 14-1-13.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UBasicViewController.h"
#import "AsyncUdpSocket.h"
#import "FaceAndOther.h"
#import "NaNaUserProfileModel.h"
#import "NaNaMessageModel.h"

@interface ChatVC : UBasicViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,FaceAndOtherDelegate>
{
	NSString                   *_phraseString;
	NSMutableArray		       *_chatArray;
	
	UITableView                *_chatTableView;
	UITextField                *_messageTextField;
    
	AsyncUdpSocket             *_udpSocket;
	NSDate                     *_lastTime;
    UIView                     *_toolbar;
    
    FaceAndOther              *_faceAndeOtherView;
}

@property (nonatomic, retain) UITableView            *chatTableView;
@property (nonatomic, retain) UITextField            *messageTextField;
@property (nonatomic, retain) NSString               *phraseString;
@property (nonatomic, retain) NSString               *titleString;
@property (nonatomic, retain) NSMutableArray		 *chatArray;
@property (nonatomic, retain) NSDate                 *lastTime;
@property (nonatomic, retain) AsyncUdpSocket         *udpSocket;

-(ChatVC *) initChatVC : (NaNaUserProfileModel *)otherProfileModel;
-(void)openUDPServer;
-(void)sendMassage:(NSString *)message;
//-(UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf;
-(UIView *)bubbleView : (NaNaMessageModel *)messageModel;
-(void)getImageRange:(NSString*)message tempArray:(NSMutableArray*)array;
-(UIView *)assembleMessageAtIndex:(NSString *)message from:(BOOL)fromself;


@end
