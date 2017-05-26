//
//  ShouShiMiMaView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/25.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "ShouShiMiMaView.h"
#import "LatexView.h"
#import "UIViewExt.h"
#import "Header.h"

@interface ShouShiMiMaView()
@property (nonatomic,strong)UIButton * backView;
@property (nonatomic,strong)UIButton  * titleButton;


@property (nonatomic,strong)LatexView * latex;
@end
@implementation ShouShiMiMaView
-(instancetype)init{
    if (self=[super init]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    _backView.enabled=NO;
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, [UIScreen mainScreen].bounds.size.width*0.8);
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [_backView addSubview:self];
    
    UIButton * titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.width, 40*MCscale)];
    [titleButton setTitleColor:textBlackColor forState:UIControlStateNormal];
    titleButton.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_5];
    [self addSubview:titleButton];
    [titleButton setTitle:@"请输入手势密码" forState:UIControlStateNormal];
    _titleButton=titleButton;

    
    
    
    LatexView * latex= [[LatexView alloc]initWithFrame:CGRectMake(0, titleButton.bottom, self.width, self.width)];
    _latex=latex;
    __block LatexView *  weakLatex =latex;
    _latex.passWord=_passWord;
    _latex.backgroundColor=[UIColor whiteColor];
    

    __block ShouShiMiMaView *  weakSelf =self;
    [self addSubview:latex];
    _latex.block=^(NSString * password){
        if (weakSelf.passBlock) {
            weakSelf.passBlock(password);
            
            
            NSString * currPass = [NSString stringWithFormat:@"%@",weakSelf.passWord];
            if ([currPass isEmptyString] || [currPass isEqualToString:password]) {
            }else{
                [UIView animateWithDuration:1 animations:^{
                    weakLatex.alpha=0.95;
                } completion:^(BOOL finished) {
                    weakLatex.alpha=1;
                    [weakLatex setStatus:lockBtnTypeNoSelected];
                }];
            }
        }
 
    };

    
    self.height=latex.bottom+7.5;
    
}
-(void)setPassWord:(NSString *)passWord{
    _passWord=passWord;
    _latex.passWord=_passWord;
    
}
-(void)setTitle:(NSString *)title{
    [_titleButton setTitle:title forState:UIControlStateNormal];
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

@end
