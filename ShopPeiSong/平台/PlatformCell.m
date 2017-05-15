//
//  PlatformCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/6.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "PlatformCell.h"
#import "Header.h"
@interface PlatformCell()
@property(nonatomic,strong)UIImageView *headImageView,*yuanImage;//头像,圆点
@property(nonatomic,strong)UILabel *danhaoLabel,*nameLabel,*addressLabel,*timeLabel;//单号,商户名,地址,时间
@property(nonatomic,strong)UIButton *jiedanBtn;//接单按钮
@property(nonatomic,strong)UIView *lineView;//
@property(nonatomic,strong)NSString *danhaoStr;
@property (nonatomic,strong)KeQiangDiandanModel * model;

@end
@implementation PlatformCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(UIImageView *)yuanImage
{
    if (!_yuanImage) {
        _yuanImage = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@"yuan"];
    }
    return _yuanImage;
}

-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] cornerRadius:35*MCscale userInteractionEnabled:NO image:@"yonghutouxiang"];
        [self.contentView addSubview:_headImageView];
        [_headImageView addSubview:self.yuanImage];
    }
    return _headImageView;
}

-(UILabel *)danhaoLabel
{
    if (!_danhaoLabel) {
        _danhaoLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_danhaoLabel];
    }
    return _danhaoLabel;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}
-(UIButton *)jiedanBtn
{
    if (!_jiedanBtn) {
        _jiedanBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:redTextColor backGroundColor:[UIColor clearColor] cornerRadius:10*MCscale text:@"抢单" image:@""];
        _jiedanBtn.layer.borderWidth = 1.5*MCscale;
        _jiedanBtn.layer.borderColor = redTextColor.CGColor;
        [_jiedanBtn addTarget:self action:@selector(jiedanBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_jiedanBtn];
    }
    return _jiedanBtn;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
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

-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
 
    KeQiangDiandanModel *model = array[indexpath.row];
    _model=model;
    self.danhaoLabel.text = [NSString stringWithFormat:@"单号:%@",model.danhao];
    self.nameLabel.text = [NSString stringWithFormat:@"应收:%@",model.shanghu];
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",model.shouhuodizhi];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.time];
    
    NSString * isPeiSong = _model.peisongfangshi; //
    [self.jiedanBtn setTitle:[isPeiSong isEqualToString:@"0"]?@"明细":@"抢单" forState:UIControlStateNormal];
    
    NSString *imageUrl;
    if (user_dianpulogo) {
        imageUrl = user_dianpulogo;
    }
    else
    {
        imageUrl = model.dianpulogo;
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    self.danhaoStr = model.danhao;
    
    NSString *zhiwuStr  = [[NSUserDefaults standardUserDefaults]valueForKey:@"bumen"];
    if ([zhiwuStr isEqualToString:@"供应"])
    {
        self.jiedanBtn.hidden = YES;
    }
    else
    {
        if ([model.shifoukeqiang integerValue] == 1) {//可抢
            [self.jiedanBtn setTitleColor:redTextColor forState:UIControlStateNormal];
            self.jiedanBtn.layer.borderColor = redTextColor.CGColor;
            self.jiedanBtn.enabled = YES;
        }
        else
        {
            //不可抢
            [self.jiedanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.jiedanBtn.layer.borderColor = [UIColor grayColor].CGColor;
            self.jiedanBtn.enabled = NO;
        }
    }
    if ([model.status integerValue] == 0||[model.status integerValue]==1) {
        self.yuanImage.hidden = NO;
    }
    else
    {
        self.yuanImage.hidden = YES;
    }
}
#pragma mark 接单按钮点击事件
-(void)jiedanBtnClick
{
    NSString * isPei = _model.peisongfangshi;// _model
    if ([isPei isEqualToString:@"0"]) {
        if ([self.platformDelagete respondsToSelector:@selector(jinRuXiangQing:)]) {
            [self.platformDelagete jinRuXiangQing:self.danhaoStr];
        }
    }else{
        if ([self.platformDelagete respondsToSelector:@selector(qiangdanButtonClickWithDanhao:)]) {
            [self.platformDelagete qiangdanButtonClickWithDanhao:self.danhaoStr];
        }
    }
    
    

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10*MCscale);
        make.height.width.equalTo(@(70*MCscale));
    }];
    
    [self.yuanImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView).offset(48*MCscale);
        make.top.equalTo(self.headImageView).offset(8*MCscale);
        make.size.equalTo(@(15*MCscale));
    }];
    
    [self.danhaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).and.offset(5*MCscale); //and 增强可读性
        make.top.equalTo(self.headImageView.mas_top);
        make.width.equalTo(@(200*MCscale));
        make.height.equalTo(@(20*MCscale));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.danhaoLabel.mas_left);
        make.top.equalTo(self.danhaoLabel.mas_bottom).offset(5*MCscale);
        make.width.equalTo(self.danhaoLabel.mas_width);
        make.height.equalTo(self.danhaoLabel.mas_height);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.danhaoLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5*MCscale);
        make.width.equalTo(self.nameLabel.mas_width);
        make.height.equalTo(self.nameLabel.mas_height);
    }];
    
    [self.jiedanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10*MCscale);
        make.top.equalTo(self.danhaoLabel.mas_top).offset(-5*MCscale);
        make.width.equalTo(@(70*MCscale));
        make.height.equalTo(@(25*MCscale));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jiedanBtn.mas_left);
        make.top.equalTo(self.addressLabel.mas_top);
        make.width.equalTo(self.jiedanBtn.mas_width);
        make.height.equalTo(self.nameLabel.mas_height);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_bottom).offset(-1*MCscale);
        make.height.equalTo(@(1*MCscale));
    }];
}
@end
