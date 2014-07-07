//
//  MessageInfoData.m
//  NaNa
//
//  Created by dengfang on 13-8-7.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "MessageInfoData.h"

@implementation MessageInfoData

@synthesize messageId, iconUrl, userName, message, time;
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.messageId forKey:@"messageId"];
    [aCoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.time forKey:@"time"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.messageId = [aDecoder decodeObjectForKey:@"messageId"];
        self.iconUrl = [aDecoder decodeObjectForKey:@"iconUrl"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.message = [aDecoder decodeObjectForKey:@"message"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
    }
    return self;
}

- (void)dealloc {
    self.messageId = nil;
    self.iconUrl = nil;
    self.userName = nil;
    self.message = nil;
    self.time = nil;
    [super dealloc];
}

#pragma mark - create
// 根据字典，解析当前分类下的数据
- (MessageInfoData *)createByDictionary:(NSDictionary *)dict {
    MessageInfoData *messageInfo = nil;
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        messageInfo = [[[MessageInfoData alloc] init] autorelease];
        messageInfo.iconUrl = [dict objectForKey:@"iconUrl"];
        messageInfo.userName = [dict objectForKey:@"userName"];
        messageInfo.message = [dict objectForKey:@"message"];
        messageInfo.time = [dict objectForKey:@"time"];
    }
    return messageInfo;
}

// 根据数组，解析当前分类下的数据
- (NSMutableArray *)createByArray:(NSArray *)array {
    NSMutableArray *messageArray = [[[NSMutableArray alloc] init] autorelease];
    if ([array isKindOfClass:[NSArray class]]) {
        for (NSDictionary *messageDict in array) {
            MessageInfoData *messageInfo = [self createByDictionary:messageDict];
            if (messageInfo) {
                [messageArray addObject:messageInfo];
            }
        }
    }
    return messageArray;
}
@end
