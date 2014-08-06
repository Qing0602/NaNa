//
//  InfoEditVC.h
//  NaNa
//
//  Created by dengfang on 13-8-10.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import "UBasicViewController.h"
#import "TTTAttributedLabel.h"
#import "PhotoMenuView.h"
#import "UBottomView.h"
#import "HeadCartoonVC.h"
//#import "URoundButton.h"
#import "UCity.h"
#import <AVFoundation/AVFoundation.h>

enum
{
    ENC_AAC = 1,
    ENC_ALAC = 2,
    ENC_IMA4 = 3,
    ENC_ILBC = 4,
    ENC_ULAW = 5,
    ENC_PCM = 6,
}encodingTypes;

typedef enum
{
    TYPE_NORMAL = 1,
    TYPE_LOGIN = 2,
}enterType;
@interface InfoEditVC : UBasicViewController <UITableViewDataSource,
  UITableViewDelegate,
  UITextFieldDelegate,
  UIPickerViewDataSource,
  UIPickerViewDelegate,
  HeadCartoonDelegate,
  PhotoMenuDelegate,
  UIImagePickerControllerDelegate,
  UINavigationControllerDelegate,
  AVAudioRecorderDelegate,
  AVAudioPlayerDelegate> {
    
    UIButton            *_headButton;           // 头像
    UILabel             *_timeLabel;            // 录音时间
//    UIImageView         *_recordImageView;      // 录音小喇叭
    UIButton            *_recordImageView;      // 录音小喇叭
    UIButton            *_recordButton;         // 录音
    UILabel             *_recordButtonLabel;    // 录音按钮上的文案
    UIImageView         *_recordButtonImageView;// 录音按钮上的图片
    UILabel             *_remarkLabel;          // 备注
    UITableView         *_tableView;            // 修改信息
    NSMutableArray      *_infoArray;            // 改的信息内容
    BOOL                _showRecord;            // 是否显示录音喇叭
    
    // 修改内容 for cell
    UITextField         *_nameTextField;        // 修改名称
    UILabel             *_ageLabel;             // 年龄
    UILabel             *_roleLabel;            // 角色
    UILabel             *_cityLabel;            // 城市
    NSMutableString     *_birthday;             // 生日
    UCity               *_city;                 // 城市信息
    
    // 用户协议
    UIButton            *_agreeCheckButton;     // 是否同意用户协议按钮
    TTTAttributedLabel  *_agreeLabel;           // 同意用户协议文案
    UIButton            *_agreeButton;          // 用户协议入口按钮
    BOOL                _isAgree;               // 同意用户协议
    BOOL                _showAgree;             // 是否显示用户协议提示
    
    // 更改角色、更改年龄的picker
    UBottomView         *_roleBottomView;       // 角色的底部View
    UIPickerView        *_rolePickerView;       // 修改角色的picker
    UBottomView         *_ageBottomView;        // 年龄的底部View
    UIDatePicker        *_ageDatePicker;        // 修改年龄的picker
    NSArray             *_roleArray;            // 角色picker里的数据
    
    // 修改头像的菜单视图
    PhotoMenuView       *_photoMenuView;        // 修改头像的菜单视图
    CGRect              _photoMenuHideRect;     // 头像Menu不显示时的位置
    CGRect              _photoMenuShowRect;     // 头像Menu显示时的位置
      
    AVAudioRecorder     *_recorder;
    AVAudioPlayer       *_audioPlayer;
    UIView              *_recordingView;
    BOOL                 _isExistRecord;
      
      NSInteger enterPathType;
      
}

@property (nonatomic, retain) UIButton *headButton;
@property (nonatomic, retain) NSDictionary *infoData;

@end
