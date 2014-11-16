//
//  UploadOperation.h
//  NaNa
//
//  Created by singlew on 14-7-9.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "NaNaOperation.h"
#import "NaNaUIManagement.h"

typedef enum{
    kUpload,
    kDownload,
}UpAndDownLoadType;

@interface UploadOperation : NaNaOperation
-(UploadOperation *) initUpload : (NSData *) data withUploadType : (UploadType) uploadType withUserID : (int) userID withDesc : (NSString *) desc
                  withVoiceTime : (NSUInteger) time;
-(UploadOperation *) initDownLoadUserVoiceFile : (NSString *) videoUrl withFilePath : (NSString *) filePath;
@end
