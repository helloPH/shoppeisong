//
//  SecurityCell.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/8.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecurityCellDelegate <NSObject>
-(void)selectedTixingTime;
@end
@interface SecurityCell : UITableViewCell

@property(nonatomic,strong)id<SecurityCellDelegate>securityDelegate;


@property (nonatomic,strong)void (^block)();

@property (nonatomic,strong)UISwitch *switchView;
-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath;

@end
