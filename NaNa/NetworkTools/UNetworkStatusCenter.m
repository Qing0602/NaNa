//
//  UNetworkStatusCenter.m
//  NaNa
//
//  Created by dengfang on 13-2-20.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "UNetworkStatusCenter.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

static UNetworkStatusCenter * defaultNetworkStatusCenter = nil;
static NSString * kNetworkDidChangedNotification = @"kNetworkDidChangedNotification";

@interface UNetworkStatusCenter (Private)
@end

@implementation UNetworkStatusCenter
@synthesize currentOperators = _currentOperators;
#pragma mark - Static Methods

+ (UNetworkStatusCenter*) defaultNetworkStatusCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultNetworkStatusCenter = [[UNetworkStatusCenter alloc] init];
    });
    return defaultNetworkStatusCenter;
}

+ (void) addNetworkStatusCallback:(SEL)selector target:(id)target {
    if (!defaultNetworkStatusCenter) {
        [self defaultNetworkStatusCenter];
    }
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:kNetworkDidChangedNotification object:nil];
}

+ (void) removeNetworkStatusCallback:(id)target {
    if (!defaultNetworkStatusCenter) {
        [self defaultNetworkStatusCenter];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:target name:kNetworkDidChangedNotification object:nil];
}

#pragma mark - Common Methods

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
    [_reachability stopNotifier];
    [_reachability release], _reachability = nil;
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        _reachability = [[Reachability reachabilityForInternetConnection] retain];
        _currentNetworkStatus = _reachability.currentReachabilityStatus;
        [_reachability startNotifier];
        
        CTTelephonyNetworkInfo *info = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
        CTCarrier *carrier = info.subscriberCellularProvider;
        _currentOperators = OperatorsUnKnow;
        if (carrier) {
            NSString *code = carrier.mobileNetworkCode;
            if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
                _currentOperators = OperatorsChinaMobile;
            }
            else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
                _currentOperators = OperatorsChinaUnicom;
            }
            else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]) {
                _currentOperators = OperatorsChinaTelecom;
            }
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkDidChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
    return self;
}

- (void)networkDidChanged:(NSNotification*)notification {
    if (_currentNetworkStatus != _reachability.currentReachabilityStatus) {
        _currentNetworkStatus = _reachability.currentReachabilityStatus;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkDidChangedNotification object:self];
    }
}

@end
