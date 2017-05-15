//
//  ShuohuoMoneyView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/22.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShuohuoMoneyViewDelegate <NSObject>

-(void)shouhuoSuccess;

@end
@interface ShuohuoMoneyView : UIView

@property(nonatomic,strong)NSString *danhao,*caigouchengben;
@property(nonatomic,strong)id<ShuohuoMoneyViewDelegate>shouhuoDelegate;
@end
