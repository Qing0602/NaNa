//
//  NaNaUserProfileModel.h
//  NaNa
//
//  Created by singlew on 14-9-11.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaUIModelCoding.h"

typedef enum{
    kP,
    kT,
    kH,
}UserRole;

@interface NaNaUserProfileModel : NaNaUIModelCoding
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

@property (nonatomic,strong) NSString *userAvatarURL;
@property (nonatomic,strong) NSString *userBackGroundURL;
@property (nonatomic) NSString *userBirthday;
@property (nonatomic) int userCharm;
@property (nonatomic) int userCityID;
@property (nonatomic,strong) NSString *userCityName;
@property (nonatomic) int userID;
@property (nonatomic,strong) NSString *userNickName;
@property (nonatomic) int role;
@property (nonatomic,strong) NSString *voiceURL;
-(NaNaUserProfileModel *) converJson : (NSDictionary *) json;
@end
