//
//  MessageInfoData.h
//  NaNa
//
//  Created by dengfang on 13-8-7.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NaNaUIModelCoding.h"

@interface MessageInfoData : NaNaUIModelCoding

// 头像
@property (nonatomic, copy) NSString *avatarUrl;
// 消息内容
@property (nonatomic, copy) NSString *content;
// 昵称
@property (nonatomic, copy) NSString *nickname;
// 未读消息数量
@property (nonatomic) int count;
// 消息时间
@property (nonatomic) int createtime;
// 发送人ID
@property (nonatomic) int senderID;



// 根据数组，解析当前分类下的数据
- (NSArray *)createByArray:(NSArray *)array;
@end
