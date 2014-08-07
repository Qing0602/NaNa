//
//  NaNaUserAccountModel.m
//  NaNa
//
//  Created by singlew on 14-7-31.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaUserAccountModel.h"

@implementation NaNaUserAccountModel

-(BOOL) convertForDic : (NSDictionary *) dic{
    if (nil != dic) {
        if (dic[@"nana_id"] != nil) {
            self.NaNaID = dic[@"nana_id"];
        }
        if (dic[@"user_id"] != nil) {
            self.UserID = [dic[@"user_id"] integerValue];
        }
        if (dic[@"seckey"] != nil) {
            self.seckey = dic[@"seckey"];
        }
        return YES;
    }
    return NO;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.NaNaID forKey:@"NaNaID"];
    [aCoder encodeInteger:self.UserID forKey:@"UserID"];
    [aCoder encodeObject:self.seckey forKey:@"seckey"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (nil != self) {
        self.NaNaID = [aDecoder decodeObjectForKey:@"NaNaID"];
        self.UserID = [aDecoder decodeIntegerForKey:@"UserID"];
        self.seckey = [aDecoder decodeObjectForKey:@"seckey"];
    }
    return self;
}


@end
