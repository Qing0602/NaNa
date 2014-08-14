//
//  MessageInfoData.m
//  NaNa
//
//  Created by dengfang on 13-8-7.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "MessageInfoData.h"

@interface MessageInfoData ()
// 根据字典，解析当前分类下的数据
- (MessageInfoData *)createByDictionary:(NSDictionary *)dict;
@end

@implementation MessageInfoData

/*
 // 头像
 @property (nonatomic, copy) NSString *avatarUrl;
 // 消息内容
 @property (nonatomic, copy) NSString *content;
 // 昵称
 @property (nonatomic, copy) NSString *nickname;
 // 未读消息数量
 @property (nonatomic) int count;
 // 消息时间
 @property (nonatomic, copy) NSString *createtime;
 // 发送人ID
 @property (nonatomic) int senderID;
 */

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatar"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeInt:self.count forKey:@"count"];
    [aCoder encodeInt:self.createtime forKey:@"createtime"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeInt:self.senderID forKey:@"senderID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.avatarUrl = [aDecoder decodeObjectForKey:@"avatar"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.count = [aDecoder decodeIntForKey:@"count"];
        self.createtime = [aDecoder decodeIntForKey:@"createtime"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.senderID = [aDecoder decodeIntForKey:@"senderID"];
    }
    return self;
}

#pragma mark - create
// 根据字典，解析当前分类下的数据
- (MessageInfoData *)createByDictionary:(NSDictionary *)dict {
    MessageInfoData *messageInfo = nil;
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        messageInfo = [[MessageInfoData alloc] init];
        messageInfo.avatarUrl = dict[@"avatar"];
        messageInfo.content = dict[@"content"];
        messageInfo.count = [dict[@"count"] intValue];
        messageInfo.createtime = [dict[@"createtime"] intValue];
        messageInfo.nickname = dict[@"nickname"];
        messageInfo.senderID = [dict[@"source_user_id"] intValue];
    }
    return messageInfo;
}

// 根据数组，解析当前分类下的数据
- (NSArray *)createByArray:(NSArray *)array {
    NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    if ([array isKindOfClass:[NSArray class]]) {
        for (NSDictionary *messageDict in array) {
            MessageInfoData *messageInfo = [self createByDictionary:messageDict];
            if (messageInfo) {
                [messageArray addObject:messageInfo];
            }
        }
    }
    return [NSArray arrayWithArray:messageArray];
}
@end
