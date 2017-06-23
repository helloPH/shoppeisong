//
//  ReplyEvaluateView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/23.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "ReplyEvaluateView.h"
#import "Header.h"

@interface ReplyEvaluateView()<UITextViewDelegate>

@property (nonatomic,strong)UIScrollView * backView;


@property (nonatomic,strong)UITextView * textView;

@property (nonatomic,strong)UIButton   * submitBtn;

@end
@implementation ReplyEvaluateView
-(instancetype)init{
    if (self = [super init]) {
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, 10);
        
        [self newView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
  
        
    }
    return self;
}
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
    
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, self.width-40, 30)];
    _textView.font=[UIFont systemFontOfSize:MLwordFont_4];
    _textView.textColor=textBlackColor;
    _textView.backgroundColor=lineColor;
    [self addSubview:_textView];
    _textView.delegate=self;
    
    
    
    _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _textView.bottom+15, 100, 30)];
    _submitBtn.centerX=self.width/2;
    _submitBtn.backgroundColor = txtColors(249, 54, 73, 1);
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 5.0;
    [_submitBtn setTitle:@"回复" forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitBtn];
    
    
    
    self.height=_submitBtn.bottom+15;
    self.centerY=[UIScreen mainScreen].bounds.size.height/2;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString * newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (newString.length>20) {
//        [MBProgressHUD promptWithString:@"最多输入20字"];
        [MBProgressHUD promptWithString:@"最多输入20字"];
        return NO;
    }
    
    
   CGSize size=  [newString boundingRectWithSize:CGSizeMake(self.width-50,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_4],NSFontAttributeName, nil] context:nil].size;
    if (size.height<30) {
        textView.height=30;
    }else{
        textView.height=size.height+10;
    }
    
    _submitBtn.top=textView.bottom+15;
    self.height =_submitBtn.bottom+15;
    
    self.centerY=[UIScreen mainScreen].bounds.size.height/2;
    return YES;
}
-(void)submitBtnClick:(UIButton *)sender{
    if ([_textView.text isEmptyString]) {
        [MBProgressHUD promptWithString:@"请输入回复内容"];
        return;
    }
    if (_block) {
        _block(_textView.text);
    }
    
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

@end
