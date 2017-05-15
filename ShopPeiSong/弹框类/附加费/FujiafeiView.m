//
//  FujiafeiView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/22.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "FujiafeiView.h"
#import "Header.h"
@interface FujiafeiView ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *nameTextField,*moneyTextField;
@property(nonatomic,strong)UIView *line1,*line2;
@property(nonatomic,strong)UIButton *saveBtn;
@end
@implementation FujiafeiView

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

-(UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors textAlignment:1 keyboardType:0 borderStyle:0 placeholder:@"附加费名称"];
        _nameTextField.delegate = self;
        _nameTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_nameTextField];
    }
    return _nameTextField;
}
-(UIView *)line1
{
    if (!_line1) {
        _line1 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_line1];
    }
    return _line1;
}
-(UITextField *)moneyTextField
{
    if (!_moneyTextField) {
        _moneyTextField = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors textAlignment:1 keyboardType:UIKeyboardTypeNumbersAndPunctuation borderStyle:0 placeholder:@"金额"];
        _moneyTextField.delegate = self;
        _moneyTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_moneyTextField];
    }
    return _moneyTextField;
}

-(UIView *)line2
{
    if (!_line2) {
        _line2 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_line2];
    }
    return _line2;
}

-(UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:3.0 text:@"保存" image:@""];
        [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveBtn];
    }
    return _saveBtn;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nameTextField.frame = CGRectMake(20*MCscale,20*MCscale, self.width-40*MCscale, 30*MCscale);
    self.line1.frame = CGRectMake(10*MCscale, self.nameTextField.bottom, self.width - 20*MCscale, 1);
    self.moneyTextField.frame = CGRectMake(20*MCscale, self.nameTextField.bottom +20*MCscale, self.width - 40*MCscale, 30*MCscale);
    self.line2.frame = CGRectMake(10*MCscale, self.moneyTextField.bottom, self.width - 20*MCscale, 1);
    self.saveBtn.frame = CGRectMake(self.width/2.0-50*MCscale,self.line2.bottom +10*MCscale, 100*MCscale, 30*MCscale);
}

-(void)saveBtnClick
{
    if ([self.fujiafeiDelegate respondsToSelector:@selector(saveFujiafeiWithName:AndMoney:)]) {
        [self.fujiafeiDelegate saveFujiafeiWithName:self.nameTextField.text AndMoney:self.moneyTextField.text];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameTextField resignFirstResponder];
    [self.moneyTextField resignFirstResponder];
    return YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
    [self.moneyTextField resignFirstResponder];
}
@end
