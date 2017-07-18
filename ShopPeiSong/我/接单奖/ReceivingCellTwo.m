//
//  ReceivingCellTwo.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/9.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "ReceivingCellTwo.h"
#import "ReceivedModelTwo.h"
#import "Header.h"

@interface ReceivingCellTwo ()

@property(nonatomic,strong)UILabel *dateLabel,*moneyLabel,*quxiaoLabel,*weipingjiaLabel,*yipingjiaLabel;
@property(nonatomic,strong)UIView *lineView;
@end
@implementation ReceivingCellTwo

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}

-(UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

-(UILabel *)quxiaoLabel
{
    if (!_quxiaoLabel) {
        _quxiaoLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
        [self.contentView addSubview:_quxiaoLabel];
    }
    return _quxiaoLabel;
}

-(UILabel *)weipingjiaLabel
{
    if (!_weipingjiaLabel) {
        _weipingjiaLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_weipingjiaLabel];
    }
    return _weipingjiaLabel;
}
-(UILabel *)yipingjiaLabel
{
    if (!_yipingjiaLabel) {
        _yipingjiaLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_yipingjiaLabel];
    }
    return _yipingjiaLabel;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    ReceivedModelTwo *model = array[indexpath.row];
    self.dateLabel.text = model.date;
    
    
    NSString * dingdanshu = [NSString stringWithFormat:@"%ld",[model.quxiao integerValue]+[model.weipingjia integerValue]+[model.yipingjia integerValue]];
    self.moneyLabel.text = [NSString stringWithFormat:@"订单:  %@",dingdanshu];
    

    NSString * quxiao = [NSString stringWithFormat:@"%@",model.quxiao];
    self.quxiaoLabel.text = [NSString stringWithFormat:@"堂食%@",quxiao];
    if ([quxiao isEqualToString:@"0"]) {
        self.quxiaoLabel.text=@"";
    }
    
    NSString * weiping = [NSString stringWithFormat:@"%@",model.weipingjia];
    self.weipingjiaLabel.text = [NSString stringWithFormat:@"打包%@",weiping];
    if ([weiping isEqualToString:@"0"]) {
        self.weipingjiaLabel.text=@"";
    }
    
    NSString * yiping = [NSString stringWithFormat:@"%@",model.yipingjia];
    self.yipingjiaLabel.text = [NSString stringWithFormat:@"外卖%@",yiping];
    if ([yiping isEqualToString:@"0"]) {
        self.yipingjiaLabel.text=@"";
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.dateLabel.frame = CGRectMake(10*MCscale, 10*MCscale,self.width/2.0-20*MCscale, 20*MCscale);
    self.moneyLabel.frame = CGRectMake(self.width/2.0+10*MCscale, self.dateLabel.top, self.width/2.0-20*MCscale, 20*MCscale);
    self.quxiaoLabel.frame = CGRectMake(10*MCscale,self.dateLabel.bottom + 10*MCscale,self.width/3.0-20*MCscale, 20*MCscale);
    self.weipingjiaLabel.frame = CGRectMake(self.width/2.0 -(self.width/3.0-20*MCscale)/2.0, self.quxiaoLabel.top,self.width/3.0-20*MCscale, 20*MCscale);
    self.yipingjiaLabel.frame = CGRectMake(self.width - (self.width/3.0-20*MCscale)-10*MCscale, self.weipingjiaLabel.top, self.width/3.0-20*MCscale, 20*MCscale);
    self.lineView.frame = CGRectMake(0, self.height-1,self.width,1);
}
@end

