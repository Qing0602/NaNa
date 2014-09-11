//
//  NaNaUserProfileModel.m
//  NaNa
//
//  Created by singlew on 14-9-11.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaUserProfileModel.h"

@implementation NaNaUserProfileModel
-(NaNaUserProfileModel *) converJson : (NSDictionary *) json{
    NaNaUserProfileModel *model = [[NaNaUserProfileModel alloc] init];
    /*
     "avatar": "47848305cd654f1a10c58c5dab99759d",//string头像地址
     "background": "47848305cd654f1a10c58c5dab99759d",//string背景地址
     "birthday": "2014-06-17",//string生日时间
     "charm": 60,//int魅力值
     "city_id": 2,//int城市ID
     "city_name": "\u9999\u6e2f",//string城市名称
     "id": 5,//int用户ID
     "mood": "",//string最近发布的心情
     "nickname": "aaa",//string用户昵称
     "role": 1,//int用户角色，0为P，1为T，2为H
     "title": "\u571f\u8c6a",//string用户头衔
     "vip_time": 1392473283,//int用户vip到期时间
     "voice": "c4c015f8fbf7a69e843ef007f2a866aa"//string用户声音地址
     */

    if (json[@"avatar"]!= [NSNull null] && json[@"avatar"] != nil) {
        self.userAvatarURL = json[@"avatar"];
    }
    if (json[@"background"]!= [NSNull null] && json[@"background"] != nil) {
        self.userBackGroundURL = json[@"background"];
    }
    if (json[@"birthday"] != [NSNull null]) {
        self.userBirthday = [json[@"birthday"] integerValue];
    }
    if (json[@"charm"] != [NSNull null]) {
        self.userCharm = [json[@"charm"] integerValue];
    }
    if (json[@"city_id"] != [NSNull null]) {
        self.userCityID = [json[@"city_id"] integerValue];
    }
    if (json[@"city_name"]!= [NSNull null] && json[@"city_name"] != nil) {
        self.userCityName = json[@"city_name"];
    }
    if (json[@"id"] != [NSNull null]) {
        self.userID = [json[@"id"] integerValue];
    }
    if (json[@"nickname"]!= [NSNull null] && json[@"nickname"] != nil) {
        self.userNickName = json[@"nickname"];
    }
    return model;
}
@end
