//
//  TypeSelectedCell.m
//  ManageForMM
//
//  Created by MIAO on 16/11/1.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "TypeSelectedCell.h"
#import "Header.h"

@interface TypeSelectedCell ()
@property(nonatomic,strong)UIView *lineView;
@end
@implementation TypeSelectedCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_typeLabel];
    }
    return _typeLabel;
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
    self.typeLabel.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
    self.lineView.frame = CGRectMake(10*MCscale, self.contentView.height - 1, self.contentView.width - 20*MCscale, 1);
}
//行业列表
-(void)reloadDataForHangyeWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    self.typeLabel.text = array[indexpath.row][@"name"];
}
//店铺列表
-(void)reloadDataForShopWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    self.typeLabel.text = array[indexpath.row][@"dianpuname"];
}
//店铺类别
-(void)reloadDataForLeibieWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    self.typeLabel.text = array[indexpath.row][@"leibie"];
}
//店铺标签
-(void)reloadDataForBiaoqianWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    self.typeLabel.text = array[indexpath.row][@"biaoqianname"];
}
//商品状态
-(void)reloadDataForStatesWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    self.typeLabel.text = array[indexpath.row];
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    self.typeLabel.textColor = textColors;
    self.typeLabel.text = nil;
}

@end
