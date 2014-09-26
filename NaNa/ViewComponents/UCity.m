//
//  UCity.m
//  Test
//
//  Created by 陈浩男 on 13-8-16.
//  Copyright (c) 2013年 陈浩男. All rights reserved.
//

#import "UCity.h"

@implementation UCity

@synthesize cityID;
@synthesize cityName;
@synthesize pinyinArray;
@synthesize cityType;


#pragma mark - location
- (void)getCurrentCity {
    _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1000.0f;
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
        for (CLPlacemark *placemark in placemarks) {
            NSString *city = [placemark locality];
            if (!city) {
                city = [placemark administrativeArea];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:UGetCurrentCityFinishedNotify
                                                                object:city];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

#pragma mark - getCity
- (NSMutableArray *)getHotCities {
    NSMutableArray *hotArray = [NSMutableArray arrayWithObjects:@"上海",@"北京",@"广州",@"深圳",@"成都",
                                @"重庆",@"天津",@"杭州",@"南京",@"苏州",@"武汉",@"西安",nil];
    NSMutableArray *searchedArray = [[self getSearchedCities] mutableCopy];
    NSMutableArray *returnedArray = [NSMutableArray array];
    
    for (UCity *city in searchedArray) {
        for (NSString *name in hotArray) {
            if ([city.cityName isEqualToString:name]) {
                [returnedArray addObject:city];
            }
        }
    }
    return returnedArray;
}

- (NSMutableArray *)getAllCities {
    NSMutableArray *allArray = [NSMutableArray array];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"citys" ofType:@"json"];
    NSString *string = [NSString stringWithContentsOfFile:sourcePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
    NSDictionary *rootDic = [string objectFromJSONString];
    allArray = [rootDic objectForKey:@"citys"];
    
    NSMutableArray *containerArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableString *str = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < allArray.count; i++) {
        NSArray *citiesInfo = [allArray objectAtIndex:i];
        NSInteger administrativeCityID = [[citiesInfo objectAtIndex:0] integerValue];
        NSString *administrativeCityName = [[citiesInfo objectAtIndex:1] description];
        NSLog(@"id:%d,name:%@\n",administrativeCityID,administrativeCityName);
        
        if (administrativeCityID < 5) {
            str = [NSMutableString stringWithString:@""];
            UCity *city = [[UCity alloc] init];
            city.cityID = administrativeCityID;
            city.cityName = administrativeCityName;
            [str appendFormat:@"%c", pinyinFirstLetter([city.cityName characterAtIndex:0])];
            
            for (char c = 'a';c<='z';c++) {
                if ([str isEqualToString:[NSString stringWithFormat:@"%c",c]]) {
                    if ([str isEqualToString:@"z"]) {
                        city.cityType = @"c";
                    }
                    else {
                        city.cityType = [NSString stringWithFormat:@"%c",c];
                    }
                }
            }
            [containerArray addObject:city];
            [city release];
        }
        else {
            NSArray *cities = [citiesInfo objectAtIndex:2];
            for(int j = 0; j < cities.count; j++) {
                str = [NSMutableString stringWithString:@""];
                UCity *city = [[UCity alloc] init];
                NSArray *cityInfo = [cities objectAtIndex:j];
                city.cityID = [[cityInfo objectAtIndex:0] integerValue];
                city.cityName = [[cityInfo objectAtIndex:1] description];
                NSLog(@"city id:%d,city name:%@\n",city.cityID,city.cityName);
                [str appendFormat:@"%c",pinyinFirstLetter([city.cityName characterAtIndex:0])];
                
                for (char c = 'a';c<='z';c++) {
                    if ([str isEqualToString:[NSString stringWithFormat:@"%c",c]]) {
                        city.cityType = [NSString stringWithFormat:@"%c",c];
                    }
                }
                [containerArray addObject:city];
                [city release];
            }
        }
    } // end for

    NSMutableArray *tempArray = [containerArray mutableCopy];
    [containerArray removeAllObjects];
    for(char c = 'a';c<='z';c++) {
        NSMutableArray *sortedArray = [NSMutableArray array];
        for(UCity *city in tempArray) {
            if ([city.cityType isEqualToString:[NSString stringWithFormat:@"%c",c]]) {
                [sortedArray addObject:city];
            }
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:sortedArray,
                             [NSString stringWithFormat:@"%c",c],
                             [NSString stringWithFormat:@"%c",c],@"cityType",nil];
        if (sortedArray.count) {
            [containerArray addObject:dic];
        }
    }
    return containerArray;
}

- (NSMutableArray *)getSearchedCities { 
    NSMutableArray *searchedArray = [NSMutableArray array];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"citys" ofType:@"json"];
    NSString *string = [NSString stringWithContentsOfFile:sourcePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
    
    NSDictionary *rootDic = [string objectFromJSONString];
    searchedArray = [rootDic objectForKey:@"citys"];
    
    NSMutableArray *containerArray = [NSMutableArray array];
    for (int i = 0; i < searchedArray.count; i++) {
        NSArray *citiesInfo = [searchedArray objectAtIndex:i];
        NSInteger administrativeCityID = [[citiesInfo objectAtIndex:0] integerValue];
        NSString *administrativeCityName = [[citiesInfo objectAtIndex:1] description];
        
        if (administrativeCityID < 5) {
            UCity *city = [[UCity alloc] init];
            city.cityID = administrativeCityID;
            city.cityName = administrativeCityName;
            [containerArray addObject:city];
            [city release];
        }
        else {
            NSArray *cities = [citiesInfo objectAtIndex:2];
            for (int j = 0; j < cities.count; j++) {
                UCity *city = [[UCity alloc] init];
                NSArray *cityInfo = [cities objectAtIndex:j];
                city.cityID = [[cityInfo objectAtIndex:0] integerValue];
                city.cityName = [[cityInfo objectAtIndex:1] description];
                [containerArray addObject:city];
                [city release];
            }
        }
    }
    return containerArray;
}

#pragma mark - delloc
- (void)dealloc {
    [cityName release];
    [pinyinArray release];
    [cityType release];
    [_locationManager release]; _locationManager = nil;
    [super dealloc];
}

@end
