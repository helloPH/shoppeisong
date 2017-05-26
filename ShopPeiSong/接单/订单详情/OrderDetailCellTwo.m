//
//  OrderDetailCellTwo.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/8.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "OrderDetailCellTwo.h"
#import "OrderDetailShangpinModel.h"
#import "Header.h"
@interface OrderDetailCellTwo ()

@property(nonatomic,strong)UILabel *nameLabel,*priceLabel,*numLabel,*fujiafeiLabel,*mongeyLabel,*yanseLabel,*xinghaoLabel;
@property(nonatomic,strong)UIImageView *shopImageView;
@property(nonatomic,strong)UIView *lineView;
@end
@implementation OrderDetailCellTwo

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(UIImageView *)shopImageView
{
    if (!_shopImageView) {
        _shopImageView = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@"shanghuicon"];
        [self.contentView addSubview:_shopImageView];
    }
    return _shopImageView;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

-(UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_numLabel];
    }
    return _numLabel;
}
-(UILabel *)fujiafeiLabel
{
    if (!_fujiafeiLabel) {
        _fujiafeiLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:txtColors(62, 194,148, 1) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:0 text:@""];
        [self.contentView addSubview:_fujiafeiLabel];
    }
    return _fujiafeiLabel;
}
-(UILabel *)mongeyLabel
{
    if (!_mongeyLabel) {
        _mongeyLabel = [BaseCostomer labelWithFrame:CGRectZero  font:[UIFont systemFontOfSize:MLwordFont_5] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight numOfLines:1 text:@""];
        [self.contentView addSubview:_mongeyLabel];
    }
    return _mongeyLabel;
}

-(UILabel *)yanseLabel
{
    if (!_yanseLabel) {
        _yanseLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_yanseLabel];
    }
    return _yanseLabel;
}
-(UILabel *)xinghaoLabel
{
    if (!_xinghaoLabel) {
        _xinghaoLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:2 numOfLines:1 text:@""];
        [self.contentView addSubview:_xinghaoLabel];
    }
    return _xinghaoLabel;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}
-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath WithArray:(NSArray *)array
{
    /**
    shopid                  //商品id
     */
    OrderDetailShangpinModel *model = array[indexpath.row];
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shopimg]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    self.nameLabel.text = model.shopname;
    self.numLabel.text = [NSString stringWithFormat:@"数量:%@",model.shuliang];

    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.jiage floatValue]];
    self.mongeyLabel.text = [NSString stringWithFormat:@"%.2f",[model.total_money floatValue]];
    self.fujiafeiLabel.text = [NSString stringWithFormat:@"%@",model.fujiafei_money];
    if ([model.yanse integerValue] !=0) {
        self.yanseLabel.text = [NSString stringWithFormat:@"%@",model.yanse];
    }
    
    if ([model.xinghao integerValue]!=0) {
    self.xinghaoLabel.text = [NSString stringWithFormat:@"%@",model.xinghao];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.shopImageView.frame = CGRectMake(10*MCscale, self.height/2.0-25*MCscale,50*MCscale,50*MCscale);
    self.nameLabel.frame = CGRectMake(self.shopImageView.right +10*MCscale, self.shopImageView.top, self.width - 190*MCscale, 20*MCscale);
    self.fujiafeiLabel.frame = CGRectMake(self.width - 110*MCscale, self.nameLabel.top, 30*MCscale, 20*MCscale);
    self.mongeyLabel.frame = CGRectMake(self.width -115*MCscale, self.nameLabel.top, 100*MCscale, 20*MCscale);
    self.priceLabel.frame = CGRectMake(self.shopImageView.right +10*MCscale, self.nameLabel.bottom +10*MCscale, 80*MCscale, 20*MCscale);
    self.numLabel.frame = CGRectMake(self.priceLabel.right +10*MCscale, self.priceLabel.top,100*MCscale, 20*MCscale);
    self.yanseLabel.frame = CGRectMake(self.width - 110*MCscale, self.numLabel.top, 30*MCscale, 20*MCscale);
    self.xinghaoLabel.frame = CGRectMake(self.width -65*MCscale, self.numLabel.top, 50*MCscale, 20*MCscale);
    self.lineView.frame = CGRectMake(5*MCscale, self.height - 1, self.width-10*MCscale, 1);
}
@end
