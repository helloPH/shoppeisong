//
//  ShopEvaluateCell.h
//  GoodShop
//
//  Created by MIAO on 2016/12/2.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopEvaluateCell : UITableViewCell

@property(nonatomic,strong)UIImageView *selectImage;
-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
@end
