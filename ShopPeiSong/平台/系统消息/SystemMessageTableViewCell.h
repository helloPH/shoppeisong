//
//  SystemMessageTableViewCell.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/7/18.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemMessageModel.h"
typedef NS_ENUM(NSInteger,BtnType) {
    btnTypeImg = 0,
    btnTypeDetail = 1,
    btnTypeDelete = 2,
};
@interface SystemMessageTableViewCell : UITableViewCell
@property (nonatomic,strong)void(^block)(BtnType btnType,SystemMessageModel * model);

@property (nonatomic,strong)SystemMessageModel * model;
@end
