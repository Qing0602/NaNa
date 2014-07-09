//
//  PalmUIManagement.m
//  teacher
//
//  Created by singlew on 14-3-7.
//  Copyright (c) 2014年 ws. All rights reserved.
//

#import "NaNaUIManagement.h"

@implementation NaNaUIManagement
static NaNaUIManagement *sharedInstance = nil;

+(NaNaUIManagement *) sharedInstance{
    @synchronized(sharedInstance){
        if (nil == sharedInstance){
            sharedInstance = [[NaNaUIManagement alloc] init];
        }
    }
    return sharedInstance;
}

@end
