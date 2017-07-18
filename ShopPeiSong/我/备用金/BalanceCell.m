//
//  BalanceCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/24.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "BalanceCell.h"
#import "BalanceModel.h"
#import "Header.h"
@interface BalanceCell ()

@property(nonatomic,strong)UILabel *nameLabel,*timeLabel,*yueLabel,*danhaoLabel,*moneyLabel;
@property(nonatomic,strong)UIImageView *statesImage,*shuomingImage;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)NSArray *statesArray;
@property(nonatomic,strong)NSString *zhangdanID;

@property(nonatomic,strong)BalanceModel * model;
@end

@implementation BalanceCell

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
        _nameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UIImageView *)statesImage
{
    if (!_statesImage) {
        _statesImage = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@""];
        [self.contentView addSubview:_statesImage];
        
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapClick:)];
        [_statesImage addGestureRecognizer:imageTap];
    }
    return _statesImage;
}
-(UIImageView *)shuomingImage
{
    if (!_shuomingImage) {
        _shuomingImage = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor]  cornerRadius:0 userInteractionEnabled:YES image:@""];
        [self.contentView addSubview:_shuomingImage];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapClick:)];
        [_shuomingImage addGestureRecognizer:imageTap];
    }
    return _shuomingImage;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight numOfLines:1 text:@""];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)yueLabel
{
    if (!_yueLabel) {
        _yueLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:mainColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];
        [self.contentView addSubview:_yueLabel];
    }
    return _yueLabel;
}
-(UILabel *)danhaoLabel
{
    if (!_danhaoLabel) {
        _danhaoLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:lineColor backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:@""];
        [self.contentView addSubview:_danhaoLabel];
    }
    return _danhaoLabel;
}

-(UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:2 numOfLines:1 text:@""];
        [self.contentView addSubview:_moneyLabel];
    }
    return _moneyLabel;
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
        _statesArray = @[@"",@"dong_numnber2",@"xian_number1"];
    }
    return _statesArray;
}
-(NSString *)zhangdanID
{
    if (!_zhangdanID) {
        _zhangdanID = @"";
    }
    return _zhangdanID;
}
-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    BalanceModel *model = array[indexpath.row];
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.leimu];
    self.statesImage.image = [UIImage imageNamed:self.statesArray[[model.status integerValue]]];
    self.timeLabel.text  = [NSString stringWithFormat:@"%@",model.date];
    self.yueLabel.text = [NSString stringWithFormat:@"余额%.2f",[model.yue floatValue]];
    
    
    self.danhaoLabel.text = [NSString stringWithFormat:@"%@",model.danhao];
    if ([self.danhaoLabel.text isEqualToString:@"0"]) {
        self.danhaoLabel.text = @"";
    }
    
    
    if ([model.type integerValue] == 0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"-¥%.2f",[model.jine floatValue]];
    }
    else
    {
        self.moneyLabel.text = [NSString stringWithFormat:@"+¥%.2f",[model.jine floatValue]];
    }
    
    if ([model.shuoming integerValue] == 1) {
        if ([model.status integerValue] == 0) {
            self.statesImage.image = [UIImage imageNamed:@"shuo_number3"];
            self.statesImage.userInteractionEnabled = YES;
        }
        else
        {
            self.shuomingImage.image = [UIImage imageNamed:@"shuo_number3"];
            self.statesImage.userInteractionEnabled = NO;
        }
    }
    self.zhangdanID = model.zhangdanid;
}

-(void)imageTapClick:(UITapGestureRecognizer *)tap
{
    if ([_model.shuoming integerValue] != 1) {
        return;
    }
    
    if ([self.balanceDelegate respondsToSelector:@selector(getZhangdanShuomingDataWithZhangdanID:)])
    {
        
        
        [self.balanceDelegate getZhangdanShuomingDataWithZhangdanID:self.zhangdanID];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(10*MCscale, 10*MCscale,80*MCscale, 20*MCscale);
    self.statesImage.frame = CGRectMake(self.nameLabel.right, self.nameLabel.top,20*MCscale, 20*MCscale);
    self.shuomingImage.frame = CGRectMake(self.statesImage.right, self.nameLabel.top,20*MCscale, 20*MCscale);
    self.timeLabel.frame = CGRectMake(self.width/2.0+10*MCscale, 10*MCscale,self.width/2.0-20*MCscale, 20*MCscale);
    self.yueLabel.frame = CGRectMake(10*MCscale, self.nameLabel.bottom +10*MCscale, 100*MCscale, 20*MCscale);
    self.danhaoLabel.frame = CGRectMake(self.yueLabel.right +10*MCscale, self.yueLabel.top,self.width-220*MCscale, 20*MCscale);
    self.moneyLabel.frame = CGRectMake(self.width-90*MCscale,self.danhaoLabel.top,80*MCscale, 20*MCscale);
    self.lineView.frame = CGRectMake(10*MCscale, self.height-1,self.width-20*MCscale,1);
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    //重置图片
    self.shuomingImage.image = nil;
    self.statesImage.image = nil;
    //更新位置
    self.shuomingImage.frame = self.contentView.bounds;
    self.statesImage.frame = self.contentView.bounds;
    self.statesImage.userInteractionEnabled = YES;
    
}
@end
