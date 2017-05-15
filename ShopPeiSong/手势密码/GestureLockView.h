//
//  GestureLockView.h
//  ManageForMM
//
//  Created by MIAO on 16/9/24.
//  Copyright © 2016年 时元尚品. All rights reserved.
//  手势密码

#import <UIKit/UIKit.h>
#import "Header.h"

@class GestureLockView;

@protocol GestureLockDelegate <NSObject>

@optional

- (void)GestureLockSetResult:(NSString *)result gestureView:(GestureLockView *)gestureView;
- (void)GestureLockPasswordRight:(GestureLockView *)gestureView;
- (void)GestureLockPasswordWrong:(GestureLockView *)gestureView;

@end

@interface GestureLockView : UIView<MBProgressHUDDelegate>

@property (assign, nonatomic) id<GestureLockDelegate> GestureDelegate;

-(void)reloDataWithIndex:(NSInteger)index;

- (void)setRigthResult:(NSString *)rightResult;

@end
