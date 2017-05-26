//
//  TopUpView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/22.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,PayType){
    payTypeTopUp,// 充值
    payTypeZhiXuFei,// 
};


@interface TopUpView : UIView
@property (nonatomic,strong)void(^payBlock)(BOOL);
-(void)setMoney:(float )money limitMoney:(float)limitMoney title:(NSString *)title body:(NSString *)body canChange:(BOOL) canChange;
-(void)appear;
-(void)disAppear;
@end
