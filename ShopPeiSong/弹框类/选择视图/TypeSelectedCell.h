//
//  TypeSelectedCell.h
//  ManageForMM
//
//  Created by MIAO on 16/11/1.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeSelectedCell : UITableViewCell
@property (nonatomic,strong)NSIndexPath * indexPath;
@property(nonatomic,strong)UILabel *typeLabel;
//行业列表
-(void)reloadDataForHangyeWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
/**
 *  店铺列表
 */
-(void)reloadDataForShopWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
/**
 *  商品类别
 */
-(void)reloadDataForLeibieWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
/**
 *  商品标签
 */
-(void)reloadDataForBiaoqianWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
/**
 *  商品状态
 */
-(void)reloadDataForStatesWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
@end
