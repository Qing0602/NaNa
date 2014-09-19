//
//  NaNaMessageModel.h
//  NaNa
//
//  Created by singlew on 14-9-11.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaUIModelCoding.h"

typedef enum{
    kNone,
    kSending,
    kSend,
    kFail,
}MessageState;

@interface NaNaMessageModel : NaNaUIModelCoding
/*
 "content": "\u4f60\u597d",//string会话内容
 "createdate": "2014-07-29",//string发言日期
 "createtime": 1406646714,//int发送的时间戳
 "createmicrotime": 1406646714123,//int发送的时间戳,毫秒为单位，13位
 "source": "HER"//string发送消息者，如果是本人为MINE，如果为对方为HER
 */
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic) int creattime;
@property (nonatomic) BOOL isBlongMe;
@property (nonatomic) int height;
@property (nonatomic) int state;
@property (nonatomic) long long createmicrotime;

-(void) coverJson : (NSDictionary *) json;
@end
