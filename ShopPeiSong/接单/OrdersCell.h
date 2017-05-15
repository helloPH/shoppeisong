//
//  OrdersCell.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/7.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrdersCellDelegate <NSObject>

-(void)shouhuoSuccessWithDanhao:(NSString *)danhao AndCaigouchengbenStr:(NSString *)caigouchengben AndZhidufangshiIndex:(NSInteger)zhifufangshi Index:(NSInteger)index;

@end
@interface OrdersCell : UITableViewCell
@property(nonatomic,strong)id<OrdersCellDelegate>orderDelegate;
@property(nonatomic,strong)UIButton *shouhuoBtn;
-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
@end
