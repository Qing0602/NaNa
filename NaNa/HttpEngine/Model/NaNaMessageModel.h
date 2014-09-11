//
//  NaNaMessageModel.h
//  NaNa
//
//  Created by singlew on 14-9-11.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaUIModelCoding.h"

@interface NaNaMessageModel : NaNaUIModelCoding
/*
 "content": "\u4f60\u597d",//string会话内容
 "createdate": "2014-07-29",//string发言日期
 "createtime": 1406646714,//int发送的时间戳
 "source": "HER"//string发送消息者，如果是本人为MINE，如果为对方为HER
 */
@property (nonatomic,strong) NSString *content;
@property (nonatomic) int creattime;
@property (nonatomic) BOOL isBlongMe;

-(void) coverJson : (NSDictionary *) json;
@end
