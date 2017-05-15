//
//  PlatformCell.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/6.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeQiangDiandanModel.h"
@protocol PlatformCellDelegate <NSObject>

-(void)qiangdanButtonClickWithDanhao:(NSString *)danhao;
-(void)jinRuXiangQing:(NSString *)danhao;
@end
@interface PlatformCell : UITableViewCell

@property(nonatomic,strong)id<PlatformCellDelegate>platformDelagete;


-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
@end
