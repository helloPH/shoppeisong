//
//  OrderAddShangpinCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/13.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "OrderAddShangpinCell.h"
#import "ShangpinMessagesModel.h"
#import "Header.h"
@interface OrderAddShangpinCell ()

@property(nonatomic,strong)UILabel *nameLabel,*priceLabel,*fujiaLabel;
@property(nonatomic,strong)UIButton *shopCarBtn;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)NSIndexPath * indexPath;
@end
@implementation OrderAddShangpinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont boldSystemFontOfSize:MLwordFont_5] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}
-(UILabel *)fujiaLabel
{
    if (!_fujiaLabel) {
        _fujiaLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_fujiaLabel];
    }
    return  _fujiaLabel;
}
-(UIButton *)shopCarBtn
{
    if (!_shopCarBtn) {
        _shopCarBtn = [BaseCostomer buttonWithFrame:CGRectZero backGroundColor:[UIColor clearColor] text:@"" image:@"加入购物车"];
        [_shopCarBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_shopCarBtn];
        
        
    }
    return  _shopCarBtn;
}
-(void)addBtnClick:(UIButton *)sender{
    if (_addBtnBlock) {
        _addBtnBlock(self.indexPath);

        
        
        
    }
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(10*MCscale,5*MCscale, self.width-200*MCscale,30*MCscale);
    self.priceLabel.frame = CGRectMake(self.nameLabel.right+5*MCscale,5*MCscale,50*MCscale,30*MCscale);
    self.fujiaLabel.frame = CGRectMake(self.priceLabel.right+5*MCscale,5*MCscale,50*MCscale,30*MCscale);
    self.shopCarBtn.frame = CGRectMake(self.width-50*MCscale,5*MCscale,40*MCscale,25*MCscale);
    self.lineView.frame = CGRectMake(5*MCscale, self.height-1, self.width - 10*MCscale, 1);
}
-(void)fujiaLabelClick
{
    
}
-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    ShangpinMessagesModel * model = array[indexpath.row];
    self.indexPath=indexpath;
    self.nameLabel.text = model.mingcheng;
    self.priceLabel.text = model.xianjia;
    NSArray *states =@[@"下架",@"上架"];
    self.fujiaLabel.text = states[[model.status integerValue]];
}
@end

