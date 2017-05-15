//
//  ReviewSelectedView.h
//  ManageForMM
//
//  Created by MIAO on 16/11/1.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@protocol ReviewSelectedViewDelegate <NSObject>
/**
 *  选择店铺
 */
-(void)selectedIndustryWithString:(NSString *)string AndId:(NSString *)ID;

/**
 *  选择商品类型
 */
-(void)selectedLeixingWithString:(NSString *)string;

/**
 *  选择新增商品类型
 */
-(void)selectedAddShangpinLeixinWithString:(NSString *)string AndId:(NSString *)ID;
/**
 *  选择新增商品标签
 */
-(void)selectedAddShangpinBiaoqianWithString:(NSString *)string AndId:(NSString *)ID;
/**
 *  选择商品状态
 */
-(void)selectedStatesWithString:(NSString *)string;
/**
 *  选择未审核店铺
 */
-(void)selectedNoShenheStoreWithString:(NSString *)string AndId:(NSString *)ID;
/**
 *  选择行业
 */
-(void)selectedHangyeWithString:(NSString *)string AndId:(NSString *)ID;


@end
@interface ReviewSelectedView : UIView<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>

@property (nonatomic,strong)id<ReviewSelectedViewDelegate>selectedDelegate;
@property(nonatomic,strong)NSString *dianpuId;
-(void)reloadDataWithViewTag:(NSInteger)index ;


@property (nonatomic,strong)void (^block)(id selecedData);
-(void)appear;
-(void)dissAppear;
@end
