//
//  NaNaUserAccountModel.h
//  NaNa
//
//  Created by singlew on 14-7-31.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaNaUIModelCoding.h"

@interface NaNaUserAccountModel : NaNaUIModelCoding
@property (nonatomic,copy) NSString *UserID;
@property (nonatomic,copy) NSString *NaNaID;
@property (nonatomic,copy) NSString *seckey;

-(BOOL) convertForDic : (NSDictionary *) dic;
@end
