//
//  UMacro.h
//  NaNa
//
//  Created by dengfang on 13-2-25.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#ifndef NaNa_UMacro_h
#define NaNa_UMacro_h

#pragma mark - 控制类宏
// =========================================== 控制类宏 =====================================================

// 用于开关闭ULog的宏
//#define USE_ULOG

// 用于开关闭Release URL的宏（暂时不区分正式环境还是测试环境）
#define K_DOMAIN_NANA       @"http://api.local.ishenran.cn"     //域名
//#define K_DOMAIN_NANA       @"http://api.ishenran.cn"     //域名

#pragma mark - 工具类宏
// =========================================== 工具类宏
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define RGBA(r, g, b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//=====================================================

// 用于定义当前版本的宏
#define CURRENT_VERSION     @"1.0.0"

// 安全Release宏
#define SAFERELEASE(x)  [x release],x=nil;

// 读取本地化字符串
#define STRING(x) NSLocalizedString(x, nil)


//#define stretchableImageresizableImageCapInsets(imageName,top, left, bottom, right)\
//([[[UStaticData defaultStaticData] sysVersion] floatValue] >= 6.0) ? \
//[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch] :\
//([[[UStaticData defaultStaticData] sysVersion] floatValue] >= 5.0)? \
//[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)]:\
//[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:left topCapHeight:top];


//HTTP宏
#define Http_Has_Error_Key @"hasError"
#define Http_ErrorMessage_Key @"errorMessage"
#define Http_Data @"data"


// Log宏
#import "iConsole.h"
#ifdef USE_ULOG
    #define ULog(fmt, ...)              [iConsole info:[@"%@(%d):\n" stringByAppendingString:fmt], [[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent], __LINE__, ##__VA_ARGS__];
#else
    #define ULog(fmt, ...)
#endif

//Userdefault Key
#define accountInfoKey @"AccountInfo"

// 定义界面常用的，像素，颜色等值
#define statusBarHeight             20
#define screenWidth                 [UIScreen mainScreen].bounds.size.width //320
#define sideWidth                   screenWidth - 40
#define navBarHeight                44
#define tabBarHeight                44
#define pickerViewWidth             320.0
#define pickerViewHeight            216.0
#define windowColor                 [UIColor blackColor]

#define default_duration            0.2

// 定义常用字体大小
#define default_font_size_18        18
#define default_font_size_15        15
#define default_font_size_14        15
#define default_font_size_12        12
#define default_font_size_10        10

// 定义常用字体
#define BoldFont(Size)           [UIFont fontWithName:@"Helvetica-Bold" size:Size]
#define NormalFont(Size)         [UIFont fontWithName:@"Helvetica" size:Size]
#define ItalicFont(Size)         [UIFont fontWithName:@"Helvetica-Italic" size:Size]
#define LightFont(Size)          [UIFont fontWithName:@"Helvetica-Light" size:Size]

// 定义常用页面组件的宽高
#define btn_small_width             60
#define btn_small_height            25
#define btn_large_width             280
#define btn_large_height            44

#define image_small_width           45
#define image_middle_width          60
#define image_large_width           90

// 定义常用页面组件的间隔
#define margin_micro                2
#define margin_small                5
#define margin_middle               10
#define margin_large                15

// 定义常用颜色
#import "NSString+UIColor.h"
#define default_color_deep_dark     @"#363636".color
#define default_color_dark          @"#666666".color
#define default_color_light_dark    @"#ababab".color
#define default_color_orange        @"#ff8a00".color
#define default_color_deep_orange   @"#f96819".color
#define default_color_red           @"#cc0000".color
#define default_color_white         @"#ffffff".color
#define default_color_shadow_light  @"#cc7200".color
#define default_color_shadow_dark   @"#990000".color
#define default_color_view_background @"#efefef".color
#define default_color_light_bg      @"#fcfcfc".color
#define default_color_light_gray    @"#e7e7e7".color
#define default_color_empty_gray    @"#cccccc".color
#define default_color_placeholder   @"#f7f7f7".color
//#define default_color_cyan          @"#ffff00".color
#define default_color_cyan           [UIColor colorWithPatternImage:[UIImage imageNamed:@"category_focus_bg.png"]]

#define KFontColorA                 @"#333333".color
#define KFontColorB                 @"#FFFFFF".color
#define KFontColorC                 @"#FF6600".color
#define KFontColorD                 @"#858990".color
#define KBgColorA                   @"#000000".color
#define KBgColorB                   @"#FFFFFF".color
#define KBgColorC                   @"#EFEFF4".color
#define kBgColorD                   @"#DFDFE5".color
#define KLineColorA                 @"#BCBBC1".color
#define KLineColorB                 @"#d4d3d7".color

// 5.0 字体标准
#define NormalFontWithSize(x) [UIFont systemFontOfSize:x]
#define BoldFontWithSize(x) [UIFont boldSystemFontOfSize:x]
#define MY_COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define KFontSizeTitleA              NormalFontWithSize(18)
#define KFontSizeTitleB              NormalFontWithSize(16)
#define KFontSizeTitleC              NormalFontWithSize(14)
#define KFontSizeContentA            NormalFontWithSize(12)

#define KFontSizeTitleA_B            BoldFontWithSize(18)
#define KFontSizeTitleB_B            BoldFontWithSize(16)
#define KFontSizeTitleC_B            BoldFontWithSize(14)
#define KFontSizeContentA_B          BoldFontWithSize(12)
// 定义是否为IPhone5的屏幕
extern BOOL isIPhone5Screen;

#pragma mark - URL相关宏
// =========================================== 关键地址类宏 ==================================================
#define default_request_time_out        15                                      // 默认超时时间

// 定义HttpRequest常用的Domain，URL地址，参数等值
extern NSString *K_URL_ALIPAY_WEBVIEW;

// 定义程序唤醒的ID
extern NSInteger K_WAKE_UP_ID;


// 定义的常用参数，包括（设备类型，系统版本，MAC，等等）
#import "UStaticData.h"
#define URL_TAIL_PARAM              [NSString stringWithFormat:@"?device_id=1&device_no=%@&clientversion=%@", [UStaticData defaultStaticData].macAddress, CURRENT_VERSION]
#define URLREQUEST(pageURL,param)   [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@", K_DOMAIN_NANA, pageURL, param]]]

// WebView链接地址
#define K_WEBVIEW_URL_RANK_CITY         @"/nanatop/city"        // 那娜榜-同城
#define K_WEBVIEW_URL_RANK_NEAR         @"/nanatop/around"      // 那娜榜-周边
#define K_WEBVIEW_URL_RANK_ALL          @"/nanatop/all"         // 那娜榜-全部
#define K_WEBVIEW_URL_MY_PAGE           @"/user/show"           // 我的主页
#define K_WEBVIEW_URL_FOLLOW            @"/visitor"             // 关注的人
#define K_WEBVIEW_URL_INTERACTIVE       @"/interactive"         // 互动
#define K_WEBVIEW_URL_MY_LOVE           @"/love"                // 我喜欢的人
#define K_WEBVIEW_URL_LOVE              @"/love"                // TA-喜欢
#define K_WEBVIEW_URL_FRIEND            @"/follow"              // 好友
#define K_WEBVIEW_URL_MY_BLACK_LIST     @"/user/blacklist"      // 我的黑名单
#define K_WEBVIEW_URL_SUGGEST           @"/user/suggest"        // 意见反馈
//http://api.local.ishenran.cn/interactive?userId=5&targetId=7
#define K_WEBVIEW_URL_INTERACT @"/interactive" //互动

// 我的主页
// 修改资料
#define k_URL_USER_UPDATE_INFO          @"/user/updateInfo"         // 修改资料

// 不需要登陆就能访问的接口
//#define K_URL_USER_LOGIN                        @"/user/login"          //用于登陆接口(1.0.0)
//#define K_URL_AD_LIST                           @"/ad/info"             //用于获取广告列表(1.0.0)
////#define K_URL_VM_INFO                         @"/vm/info"             //用于获取售货机信息(1.0.0)
//#define K_URL_VM_INFO                           @"/vm/getProductListByVmcode"   //用于获取售货机信息以及产品列表(4.0.0)
////#define K_URL_VM_TAG_PRODUCT                  @"/vm/getTabProductList"//用于获取售货机单个分类下的信息(1.0.0)
//#define K_URL_NEAR_BY_LIST                      @"/vm/recentVm"         //最近的售货机(1.0.0)
#define K_URL_CONFIG                            @"/config"              //获取配置文件(1.0.0)
//#define K_URL_DUOMENG                           @"/duomeng/appList"     //多蒙任务列表(1.0.0)


#pragma mark - 字符串类宏
// =========================================== 关键字符串宏 =====================================================

//// Archive Keys
//// 不区分用户的Key
#define USER_ACCOUNT                    @"USER_ACCOUNT"                     // 用于存储用户的账号名
#define USER_PASSWD                     @"USER_PASSWD"                      // 用于存储用户的密码
#define USER_UID                        @"USER_UID"                         // 用于存储用户的UID
#define USER_PHONE                      @"USER_PHONE"                       // 用于存储用户的手机号码
#define DEVICE_TOKEN                    @"DEVICE_TOKEN"                    // 用于记录当前设备的DeviceToken

//// Config的Key
#define CONFIG_MD5                      @"CONFIG_MD5"                       // ConfigFile的MD5值
//#define FORGET_PASSWORD_SERVICE_PHONE   @"FORGET_PASSWORD_SERVICE_PHONE"    // 用于存储忘记密码的短信平台号码
//#define FORGET_PASSWORD_TEXT_CONTENT    @"FORGET_PASSWORD_TEXT_CONTENT"     // 用于存储忘记密码的短信内容
//#define SMS_REGISTER_SERVICE_PHONE      @"SMS_REGISTER_SERVICE_PHONE"       // 用于存储短信注册的短信平台号码
//#define SMS_REGISTER_TEXT_CONTENT       @"SMS_REGISTER_TEXT_CONTENT"        // 用于存储短信注册的短信内容
//#define APP_STORE_URL                   @"APP_STORE_URL"                    // AppStore地址
//#define RECHARGE_HISTORY_URL            @"RECHARGE_HISTORY_URL"             // 充值地址
//#define ALI_FAILED_URL                  @"ALI_FAILED_URL"                   // 支付宝失败地址
//#define ALI_SUCCEED_URL                 @"ALI_SUCCEED_URL"                  // 支付宝成功地址
//#define UNIPAY_FAILED_URL               @"UNIPAY_FAILED_URL"                // 银联失败地址
//#define UNIPAY_SUCCEED_URL              @"UNIPAY_SUCCEED_URL"               // 银联成功地址
//#define TIME_OUT_FROM_SERVER            @"TIME_OUT_FROM_SERVER"             // 超时时间
//#define WALLET_URL                      @"WALLET_URL"                       // 我的钱包地址
//#define UPDATE_MESSAGE                  @"UPDATE_MESSAGE"                   // 建议升级的message
//#define ORDER_TIME_OUT                  @"ORDER_TIME_OUT"                   // 提交订单的超时时间

#pragma mark - 枚举类宏
// =========================================== 关键枚举类宏 =====================================================

typedef enum {
    EServerErrorUnknown =   0,
    EServerErrorEnforceUpdate = 50599,  // 强制升级
    EServerErrorSuggestUpdate = 20499,  // 建议升级
    EServerErrorSignError = 50010,      // 签名错误
} EServerErrorCode;

#endif
