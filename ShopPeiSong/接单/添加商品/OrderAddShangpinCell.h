//
//  OrderAddShangpinCell.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/13.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderAddShangpinCell : UITableViewCell
@property (nonatomic,strong)void (^addBtnBlock)(NSIndexPath *indexPath);

-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array;
@end
