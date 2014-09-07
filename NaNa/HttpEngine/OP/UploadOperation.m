//
//  UploadOperation.m
//  NaNa
//
//  Created by singlew on 14-7-9.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "UploadOperation.h"

@interface UploadOperation ()
-(void) startUpload;
@end

@implementation UploadOperation
-(UploadOperation *) initUpload : (NSData *) data withUploadType : (UploadType) uploadType withUserID : (int) userID  withDesc : (NSString *) desc{
    self = [super initOperation];
    
    if (nil != self) {
        NSString *type = @"";
        switch (uploadType) {
            case UploadAvatar:
                type = @"avatar";
                break;
            case UploadPhoto:
                type = @"photo";
                break;
            case UploadVoice:
                type = @"voice";
                break;
            default:
                break;
        }
        
        if (desc == nil) {
            desc = @"";
        }
        NSString *urlStr = [NSString stringWithFormat:@"http://api.local.ishenran.cn/upload"];
        [self setHttpRequestPostWithUrl:urlStr
                                 params:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithInt:userID],@"userId",
                                         type,@"bucket",
                                         desc,@"description",
                                         nil]
                            imgDataDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                         data,@"file",
                                         nil]];
    }
    return self;
}

-(void) startUpload{
    [self.dataRequest setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].uploadResult = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) main{
    @autoreleasepool {
        [self startUpload];
    }
}
@end
