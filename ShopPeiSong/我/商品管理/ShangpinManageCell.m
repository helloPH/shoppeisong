//
//  ShangpinManageCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/21.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "ShangpinManageCell.h"
#import "ShangpinMessagesModel.h"
#import "Header.h"
@interface ShangpinManageCell ()

@property(nonatomic,strong)UILabel *nameLabel,*priceLabel,*statesLabel;
@property(nonatomic,strong)UIView *lineView;

@end
@implementation ShangpinManageCell

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
-(UILabel *)statesLabel
{
    if (!_statesLabel) {
        _statesLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_statesLabel];
    }
    return  _statesLabel;
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
    self.nameLabel.frame = CGRectMake(10*MCscale,5*MCscale, self.width-130*MCscale,30*MCscale);
    self.priceLabel.frame = CGRectMake(self.nameLabel.right+5*MCscale,5*MCscale,50*MCscale,30*MCscale);
    self.statesLabel.frame = CGRectMake(self.priceLabel.right+5*MCscale,5*MCscale,50*MCscale,30*MCscale);
    self.lineView.frame = CGRectMake(5*MCscale, self.height-1, self.width - 10*MCscale, 1);
}

-(void)statesLabelClick
{

}
-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    ShangpinMessagesModel *model = array[indexpath.row];
    self.nameLabel.text = model.mingcheng;
    self.priceLabel.text = model.xianjia;
    NSArray *states =@[@"下架",@"上架"];
    self.statesLabel.text = states[[model.status integerValue]];
}
@end
