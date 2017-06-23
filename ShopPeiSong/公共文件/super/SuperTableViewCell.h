//
//  SuperTableViewCell.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/19.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView * leftImg;
@property (nonatomic,strong)UILabel     * titleLabel;
@property (nonatomic,strong)UILabel     * contentLabel;
@property (nonatomic,strong)UIImageView * rightImg;

@property (nonatomic,strong)UIImageView * bottomLine;
@end
