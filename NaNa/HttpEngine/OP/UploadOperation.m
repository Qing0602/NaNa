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
@property (nonatomic) UpAndDownLoadType type;
@property (nonatomic,strong) NSString *filePath;
-(void) downloadVoice;
@end

@implementation UploadOperation
-(UploadOperation *) initUpload : (NSData *) data withUploadType : (UploadType) uploadType withUserID : (int) userID  withDesc : (NSString *) desc withVoiceTime : (NSUInteger) time{
    self = [super initOperation];
    self.type = kUpload;
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
        NSString *urlStr = [NSString stringWithFormat:@"%@/upload",K_DOMAIN_NANA];
        NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:userID],@"userId",
                               type,@"bucket",
                               desc,@"description",
                               [NSNumber numberWithInt:time],@"long",
                               nil];
        [self setHttpRequestPostWithUrl:urlStr
                                 params:params
                            imgDataDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                         data,@"file",
                                         nil]];
    }
    return self;
}

-(UploadOperation *) initDownLoadUserVoiceFile : (NSString *) videoUrl withFilePath : (NSString *) filePath{
    if ([self initOperation]) {
        self.type = kDownload;
//        NSString *writeFileName = [NSString stringWithFormat:@"1%@",@".mp3"];
//        NSString *fileDir = [NSString stringWithFormat:@"/Voice/"];
//        [UploadOperation createPath:fileDir];
//        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentPath = [paths objectAtIndex:0];
//        self.filePath = [NSString stringWithFormat:@"%@/%@%@",documentPath,fileDir,writeFileName];
        self.filePath = filePath;
        [self setHttpRequestGetWithUrl:videoUrl];
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

-(void) downloadVoice{
    [self.request setDownloadDestinationPath:self.filePath];
    [self.request setRequestCompleted:^(NSDictionary *data){
        dispatch_block_t updateTagBlock = ^{
            [NaNaUIManagement sharedInstance].downloadVoiceResult = data;
        };
        dispatch_async(dispatch_get_main_queue(), updateTagBlock);
    }];
    [self startAsynchronous];
}

-(void) main{
    @autoreleasepool {
        switch (self.type) {
            case kUpload:
                [self startUpload];
                break;
            case kDownload:
                [self downloadVoice];
                break;
            default:
                break;
        }
        
    }
}
@end
