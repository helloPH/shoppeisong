//
//  AlterFujiaFeiView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/7/10.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "AlterFujiaFeiView.h"
#import "Header.h"
#import "PHButton.h"


@interface AlterFujiaFeiView()<UITextFieldDelegate>

@property (nonatomic,strong)UIScrollView * backView;


@property (nonatomic,strong)UITextField * textField;
@property (nonatomic,strong)PHButton * submitBtn;

@end
@implementation AlterFujiaFeiView
-(instancetype)init{
    if (self=[super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, 100)]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [_backView addGestureRecognizer:tap];
    
    
    
    //    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    //    self.clipsToBounds=YES;
    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [_backView addSubview:self];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(self.width*0.2, 20, self.width*0.6, 30)];
    _textField.keyboardType=UIKeyboardTypeNumberPad;
    _textField.backgroundColor=lineColor;
    _textField.placeholder = @"";
    _textField.font=[UIFont systemFontOfSize:MLwordFont_4];
    _textField.textColor=textBlackColor;
    _textField.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_textField];
    
    
    _submitBtn = [[PHButton alloc]initWithFrame:CGRectMake(0, _textField.bottom+20, 100, 30)];
    [self addSubview:_submitBtn];
    _submitBtn.centerX=self.width/2;
    _submitBtn.backgroundColor=redTextColor;
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    [_submitBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_submitBtn setTitle:@"保存" forState:UIControlStateNormal];
    _submitBtn.layer.cornerRadius=5;
    
    self.height= _submitBtn.bottom+10;
    
}
-(void)saveBtnClick:(UIButton *)sender{
    
    if ([_textField.text isEmptyString]) {
        [MBProgressHUD promptWithString:@"请输入金额"];
        return;
    }
    if (_block) {
        _block(_textField.text);
    }
}


#pragma  mark   --  textField  delegate 
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString isValidateMoneying]) {
        return YES;
    }
    return NO;
}





-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    //    [[self getCurrentVC].view addSubview:_backView];
    //    [[UIViewController presentingVC].view addSubview:_backView];
    _backView.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0.95;
    }];
}
-(void)disAppear{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
