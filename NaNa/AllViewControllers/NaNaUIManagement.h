//
//  PalmUIManagement.h
//  teacher
//
//  Created by singlew on 14-3-7.
//  Copyright (c) 2014年 ws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NaNaNetWorkService.h"
#import "NaNaUserAccountModel.h"
//#import "UploadOperation.h"

#define TRANSFERVALUE @"TransferValue"
#define TRANSFERVCFROMCLASS @"TransferFromVCClass"
#define TRANSFERVCTOCLASS @"TransferToVCClass"

typedef enum{
    UploadAvatar,
    UploadPhoto,
    UploadVoice,
}UploadType;

@interface NaNaUIManagement : NSObject

+(NaNaUIManagement *) sharedInstance;

// 用户登陆model
@property(nonatomic,strong) NaNaUserAccountModel *userAccount;

@property(nonatomic,strong) NSDictionary *uploadResult;

@property(nonatomic,strong) NSHTTPCookie *php;
@property(nonatomic,strong) NSHTTPCookie *suid;
@property(nonatomic,strong) NSString *imServerIP;


-(void) uploadFile : (NSData *) data withUploadType : (UploadType) uploadType withUserID : (NSString *) userID withDesc : (NSString *) desc;

@end
