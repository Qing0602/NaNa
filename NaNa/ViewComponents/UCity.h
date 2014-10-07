//
//  UCity.h
//  Test
//
//  Created by 陈浩男 on 13-8-16.
//  Copyright (c) 2013年 陈浩男. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONKit.h"

#define UGetCurrentCityFinishedNotify   @"UGetCurrentCityFinishedNotify"
#define UGetSelectedCityFinishedNotify  @"UGetSelectedCityFinishedNotify"

@interface UCity : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
}

@property (nonatomic, assign) NSInteger cityID;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityType;
@property (nonatomic, retain) NSMutableArray *pinyinArray;

- (void)getCurrentCity;
- (NSMutableArray *)getHotCities;
- (NSMutableArray *)getAllCities;
- (NSMutableArray *)getSearchedCities;
+(UCity *)getCityByCityName:(NSString *)gpsCityName;
@end
