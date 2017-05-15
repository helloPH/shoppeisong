//
//  BalanceCell.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/24.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BalanceCellDelegate <NSObject>

-(void)getZhangdanShuomingDataWithZhangdanID:(NSString *)zhangdanId;

@end
@interface BalanceCell : UITableViewCell
@property(nonatomic,strong)id<BalanceCellDelegate>balanceDelegate;

-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;

@end
