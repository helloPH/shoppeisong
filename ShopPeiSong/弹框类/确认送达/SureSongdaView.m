//
//  SureSongdaView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/23.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "SureSongdaView.h"
#import "Header.h"

@interface SureSongdaView() <MBProgressHUDDelegate>
@property(nonatomic,strong)UILabel *titleLabel1,*titleLabel2;//提示信息
@property(nonatomic,strong)UIView *lineView;//
@property(nonatomic,strong)UIButton *sureBtn;

@end
@implementation SureSongdaView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}

-(UILabel *)titleLabel1
{
    if (!_titleLabel1) {
        _titleLabel1 = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:txtColors(193, 188, 188, 1) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:2 text:@"当前订单为确认收货"];
        [self addSubview:_titleLabel1];
    }
    return _titleLabel1;
}
-(UILabel *)titleLabel2
{
    if (!_titleLabel2) {
        _titleLabel2 = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:txtColors(193, 188, 188, 1) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:2 text:@"已全额收款"];
        [self addSubview:_titleLabel2];
    }
    return _titleLabel2;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}

-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:3.0 text:@"确定" image:@""];
        [_sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
    }
    return _sureBtn;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel1.frame = CGRectMake(20*MCscale,25*MCscale, self.width-40*MCscale,25*MCscale);
    self.titleLabel2.frame = CGRectMake(20*MCscale,self.titleLabel1.bottom, self.width-40*MCscale,25*MCscale);
    self.lineView.frame = CGRectMake(10*MCscale, self.titleLabel2.bottom +5*MCscale, self.width - 20*MCscale, 1);
    self.sureBtn.frame = CGRectMake(self.width/2.0-50*MCscale, self.lineView.bottom+18*MCscale, 100*MCscale, 30*MCscale);
}
-(void)buttonClick:(UIButton *)button
{
    if ([self.songdaDelegate respondsToSelector:@selector(sureSongdaSuccessWithDanhao:)]) {
        [self.songdaDelegate sureSongdaSuccessWithDanhao:self.danhao];
    }
}
@end



