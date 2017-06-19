//
//  OrderDetailChangeMoneyAndShuLiangView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/26.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "OrderDetailChangeMoneyAndShuLiangView.h"
#import "Header.h"


@interface OrderDetailChangeMoneyAndShuLiangView()<UITextFieldDelegate>

@property (nonatomic,strong)UIButton * backView;


@property (nonatomic,strong)UITextField * tfJinE;
@property (nonatomic,strong)UITextField * tfShuLiang;
@property (nonatomic,strong)UITextField * tfXianJia;
@property (nonatomic,strong)UITextField * tfMaiRu;

@end
@implementation OrderDetailChangeMoneyAndShuLiangView
-(instancetype)init{
    if (self=[super init]) {

        [self newView];
    }
    return self;
}
-(void)setModel:(OrderDetailShangpinModel *)model{
    _model=model;
    

    [self reshView];
    
}
-(void)reshView{
//    _tfJinE.text=_model.total_money;
    _tfShuLiang.text=[NSString stringWithFormat:@"数量:%@",_model.shuliang];
    _tfXianJia.text=[NSString stringWithFormat:@"现价:%@",_model.xianjia];
    _tfMaiRu.text=[NSString stringWithFormat:@"买入价:%@",_model.total_money];
}
-(void)newView{
    _backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.7, 100);
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    //    self.clipsToBounds=YES;
    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [_backView addSubview:self];
    
    
 
    
    CGFloat setY = 10*MCscale;
    
    
    
    CGFloat fX = 20*MCscale;
    CGFloat fW = self.width-40*MCscale;
    CGFloat fH = 40*MCscale;
    
    for (int i =0 ; i < 3; i ++) {
        
        
        UITextField * textfield = [[UITextField alloc]initWithFrame:CGRectMake(fX, setY, fW, fH)];
        textfield.textAlignment=NSTextAlignmentCenter;
        textfield.font=[UIFont systemFontOfSize:MLwordFont_4];
        [self addSubview:textfield];
        
        UIView * line= [[UIView alloc]initWithFrame:CGRectMake(0, 0, textfield.width, 1)];
        line.backgroundColor=lineColor;
        line.bottom=textfield.height;
        [textfield addSubview:line];
        textfield.userInteractionEnabled=NO;
        
        switch (i) {
            case 0:
            {
                textfield.placeholder=@"请输入金额";
                textfield.textColor=textBlackColor;
                textfield.userInteractionEnabled=YES;
                textfield.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
                textfield.delegate=self;
                _tfJinE=textfield;
                
            }
                break;
            case 1:
            {
                textfield.textColor=redTextColor;
                _tfShuLiang=textfield;
            }
                break;
            case 2:
            {
                _tfXianJia=textfield;
                textfield.width=fW/2;
                textfield.textAlignment=NSTextAlignmentLeft;
                textfield.textColor=textBlackColor;
                
                UITextField * textfieldRight = [[UITextField alloc]initWithFrame:CGRectMake(fX+textfield.width, setY, fW/2, fH)];
                _tfMaiRu=textfieldRight;
                textfieldRight.textColor=textBlackColor;
                textfieldRight.textAlignment=NSTextAlignmentRight;
                textfieldRight.font=[UIFont systemFontOfSize:MLwordFont_4];
                [self addSubview:textfieldRight];
                
            }
                break;
            default:
                break;
        }
        
        setY=textfield.bottom;
    }
    
    UIButton * saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, setY+20*MCscale, 100*MCscale, 40*MCscale)];
    [self addSubview:saveBtn];
    saveBtn.centerX=self.width/2;
    saveBtn.backgroundColor=redTextColor;
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius=5;
    setY=saveBtn.bottom;
    
    
    self.height=setY+20*MCscale;
    self.centerY=[UIScreen mainScreen].bounds.size.height/2-40*MCscale;
    
}

-(void)saveBtnClick:(UIButton *)sender{
    [self disAppear];
    if (_block) {
        _block([_tfJinE.text floatValue]);
    }
    [MBProgressHUD promptWithString:@"保存成功"];
}
-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![newString isValidateMoneying]) {
        [MBProgressHUD promptWithString:@"请输入正确的金额"];
        return NO;
    }
    _model.shuliang=[NSString stringWithFormat:@"%.2f",[newString floatValue]/[_model.xianjia floatValue]];
    [self reshView];
    return YES;
}

@end
