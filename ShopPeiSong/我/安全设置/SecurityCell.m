//
//  SecurityCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/8.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "SecurityCell.h"
#import "Header.h"
@interface SecurityCell()

@property(nonatomic,strong)UILabel *nameLabel,*stateLabel,*telLabel;
@property(nonatomic,strong)UIImageView *rightImage;
@property(nonatomic,strong)UIView *lineView,*rightView;
@property(nonatomic,strong)NSArray *nameArray;
@property (nonatomic,strong)UISwitch *switchView;


@property (nonatomic,strong)NSIndexPath * indexPath;
@end
@implementation SecurityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePhoneNumberNotiClick:) name:@"changePhoneNumberNoti" object:nil];

    }
    return self;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors text:@""];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UIImageView *)rightImage
{
    if (!_rightImage) {
        _rightImage = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@"xialas"];
        [self.contentView addSubview:_rightImage];
    }
    return _rightImage;
}

-(UIView *)rightView
{
    if (!_rightView) {
        _rightView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_rightView];
    }
    return _rightView;
}

-(NSArray *)nameArray
{
    if (!_nameArray) {
        _nameArray = @[@"登录密码",@"提现密码",@"更换注册设备",@"新单自动提醒",@"免密支付",@"更新店铺图片",@"已绑定手机号"];
    }
    return _nameArray;
}
-(UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:txtColors(203,203,203,1) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight numOfLines:1 text:@""];
    }
    return _stateLabel;
}

-(UILabel *)telLabel
{
    if (!_telLabel) {
        _telLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors text:@""];
    }
    return _telLabel;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}
-(UISwitch *)switchView
{
    if (!_switchView) {
        _switchView = [[UISwitch alloc]initWithFrame:CGRectZero];
        _switchView.tintColor = lineColor;
        _switchView.onTintColor = [UIColor greenColor];
        [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}
-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath
{
    self.indexPath=indexpath;
    self.nameLabel.text = self.nameArray[indexpath.row];
    if (indexpath.row == 3 || indexpath.row == 4) {
        [self.rightView addSubview:self.switchView];
    }
    else
    {
        self.stateLabel.text = @"修改";
        [self.rightView addSubview:self.stateLabel];
    }
    
    if (indexpath.row == 6) {
        NSString *telStr = [BaseCostomer phoneNumberJiamiWithString:user_tel];
        self.telLabel.text = telStr;
        [self.contentView addSubview:self.telLabel];
    }
}
-(void)changePhoneNumberNotiClick:(NSNotification *)noti
{
    NSString *telStr = [BaseCostomer phoneNumberJiamiWithString:user_tel];
    self.telLabel.text = telStr;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(10*MCscale, self.height/2.0-10*MCscale, 150*MCscale, 20*MCscale);
    self.rightImage.frame = CGRectMake(self.width - 25*MCscale, self.height/2.0-10*MCscale, 15*MCscale, 20*MCscale);
    self.rightView.frame = CGRectMake(self.width - 25*MCscale-50*MCscale, self.height/2.0-15*MCscale, 50*MCscale,30*MCscale);
    self.stateLabel.frame = CGRectMake(0, 5*MCscale, self.rightView.width, 20*MCscale);
    self.switchView.frame = CGRectMake(0,0, self.rightView.width, 20*MCscale);
    self.telLabel.frame = CGRectMake(self.nameLabel.right +10*MCscale, self.height/2.0-10*MCscale, 150*MCscale, 20*MCscale);
    self.lineView.frame = CGRectMake(0, self.height-1, self.width, 1);
    
    if (_indexPath.row==4) {
        self.switchView.on=mianMiPay;
    }
}
-(void)switchAction:(UISwitch *)SWView
{
    if (_indexPath.row==3) {
        if (SWView.on == 1) {
            if ([self.securityDelegate respondsToSelector:@selector(selectedTixingTime)]) {
                [self.securityDelegate selectedTixingTime];
            }
        }
    }
    if (_indexPath.row==4) {
        set_MianMiPay(self.switchView.on);
    }
    

    
    
}
@end
