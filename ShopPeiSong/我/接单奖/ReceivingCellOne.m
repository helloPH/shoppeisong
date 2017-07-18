//
//  ReceivingCellOne.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/9.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "ReceivingCellOne.h"
#import "ReceivedDingdanModel.h"
#import "Header.h"
@interface ReceivingCellOne ()

@property(nonatomic,strong)UILabel *danhaoLabel,*moneyLabel,*yongshiLabel,*timeLabel,*infoLabel,*pingjiaLabel;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)NSArray *statesArray;
@end
@implementation ReceivingCellOne

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(UILabel *)danhaoLabel
{
    if (!_danhaoLabel) {
        _danhaoLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_danhaoLabel];
    }
    return _danhaoLabel;
}

-(UILabel *)pingjiaLabel
{
    if (!_pingjiaLabel) {
        _pingjiaLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_9] textColor:textBlackColor backgroundColor:txtColors(214, 214,214, 1) textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
        [self.contentView addSubview:_pingjiaLabel];
    }
    return _pingjiaLabel;
}
-(UILabel *)yongshiLabel
{
    if (!_yongshiLabel) {
        _yongshiLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
        [self.contentView addSubview:_yongshiLabel];
    }
    return _yongshiLabel;
}
-(UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:mainColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];
        [self.contentView addSubview:_infoLabel];
    }
    return _infoLabel;
}
-(UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:lineColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight numOfLines:1 text:@""];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}
-(NSArray *)statesArray
{
    if (!_statesArray) {
        _statesArray = @[@"未评价",@"取消订单",@"已评价"];
    }
    return _statesArray;
}
-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    ReceivedDingdanModel *model = array[indexpath.row];
    self.danhaoLabel.text = model.danhao;
    self.moneyLabel.text = [NSString stringWithFormat:@"金额:  %@",model.jine];
    self.yongshiLabel.text = [NSString stringWithFormat:@"%@",model.yongshi];
    if (![self.yongshiLabel.text hasSuffix:@"分钟"]) {
        self.yongshiLabel.text = @"";
    }
    
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.time];

    
    if ([model.status integerValue] == 4) {
        self.pingjiaLabel.backgroundColor = txtColors(214, 214,214, 1);
        self.pingjiaLabel.textColor  = textColors;
    }
    else
    {
        self.pingjiaLabel.backgroundColor = redTextColor;
        self.pingjiaLabel.textColor  = [UIColor whiteColor];
        

        self.infoLabel.text = [NSString stringWithFormat:@"%@",model.info] ;
        if ([self.infoLabel.text isEqualToString:@"0"]) {
            self.infoLabel.text = @"";
        }
        if ([self.infoLabel.text hasSuffix:@":0"]) {
            self.infoLabel.text = @"好";
        }
        
//        }
    }

    
    self.pingjiaLabel.text = [NSString stringWithFormat:@"%@",self.statesArray[[model.status integerValue]-4]];

    if ([model.status integerValue]-4 == 1) {
        self.yongshiLabel.hidden=YES;
    }else{
        self.yongshiLabel.hidden=NO;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.danhaoLabel.frame = CGRectMake(10*MCscale, 10*MCscale,180*MCscale, 20*MCscale);
    self.yongshiLabel.frame = CGRectMake(self.width - 90*MCscale, 10*MCscale,80*MCscale, 20*MCscale);
    self.pingjiaLabel.frame = CGRectMake(self.danhaoLabel.right+20*MCscale, 10*MCscale, 60*MCscale, 20*MCscale);
    self.infoLabel.frame = CGRectMake(10*MCscale, self.danhaoLabel.bottom +10*MCscale, 100*MCscale, 20*MCscale);
    self.moneyLabel.frame = CGRectMake(self.width/2.0-50*MCscale, self.infoLabel.top, 100*MCscale, 20*MCscale);
    self.timeLabel.frame = CGRectMake(self.moneyLabel.right +10*MCscale, self.moneyLabel.top,self.width/2.0-70*MCscale, 20*MCscale);
    self.lineView.frame = CGRectMake(0, self.height-1,self.width,1);
}
@end
