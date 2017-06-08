//
//  FenXiangWithLoginAfter.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/21.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "FenXiangWithLoginAfter.h"
#import "Header.h"
#import <ShareSDK/ShareSDK.h>


@interface FenXiangWithLoginAfter()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton * backView;
@property (nonatomic,strong)UILabel * textField;

@property (nonatomic,strong)NSDictionary * dataDic;
@end

@implementation FenXiangWithLoginAfter
-(instancetype)init{
    if (self=[super init]) {
        _dataDic = [NSDictionary dictionary];
        [self newView];
      
    }
    return self;
}
-(void)reshData{
    [Request getKaihuLiLianContentSuccess:^(id json) {
        NSString * messge = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([messge isEqualToString:@"1"]) {
            _dataDic = (NSDictionary *)json;
            

        }
    } failure:^(NSError *error) {
        
    }];
    
    
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
    
    UILabel  * textField = [[UILabel alloc]initWithFrame:CGRectMake(10*MCscale, setY, self.width-20*MCscale, 0)];
    textField.numberOfLines=0;
    [self addSubview:textField];
    textField.font=[UIFont systemFontOfSize:MLwordFont_4];
    textField.textAlignment=NSTextAlignmentCenter;
    textField.textColor=textBlackColor;
    textField.text=loginShareContent;
   
    [textField sizeToFit];
    textField.centerX=self.width/2;
    _textField = textField;
    
    
    

    
    setY = textField.bottom;
    
    for (int i = 0; i <2; i ++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, textField.bottom+20*MCscale, self.width/2, 40*MCscale)];
        [self addSubview:btn];
        [btn setTitleColor:textBlackColor forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        setY = btn.bottom;
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, btn.width, 1)];
        line.backgroundColor=lineColor;
        [btn addSubview:line];
        
        
        if (i == 0) {
            [btn setTitle:@"稍后再说" forState:UIControlStateNormal];
            btn.centerX=self.width*0.25;
        }else{
            [btn setTitle:@"马上分享" forState:UIControlStateNormal];
            btn.centerX=self.width*0.75;
            
            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, btn.height)];
            line1.backgroundColor=lineColor;
            [btn addSubview:line1];
            
        }

    }
    
    self.height=setY+0*MCscale;
}
-(void)btnClick:(UIButton *)sender{
    if (sender.tag==100) {
        [self disAppear];
    }else{
        // 微信分享
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
      
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@",_dataDic[@"content"]]
                                         images:[NSString stringWithFormat:@"%@",_dataDic[@"image"]] //传入要分享的图片
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDic[@"url"]]]
                                          title:[NSString stringWithFormat:@"%@",_dataDic[@"content"]]
                                           type:SSDKContentTypeAuto];
        
        [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (state != SSDKResponseStateSuccess) {
                [MBProgressHUD promptWithString:@"分享失败"];
                return ;
            }
            [Request successFenxiangKaihuLiLianContentSuccess:^(id json) {
                [self disAppear];
                 set_LoginShareContent(@"");
            } failure:^(NSError *error) {
            }];
        }];
    }
}
-(void)appear{
    self.centerX=[UIScreen mainScreen].bounds.size.width/2;
    self.centerY=[UIScreen mainScreen].bounds.size.height/2;
    
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0.95;
    } completion:^(BOOL finished) {
          [self reshData];
    }];
}

-(void)disAppear{
    __weak FenXiangWithLoginAfter * weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [weakSelf removeFromSuperview];
        if (_block) {
            _block();
        }
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
