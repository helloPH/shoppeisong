//
//  PersonalCell.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/7.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCell : UITableViewCell
@property (nonatomic,strong)NSDictionary * dic;
-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath;

@end
