//
//  MessageInfoData.h
//  NaNa
//
//  Created by dengfang on 13-8-7.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInfoData : NSObject <NSCoding>

// 消息id
@property (nonatomic, copy) NSString *messageId;

// 头像URL
@property (nonatomic, copy) NSString *iconUrl;

// 用户名称
@property (nonatomic, copy) NSString *userName;

// 消息内容
@property (nonatomic, copy) NSString *message;

// 消息时间
@property (nonatomic, copy) NSString *time;


// 根据字典，解析当前分类下的数据
- (MessageInfoData *)createByDictionary:(NSDictionary *)dict;

// 根据数组，解析当前分类下的数据
- (NSMutableArray *)createByArray:(NSArray *)array;
@end
