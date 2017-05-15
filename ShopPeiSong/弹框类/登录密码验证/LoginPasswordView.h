//
//  LoginPasswordView.h
//  ManageForMM
//
//  Created by MIAO on 16/9/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestureLockView.h"

@protocol LoginPasswordViewDelegate <NSObject>

-(void)changeNewPassWordWithString:(NSString *)newPass AndIndex:(NSInteger)index;
@end
@interface LoginPasswordView : UIView<GestureLockDelegate>
@property(nonatomic,strong) UILabel *promptLabel;//提示label
@property (nonatomic,strong)id<LoginPasswordViewDelegate>loginPassDelegate;

-(void)reloadDataWithViewTag:(NSInteger)viewtag;

@property (nonatomic,strong)void(^block)(BOOL isSuccess);
-(void)appear;
-(void)disAppear;
@end
