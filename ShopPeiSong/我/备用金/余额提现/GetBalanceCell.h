//
//  GetBalanceCell.h
//  LifeForMM
//
//  Created by MIAO on 16/5/31.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BindAccountModel.h"
@protocol GetBalanceCellDelegate <NSObject>
-(void)changeAccountForBalance;
-(void)changeSeletedForButton:(UIButton *)btn;
@end

@interface GetBalanceCell : UITableViewCell

@property (nonatomic,strong)UILabel *bindingTypeLabel;//绑定类型
@property (nonatomic,strong)UILabel *accountNumberLabel;//绑定号码

@property (nonatomic,strong)UIButton *selectedBtn;//绑定号码
@property (nonatomic,strong)UIButton * changeBtn;//绑定号码

@property (nonatomic,strong)id<GetBalanceCellDelegate>balanceDelegate;

-(void)loadDataForCellWithModel:(BindAccountModel *)model;
@end
