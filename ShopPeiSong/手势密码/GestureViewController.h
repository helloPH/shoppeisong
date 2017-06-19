//
//  GestureViewController.h
//  ManageForMM
//
//  Created by MIAO on 16/9/23.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureViewController : UIViewController

@property (nonatomic,assign)BOOL willUpdateLocation;// 免费版登录时 设置初始密码后 上传位置   因为上传位置需要传店铺ID值 所以在这个类中进行
-(void)mianmilogin;
-(void)forgetBtnClick:(UIButton *)button;
-(void)surePersonState;
@end
