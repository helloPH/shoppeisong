//
//  MoNiSystemAlert.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/28.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "MoNiSystemAlert.h"
#import "Header.h"

@interface MoNiSystemAlert()
@property (nonatomic,assign)CGFloat offsetY;

@property (nonatomic,strong)UIView * moniSelf;

//@property (nonatomic,strong)UIScrollView * backView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * contentLabel;

@end
@implementation MoNiSystemAlert
-(instancetype)init{
    if (self=[super  init]) {
        [self newView];
    }
    return self;
}
-(void)newView{

    self.frame=CGRectMake(5*MCscale, 20*MCscale,[UIScreen mainScreen].bounds.size.width-10*MCscale , 20);
    self.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 1;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(alertSpan:)];
    [self addGestureRecognizer:pan];

    _moniSelf = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:_moniSelf];
    _moniSelf.layer.cornerRadius = 15.0;
    _moniSelf.clipsToBounds = YES;
    
    
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 30*MCscale)];
    topView.backgroundColor=[UIColor whiteColor];
    topView.alpha=1;
    [_moniSelf addSubview:topView];

    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(10*MCscale, 5*MCscale, topView.height-10*MCscale, topView.height-10*MCscale)];
    icon.image=[UIImage imageNamed:@"icon11"];
    [topView addSubview:icon];
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(icon.right + 5*MCscale, 5*MCscale, 100, icon.height)];
    name.textColor=textBlackColor;
    name.font=[UIFont systemFontOfSize:MLwordFont_6];
    [topView addSubview:name];
    name.text=@"妙店佳商铺";
    
    UILabel * time = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 5*MCscale, 100, icon.height)];
    time.right=topView.width-10*MCscale;
    time.textColor=textBlackColor;
    time.font=[UIFont systemFontOfSize:MLwordFont_6];
    [topView addSubview:time];
    time.textAlignment=NSTextAlignmentRight;
    time.text=@"刚刚";
    
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(10*MCscale, topView.bottom+5*MCscale, self.width-20*MCscale, 20*MCscale)];
    [_moniSelf addSubview:title];
    title.textColor=[UIColor blackColor];
    title.font=[UIFont systemFontOfSize:MLwordFont_5];
    _titleLabel = title;
    
    
    UILabel * content = [[UILabel alloc]initWithFrame:CGRectMake(10*MCscale, title.bottom+5*MCscale, self.width-20*MCscale, 0.01*MCscale)];
    [_moniSelf addSubview:content];
    content.textColor=textBlackColor;
    content.font=[UIFont systemFontOfSize:MLwordFont_6];
    content.numberOfLines = 0;
    _contentLabel = content;
    
    self.height = title.bottom+10*MCscale;
    _moniSelf.height =self.height;
    
    
    [UIView animateWithDuration:4 animations:^{
        topView.alpha=0.9;
    }completion:^(BOOL finished) {
        [self disAppear];
    }];
    
}
-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = [NSString stringWithFormat:@"%@",_title];
    
}
-(void)setContent:(NSString *)content{
    _content = content;
    _contentLabel.text = [NSString stringWithFormat:@"%@",_content];
    [_contentLabel sizeToFit];
    
    self.height = _contentLabel.bottom+5*MCscale;
    _moniSelf.height = self.height;
}
-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    self.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0.95;
    }];
}
-(void)disAppear{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)alertSpan:(UIPanGestureRecognizer *)pan{
    CGFloat y =  [pan locationInView:pan.view.superview].y;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _offsetY = y - pan.view.top;/// 确定
            break;
        case UIGestureRecognizerStateChanged:
            pan.view.top = y - _offsetY;
            break;
        case UIGestureRecognizerStateEnded:
            if (pan.view.top<0) {
                [self disAppear];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    pan.view.top = 20 *MCscale;
                }];
            }
            break;
        default:
            break;
    }
}
@end
