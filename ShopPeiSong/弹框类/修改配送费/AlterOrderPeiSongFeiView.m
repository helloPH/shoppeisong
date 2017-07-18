//
//  AlterOrderPeiSongFeiView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/21.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "AlterOrderPeiSongFeiView.h"
#import "Header.h"

@interface AlterOrderPeiSongFeiView()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton * backView;
@property (nonatomic,strong)UITextField * textField;
@end
@implementation AlterOrderPeiSongFeiView
-(instancetype)init{
    if (self=[super init]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    _backView.alpha=0;
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    [_backView addSubview:self];
    self.backgroundColor=[UIColor whiteColor];
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-80, 100);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    CGFloat setY = 20*MCscale;
    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(10*MCscale, setY, self.width-20*MCscale, 30*MCscale)];
    [self addSubview:textField];
    textField.placeholder=@"请填写配送费";
    textField.font=[UIFont systemFontOfSize:MLwordFont_4];
    textField.delegate=self;
    textField.textAlignment=NSTextAlignmentCenter;
    _textField = textField;
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, textField.width, 1)];
    [textField addSubview:line];
    line.backgroundColor=lineColor;
    line.bottom=textField.height;
    
    setY = textField.bottom;
    
    UIButton * submit = [[UIButton alloc]initWithFrame:CGRectMake(0, setY+20*MCscale, 100*MCscale, 30*MCscale)];
    [self addSubview:submit];
    submit.centerX=self.width/2;
    submit.layer.cornerRadius=5;
    submit.layer.masksToBounds=YES;
    [submit setBackgroundColor:redTextColor];
    [submit setTitle:@"修改" forState:UIControlStateNormal];
    submit.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_5];
    [submit addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    setY = submit.bottom;
    
    self.height=setY+20*MCscale;
}
-(void)submitBtnClick:(UIButton *)sender{
    if (![_textField.text isValidateMoneyed]) {
        [MBProgressHUD promptWithString:@"请输入正确的金额"];
        return;
    }

    NSDictionary * pram = @{@"danhao":_danhao,
                            @"leibie":_textField.text};
    [Request alterOrderPeiSongFeiWithDic:pram success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"massages"]];
        if ([message isEqualToString:@"1"]) {
            [MBProgressHUD promptWithString:@"修改成功"];
            [self disAppear];
            if (_block) {
                _block();
            }
        }else{
            [MBProgressHUD promptWithString:@"修改失败"];
        }
        
       
   
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)appear{
    self.centerX=[UIScreen mainScreen].bounds.size.width/2;
    self.centerY=[UIScreen mainScreen].bounds.size.height/2;
    
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0.95;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)disAppear{
    __weak AlterOrderPeiSongFeiView * weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [weakSelf removeFromSuperview];
    }];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![currentString isValidateMoneying]) {
        [MBProgressHUD promptWithString:@"请输入正确的金额"];
        return NO;
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
