//
//  UploadOperation.h
//  NaNa
//
//  Created by singlew on 14-7-9.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaOperation.h"
#import "NaNaUIManagement.h"


@interface UploadOperation : NaNaOperation
-(UploadOperation *) initUpload : (NSData *) data withUploadType : (UploadType) uploadType withUserID : (NSString *) userID withDesc : (NSString *) desc;
@end
