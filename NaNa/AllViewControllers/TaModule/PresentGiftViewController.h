//
//  PresentGiftViewController.h
//  NaNa
//
//  Created by ZhangQing on 14-8-18.
//  Copyright (c) 2014年 dengfang. All rights reserved.
//

#import "UBasicViewController.h"
#import "MMGridView.h"
@interface PresentGiftViewController : UBasicViewController<MMGridViewDataSource,MMGridViewDelegate>
-(id)initWithUserID:(NSInteger)userID;
@end
