//
//  CellView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/20.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIButton
@property (nonatomic,strong)UITextField * titleTF;
@property (nonatomic,strong)UILabel     * contentLabel;
@property (nonatomic,strong)UIImageView * leftImg;
@property (nonatomic,strong)UIImageView * rightImg;

@property (nonatomic,strong)UIImageView * bottomLine;
@end
