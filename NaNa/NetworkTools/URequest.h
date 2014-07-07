//
//  URequest.h
//  NaNa
//
//  Created by dengfang on 13-2-21.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "ASIFormDataRequest.h"

// 用于发送Http请求的类，为了便于扩展以及适应请求逻辑，采用继承
@interface URequest : ASIFormDataRequest {
    
}

// 用于是否显示Loading的样式
@property (nonatomic, assign) BOOL  needLoading;

// 用于给Request添加注释，或者标志位
@property (nonatomic, copy) NSString *comments;

// 解析完的相关JSON数据(如果出错，可能会为nil)
@property (nonatomic, retain) NSDictionary *parsedDict;

// 服务器给返回的Code
@property (nonatomic, assign) NSInteger     serverCode;

// 服务器给返回的ErrorMsg
@property (nonatomic, readonly) NSString    *serverErrMsg;

// 是否该请求已经出错
@property (nonatomic, readonly) BOOL        isError;

// 是否允许弹出Alert错误提示
@property (nonatomic, assign)   BOOL        allowedAlert;

// 是否允许弹出网络失败的Toast
@property (nonatomic, assign)   BOOL        allowedToast;

// 初始化方法
- (id)initWithDomain:(NSString *)domain withPath:(NSString*)path withParam:(NSString*)param;

@end

// =========================================== 分割线 =====================================================

// 用于给Param签名的NSString+Category
@interface NSString (URequest)

// 参数合法化
- (NSString*)validStringForRequest;

// 用于给Param签名的函数(返回签名后的NSString)
-(NSString*)signString;

// 用于给Param签名的函数(返回签名后的NSDictionary)
-(NSDictionary*)signDict;

@end
