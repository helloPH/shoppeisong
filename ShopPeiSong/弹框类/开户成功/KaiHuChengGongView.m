//
//  KaiHuChengGongView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/7/14.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "KaiHuChengGongView.h"
#import "UIViewExt.h"

@interface KaiHuChengGongView()
@property (nonatomic,strong)UIView * backView;
@end

@implementation KaiHuChengGongView
-(instancetype)init{
    if (self=[super init]) {
        [self newView];
    }
    return self;
}
-(void)newView{

    
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    self.frame=CGRectMake(_backView.width*0.11, _backView.height*0.67, _backView.width*0.78, _backView.height*0.1);
//    self.backgroundColor=[UIColor redColor];
    
}
-(void)appear{
    
    
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    _backView.alpha=0;
//    _backView.backgroundColor=[UIColor redColor];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _backView.width, _backView.height)];
    [_backView addSubview:imgView];
    imgView.image= [UIImage imageNamed:@"kaifuchenggong"];
    imgView.userInteractionEnabled=YES;
    
    [_backView addSubview:self];
    
    
 

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [self addGestureRecognizer:tap];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0.95;
    }];
}
-(void)disAppear{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        if (_block) {
            _block();
        }
    }];
}

@end
