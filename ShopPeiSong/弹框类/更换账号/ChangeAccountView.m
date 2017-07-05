//
//  ChangeAccountView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/27.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "ChangeAccountView.h"
#import "Header.h"
@interface ChangeAccountView()
@property (nonatomic,strong)UIScrollView * backView;

@end
@implementation ChangeAccountView
-(instancetype)init{
    if (self=[super  init]) {
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, 10);
        [self newView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)newView{
 
 
    
    _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [_backView addGestureRecognizer:tap];
    
    
    
    //    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, [UIScreen mainScreen].bounds.size.width*0.6);
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    //    self.clipsToBounds=YES;
    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [_backView addSubview:self];

    
    NSMutableArray * accounts =   local_Accounts;
    
    CGFloat setY = 20;
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, setY, self.width, 30)];
    title.text=@"选择以下账号";
    title.textColor=textBlackColor;
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont systemFontOfSize:MLwordFont_3];
    [self addSubview:title];
    setY = title.bottom;
    

    UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(0, setY, self.width, 1)];
    line.backgroundColor=lineColor;
    [self addSubview:line];
    setY = line.bottom;
    
    for (int i = 0;  i < accounts.count; i ++) {
        NSString * account = [NSString stringWithFormat:@"%@",accounts[i]];
        CellView * cell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.width, 40)];
        [self addSubview:cell];
        cell.contentLabel.left = 0;
        cell.contentLabel.width=cell.width;
        cell.contentLabel.textAlignment=NSTextAlignmentCenter;
        cell.contentLabel.textColor=textBlackColor;
        
        cell.contentLabel.text = account;
        setY = cell.bottom;
        
        cell.tag=100+i;
        [cell addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.height = setY+20;
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

#pragma mark -- btnClick
-(void)btnClick:(UIButton *)sender{
    NSMutableArray * accounts = local_Accounts;

    if (_block) {
        _block(accounts[sender.tag-100]);
    }

}

@end
