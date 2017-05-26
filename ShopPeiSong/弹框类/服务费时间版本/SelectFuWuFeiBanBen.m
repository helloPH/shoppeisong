//
//  SelectFuWuFeiBanBen.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/23.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "SelectFuWuFeiBanBen.h"
#import "Header.h"

@interface SelectFuWuFeiBanBen()
@property (nonatomic,strong)UIButton * backView;

@property (nonatomic,strong)UIView * mainView;


@end
@implementation SelectFuWuFeiBanBen
-(instancetype)init{
    if (self=[super init]) {
        [self newView]; 
    }
    return self;
}
-(void)newView{
    _backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, 100);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    [_backView addSubview:self];
    
   }
-(void)btnClick:(UIButton *)sender{
    if (_block) {
        _block(_datas[sender.tag-100]);
    }
    [self disAppear];
}

-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    _backView.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0.95;
    }];
    
    
    
    
    CGFloat setY = 20*MCscale;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, setY, self.width, 20*MCscale)];
    titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    titleLabel.textColor=textBlackColor;
    titleLabel.text=@"请选择续费时间";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    setY =titleLabel.bottom+20*MCscale;
    
    
    CGFloat bX = 0;
    CGFloat bW = self.width;
    CGFloat bH = 40*MCscale;
    for (int i = 0 ; i < _datas.count; i ++) {
        
        NSDictionary * dic = _datas[i];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(bX, setY, bW, bH)];
        [self addSubview:btn];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*MCscale, 0, 100, 20)];
        [leftBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
        leftBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
        [leftBtn setTitle:[NSString stringWithFormat:@"%@个月",dic[@"month"]] forState:UIControlStateNormal];
        leftBtn.userInteractionEnabled=NO;
        [btn addSubview:leftBtn];
        leftBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
        leftBtn.centerY=btn.height/2;
        
        
        
        
        UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        rightLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
        rightLabel.textColor=textBlackColor;
        rightLabel.textAlignment=NSTextAlignmentRight;
        [btn addSubview:rightLabel];
        rightLabel.text=[NSString stringWithFormat:@"%@元",dic[@"price"]];
        rightLabel.centerY=btn.height/2;
        rightLabel.right=btn.width-20*MCscale;
        
        
        
        
        
        
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale, 0, btn.width-40*MCscale, 1)];
        line.backgroundColor=lineColor;
        [btn addSubview:line];
        
        
        setY=btn.bottom;
    }
    self.height=setY+10*MCscale;
    
    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);

    
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
