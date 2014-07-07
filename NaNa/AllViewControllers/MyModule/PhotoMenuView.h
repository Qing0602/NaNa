//
//  PhotoMenuView.h
//  NaNa
//
//  Created by dengfang on 13-8-17.
//  Copyright (c) 2013年 dengfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoMenuDelegate <NSObject>
- (void)albumButtonPressed:(UIButton *)btn;
- (void)photoButtonPressed:(UIButton *)btn;
- (void)cartoonButtonPressed:(UIButton *)btn;
- (void)cancelButtonPressed:(UIButton *)btn;
@end


@interface PhotoMenuView : UIView {
    id<PhotoMenuDelegate>     _photoMenuDelegate;
}

@property (nonatomic, assign) id<PhotoMenuDelegate> photoMenuDelegate;
@property (nonatomic, retain) IBOutlet UIButton *photoBtn;
@property (nonatomic, retain) IBOutlet UIButton *cameraBtn;
@property (nonatomic, retain) IBOutlet UIButton *cartoonBtn;

- (IBAction)albumButtonPressed:(UIButton *)btn;
- (IBAction)photoButtonPressed:(UIButton *)btn;
- (IBAction)cartoonButtonPressed:(UIButton *)btn;
- (IBAction)cancelButtonPressed:(UIButton *)btn;

@end
