//
//  NaNaMessageModel.m
//  NaNa
//
//  Created by singlew on 14-9-11.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaMessageModel.h"

@implementation NaNaMessageModel
/*
 "content": "\u4f60\u597d",//string会话内容
 "createdate": "2014-07-29",//string发言日期
 "createtime": 1406646714,//int发送的时间戳
 "source": "HER"//string发送消息者，如果是本人为MINE，如果为对方为HER
 */

-(void) coverJson : (NSDictionary *) json{
    if (json[@"content"] != [NSNull null] && json[@"content"] != nil) {
        self.content = json[@"content"];
    }
    
    if (json[@"createtime"] != [NSNull null] || json[@"createtime"] != nil) {
        self.creattime = [json[@"createtime"] longLongValue];
    }
    
    if (json[@"source"] != [NSNull null] && json[@"source"] != nil) {
        NSString *source = json[@"source"];
        if ([source isEqualToString:@"HER"]) {
            self.isBlongMe = NO;
        }else{
            self.isBlongMe = YES;
        }
    }
    
    if (json[@"createmicrotime"] != [NSNull null] || json[@"createmicrotime"] != nil) {
        self.createmicrotime = [json[@"createmicrotime"] longLongValue];
    }
    
    if (json[@"avatar"] != [NSNull null] || json[@"avatar"] != nil) {
        self.avatar = json[@"avatar"];
    }
    
    if (json[@"chat_type"] != [NSNull null] || json[@"chat_type"] != nil) {
        self.type = [json[@"chat_type"] integerValue];
    }
    
    self.height = 0.0f;
    self.state = kNone;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeInt64:self.creattime forKey:@"creattime"];
    [aCoder encodeBool:self.isBlongMe forKey:@"isBlongMe"];
    [aCoder encodeInteger:self.height forKey:@"height"];
    [aCoder encodeInt64:self.createmicrotime forKey:@"createmicrotime"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeInt64:self.type forKey:@"type"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (nil != self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.creattime = [aDecoder decodeInt64ForKey:@"creattime"];
        self.isBlongMe = [aDecoder decodeBoolForKey:@"isBlongMe"];
        self.height = [aDecoder decodeIntegerForKey:@"height"];
        self.createmicrotime = [aDecoder decodeInt64ForKey:@"createmicrotime"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
    }
    return self;
}

@end

@implementation NaNaMessageDateModel



@end
