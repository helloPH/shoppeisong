//
//  OrderDetailChangeMoneyAndShuLiangView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/26.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailShangpinModel.h"
@interface OrderDetailChangeMoneyAndShuLiangView : UIView
@property (nonatomic,strong)void (^block)(float money);
@property (nonatomic,strong)OrderDetailShangpinModel * model;


-(void)appear;
-(void)disAppear;
@end
