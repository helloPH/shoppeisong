//
//  ShuohuoMoneyView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/22.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "ShuohuoMoneyView.h"
#import "Header.h"
@interface ShuohuoMoneyView ()<UITextFieldDelegate,MBProgressHUDDelegate>
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextField *moneyTextField;
@property(nonatomic,strong)UIView *line1,*line2;
@property(nonatomic,strong)UIButton *saveBtn;
@end
@implementation ShuohuoMoneyView

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

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:[NSString stringWithFormat:@"单号:%@",self.danhao]];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
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
        _moneyTextField = [BaseCostomer textfieldWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors textAlignment:1 keyboardType:UIKeyboardTypeNumbersAndPunctuation borderStyle:0 placeholder:@"请输入该单实际付款金额"];
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
    self.titleLabel.frame = CGRectMake(20*MCscale,20*MCscale, self.width-40*MCscale, 30*MCscale);
    self.line1.frame = CGRectMake(10*MCscale, self.titleLabel.bottom, self.width - 20*MCscale, 1);
    self.moneyTextField.frame = CGRectMake(20*MCscale, self.titleLabel.bottom +20*MCscale, self.width - 40*MCscale, 30*MCscale);
    self.line2.frame = CGRectMake(10*MCscale, self.moneyTextField.bottom, self.width - 20*MCscale, 1);
    self.saveBtn.frame = CGRectMake(self.width/2.0-50*MCscale,self.line2.bottom +25*MCscale, 100*MCscale, 30*MCscale);
}

-(void)saveBtnClick
{
//    if ([self.fujiafeiDelegate respondsToSelector:@selector(saveFujiafeiWithName:AndMoney:)]) {
//        [self.fujiafeiDelegate saveFujiafeiWithName:self.nameTextField.text AndMoney:self.moneyTextField.text];
//    }
        
    if ([self.moneyTextField.text integerValue]>[self.caigouchengben integerValue]) {
        [self promptMessageWithString:@"输入金额不能大于采购成本"];
    }
    else
    {
        MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        mHud.mode = MBProgressHUDModeIndeterminate;
        mHud.delegate = self;
        mHud.labelText = @"请稍等...";
        [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id,@"danhao":self.danhao,@"shifujine":self.moneyTextField.text}];
    [HTTPTool getWithUrl:@"shouhuo.action" params:pram success:^(id json) {
        [mHud hide:YES];
        NSLog(@"收货 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 0) {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if ([[json valueForKey:@"message"] integerValue] == 2)
        {
            [self promptMessageWithString:@"收货失败"];
        }
        else
        {
            if ([self.shouhuoDelegate respondsToSelector:@selector(shouhuoSuccess)]) {
                [self.shouhuoDelegate shouhuoSuccess];
            }
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.moneyTextField resignFirstResponder];
    return YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.moneyTextField resignFirstResponder];
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1);
}
@end

