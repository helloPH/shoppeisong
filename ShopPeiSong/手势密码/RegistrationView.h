//
//  RegistrationView.h
//  ManageForMM
//
//  Created by MIAO on 16/9/24.
//  Copyright © 2016年 时元尚品. All rights reserved.
// 注册设备

#import <UIKit/UIKit.h>
#import "Header.h"
@protocol RegistrationViewDelegate <NSObject>

-(void)completeRegistration;
@end
@interface RegistrationView : UIView
@property (nonatomic,strong)void (^openBlock)();
@property(nonatomic,strong)id<RegistrationViewDelegate>registraDeleagte;

@property (nonatomic,strong)UITextField *accountTextfield;//账号
@property (nonatomic,strong)UITextField *passWordTextfield;//密码

-(void)mianMiLogin;

@end
