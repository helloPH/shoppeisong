//
//  ModifyKaihufeiView.m
//  GoodYeWu
//
//  Created by MIAO on 16/11/17.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ModifyKaihufeiView.h"
#import "Header.h"

@interface ModifyKaihufeiView()

@property(nonatomic,strong)UITextField *kaihufeiTextfield;
@property(nonatomic,strong)UILabel *nianfeiLabel;
@property(nonatomic,strong)UIButton *submitBtn;

@end
@implementation ModifyKaihufeiView
{
    UIView *lineView;
    UIView *lineView2;
}
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
        [self createUI];
    }
    return self;
}
-(UITextField *)kaihufeiTextfield
{
    if (_kaihufeiTextfield == nil) {
        _kaihufeiTextfield = [[UITextField alloc]initWithFrame:CGRectMake(30*MCscale, 15*MCscale, self.width - 60*MCscale, 35*MCscale)];
        _kaihufeiTextfield.textAlignment = NSTextAlignmentCenter;
        _kaihufeiTextfield.textColor = textColors;
        _kaihufeiTextfield.keyboardType = UIKeyboardTypeNumberPad;
        _kaihufeiTextfield.font = [UIFont systemFontOfSize:MLwordFont_4];
        if (user_kaihufei) {
            _kaihufeiTextfield.placeholder = [NSString stringWithFormat:@"开户费%@",user_kaihufei];
        }
        else
        {
            _kaihufeiTextfield.placeholder = [NSString stringWithFormat:@"开户费1000"];
        }
        [self addSubview:self.kaihufeiTextfield];
    }
    return _kaihufeiTextfield;
}
-(UILabel *)nianfeiLabel
{
    if (_nianfeiLabel == nil) {
        _nianfeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, lineView.bottom+5*MCscale, self.width - 60*MCscale, 35*MCscale)];
        _nianfeiLabel.textAlignment = NSTextAlignmentCenter;
        _nianfeiLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
        _nianfeiLabel.textColor = textColors;
        _nianfeiLabel.text = @"租用年费365";
        [self addSubview:self.nianfeiLabel];
    }
    return _nianfeiLabel;
}

-(UIButton *)submitBtn
{
    if (_submitBtn == nil) {
        _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(30*MCscale,self.height-50*MCscale, self.width - 60*MCscale, 40*MCscale)];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
        _submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _submitBtn.layer.cornerRadius = 5;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.backgroundColor = txtColors(250, 54, 71, 1);
        _submitBtn.enabled = YES;
        [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
-(void)createUI
{
    [self addSubview:self.submitBtn];
    lineView = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale, self.kaihufeiTextfield.bottom + 5*MCscale, self.width - 40*MCscale, 1)];
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
    
    lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale,self.nianfeiLabel.bottom + 5*MCscale, self.width - 40*MCscale, 1)];
    lineView2.backgroundColor = lineColor;
    [self addSubview:lineView2];
}
-(void)submitBtnClick
{
//    self.kaihufeiTextfield.text = @"";
    if ([self.modefyDelegate respondsToSelector:@selector(modifyKaihufeiWithString:)]) {
        [self.modefyDelegate modifyKaihufeiWithString:self.kaihufeiTextfield.text];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.kaihufeiTextfield resignFirstResponder];
}
@end
