//
//  BalanceRecordCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/24.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "BalanceRecordCell.h"
#import "BalanceRecordModel.h"
#import "Header.h"
@interface BalanceRecordCell ()
@property(nonatomic,strong)UILabel *dateLabel,*yueLabel,*shuomingLabel;
@property(nonatomic,strong)UIView *lineView;
@end
@implementation BalanceRecordCell

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
        _dateLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}

-(UILabel *)yueLabel
{
    if (!_yueLabel) {
        _yueLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_yueLabel];
    }
    return _yueLabel;
}

-(UILabel *)shuomingLabel
{
    if (!_shuomingLabel) {
        _shuomingLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
        [self.contentView addSubview:_shuomingLabel];
    }
    return _shuomingLabel;
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
    BalanceRecordModel *model = array[indexpath.row];
    self.dateLabel.text = model.date;
    self.yueLabel.text = [NSString stringWithFormat:@"余额:  %@",model.yue];
//    self.shuomingLabel.text = [NSString stringWithFormat:@"说明:支出%@,到付%@,存入%@",model.zhichu,model.daofu,model.cunru];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.dateLabel.frame = CGRectMake(10*MCscale, 10*MCscale,self.width/2.0-20*MCscale, 20*MCscale);
    self.yueLabel.frame = CGRectMake(self.width/2.0+10*MCscale, self.dateLabel.top, self.width/2.0-20*MCscale, 20*MCscale);
    
    
    self.dateLabel.centerY=self.contentView.height/2;
    self.yueLabel.centerY =self.contentView.height/2;
    
//    self.shuomingLabel.frame = CGRectMake(10*MCscale,self.dateLabel.bottom + 10*MCscale,self.width-20*MCscale, 20*MCscale);
    self.lineView.frame = CGRectMake(0, self.height-1,self.width,1);
    
    
    
}
@end


