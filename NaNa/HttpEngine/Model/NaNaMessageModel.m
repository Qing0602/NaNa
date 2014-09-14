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
    
    if (json[@"createtime"] != [NSNull null]) {
        self.creattime = [json[@"createtime"] integerValue];
    }
    
    if (json[@"source"] != [NSNull null] && json[@"source"] != nil) {
        NSString *source = json[@"source"];
        if ([source isEqualToString:@"HER"]) {
            self.isBlongMe = NO;
        }else{
            self.isBlongMe = YES;
        }
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeInteger:self.creattime forKey:@"creattime"];
    [aCoder encodeBool:self.isBlongMe forKey:@"isBlongMe"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (nil != self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.creattime = [aDecoder decodeIntegerForKey:@"creattime"];
        self.isBlongMe = [aDecoder decodeBoolForKey:@"isBlongMe"];
    }
    return self;
}

@end
