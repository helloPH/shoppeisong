//
//  NumberPassWordView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/24.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "NumberPassWordView.h"
#import "Header.h"

@interface NumberPassWordView()
@property (nonatomic,assign)NSInteger rank; // 密码的位数

@property (nonatomic,strong)UIButton * backView;
@property (nonatomic,strong)NSMutableArray<NSString *> * passArray;
@end
@implementation NumberPassWordView
-(instancetype)init{
    if (self=[super init]) {
        _rank=6;
        _passArray = [NSMutableArray array];
        [self newView];
    }
    return self;
}
-(void)newView{
    _backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, 100);
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
//    self.clipsToBounds=YES;
    [_backView addSubview:self];
    
    
    CGFloat setY = 0;
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, setY, self.width, 30*MCscale)];
    title.text=@"请输入支付密码";
    title.font=[UIFont systemFontOfSize:MLwordFont_4];
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=textBlackColor;
    [self addSubview:title];
    setY = title.bottom+10*MCscale;
    
    
    
    CGFloat pasBtnW = self.width/_rank;
    CGFloat pasBtnH = pasBtnW;
    CGFloat pasBtnY = setY;
    
    for (int i = 0; i < _rank; i ++) {
        
        
        CGFloat pasBtnX = i * pasBtnW;
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(pasBtnX, pasBtnY, pasBtnW, pasBtnH)];
        [btn setTitleColor:textBlackColor forState:UIControlStateNormal];
        btn.tag=100+i;
        [self addSubview:btn];
        
        UIImageView * miwenView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20*MCscale, 20*MCscale)];
        [btn addSubview:miwenView];
        miwenView.tag=44;
        miwenView.center=CGPointMake(btn.width/2, btn.height/2);
        miwenView.hidden=YES;
        miwenView.layer.cornerRadius=miwenView.width/2;
        miwenView.backgroundColor=[UIColor redColor];
        
        UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, btn.width, 1)];
        topLine.backgroundColor=lineColor;
        [btn addSubview:topLine];
        if (i != 0) {
            UIView * leftLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, btn.height)];
            leftLine.backgroundColor=lineColor;
            [btn addSubview:leftLine];
        }
        setY = btn.bottom;
    }
    
    NSArray * keys = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@""];
    
    
    CGFloat keyBW = self.width/3;
    CGFloat keyBH = keyBW*0.7;
   
    
    for (int i = 0; i < keys.count; i ++) {
        CGFloat keyBX = i % 3 * keyBW;
        CGFloat keyBY = i / 3 * keyBH + setY;
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(keyBX, keyBY, keyBW, keyBH)];
        
        btn.tag=1000+i;
        [btn setTitle:keys[i] forState:UIControlStateNormal];
        [btn setTitleColor:textBlackColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(keyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        
        UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, btn.width, 1)];
        topLine.backgroundColor=lineColor;
        [btn addSubview:topLine];
        if (i != 0) {
            UIView * leftLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, btn.height)];
            leftLine.backgroundColor=lineColor;
            [btn addSubview:leftLine];
        }
        if (i == keys.count-1) {
            [btn setImage:[UIImage imageNamed:@"删除png"] forState:UIControlStateNormal];
            
        }
        
        if (i == keys.count-1) {
            setY =btn.bottom;
        }
        
    }
    self.height=setY;
    self.center=CGPointMake(_backView.width/2, _backView.height/2);
}
-(void)keyBtnClick:(UIButton *)sender{
    if (_passArray.count<_rank && sender.tag!=1009 && sender.tag!=1011) {
        NSInteger passInter = sender.tag-1000+1;
        if (passInter==10) {
            passInter = 0;
        }
        NSString * pass = [NSString stringWithFormat:@"%ld",(long)passInter];
        
        [_passArray addObject:pass];
        [self reshPassView];
    }
    if (_passArray.count>0 && sender.tag==1011) {
          [_passArray removeLastObject];
        [self reshPassView];
    }
    if (_passArray.count == _rank) {
        if (_block) {
            NSString * password = [_passArray componentsJoinedByString:@""];
            _block(password);
        }
    }
}

-(void)reshPassView{
    for (int i =0 ; i < _rank ; i ++) {
        UIButton * btn = [self viewWithTag:i+100];
        [btn setTitle:@"" forState:UIControlStateNormal];
        UIImageView * miwen =[btn viewWithTag:44];
        miwen.hidden=YES;
      
        if (i < _passArray.count) {
           
            [btn setTitle:_passArray[i] forState:UIControlStateNormal];
            if (i != _passArray.count-1) {
              [btn bringSubviewToFront:miwen];
            }else{
                [btn bringSubviewToFront:btn.titleLabel];
            }
     
            miwen.hidden=NO;
        }
    }
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
