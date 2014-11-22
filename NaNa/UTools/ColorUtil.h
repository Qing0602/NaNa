//
//  ColorUtil.h
//  SweetAlarm
//
//  Created by 振杰 李 on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
/*
 #pragma mark -
 #pragma mark FXShakeFieldDelegate method
 - (void)shake_field_did_begin_editing:(UITextField *)text_field{
 [self do_rise];
 }
 - (void)shake_field_did_end_editing:(UITextField *)text_field{
 [self do_drop];
 }
 - (void)shake_field_should_return:(UITextField *)text_field{
 [self do_drop];
 }
 #pragma mark UIResponser
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 [shakefield.shake_text_field resignFirstResponder];
 [self do_drop];
 }
 #pragma mark Action
 - (void)do_rise{
 [UIView beginAnimations:@"rise" context:nil];
 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
 [UIView setAnimationDuration:1.0];
 partoneview.frame=FXRect(PART_ONE_X,-PART_ONE_HIGH+50, PART_ONE_WIDTH, PART_ONE_HIGH);
 parttwoview.frame=FXRect(PART_ONE_X, PART_ONE_Y+50, PART_ONE_WIDTH, PART_ONE_HIGH);
 [UIView commitAnimations];
 }
 - (void)do_drop{
 [UIView beginAnimations:@"rise" context:nil];
 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
 [UIView setAnimationDuration:1.0];
 partoneview.frame=FXRect(PART_ONE_X, PART_ONE_Y,PART_ONE_WIDTH, PART_ONE_HIGH);
 parttwoview.frame=FXRect(PART_TWO_X, PART_TWO_Y, PART_TWO_WIDTH, PART_TWO_HIGH);
 [UIView commitAnimations];
 }
 */
@interface UIColor (util) 
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (CGFloat *) getColorRGBAValueForUIColor: (UIColor *)selfcolor;
@end
