//
//  QianDaoView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/26.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "QianDaoView.h"
#import "Header.h"

@interface QianDaoView()<MBProgressHUDDelegate>
@property(nonatomic,strong)UIButton * backView;

@property(nonatomic,strong)UILabel *titleLabel2;//提示信息
@property(nonatomic,strong)UIView *lineView,*lineView2;//
@property(nonatomic,strong)UIButton *cancalBtn,*sureBtn;
@end
@implementation QianDaoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self newView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}
-(void)newView{
    _backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.frame=CGRectMake(30*MCscale,230*MCscale, kDeviceWidth - 60*MCscale, 110*MCscale);
    [_backView addSubview:self];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}
-(UILabel *)titleLabel2
{
    if (!_titleLabel2) {
        _titleLabel2 = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textBlackColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:2 text:@""];
        [self addSubview:_titleLabel2];
    }
    return _titleLabel2;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}
-(UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_lineView2];
    }
    return _lineView2;
}
-(UIButton *)cancalBtn
{
    if (!_cancalBtn) {
        _cancalBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textBlackColor backGroundColor:[UIColor clearColor] cornerRadius:0 text:@"取消" image:@""];
        [_cancalBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancalBtn];
        
        
    }
    return _cancalBtn;
}
-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:[UIColor redColor] backGroundColor:[UIColor clearColor] cornerRadius:0 text:@"确定" image:@""];
        [_sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
    }
    return _sureBtn;
}
-(void)setStatus:(NSString *)status{
    _status=status;
    switch ([_status integerValue]) {
        case 0:
            self.titleLabel2.text=@"第一时段 签到";
            break;
        case 1:
            self.titleLabel2.text=@"第一时段 离岗";
            break;
        case 2:
            self.titleLabel2.text=@"第二时段 签到";
            break;
        case 3:
            self.titleLabel2.text=@"第二时段 离岗";
            break;
        case 4:
            self.titleLabel2.text=@"第三时段 签到";
            break;
        case 5:
            self.titleLabel2.text=@"第三时段 离岗";
            break;
        case 6:
            self.titleLabel2.text=@"第四时段 签到";
            break;
        case 7:
            self.titleLabel2.text=@"第四时段 离岗";
            break;
        case 8:
            self.titleLabel2.text=@"你已完成今天的任务";
            break;
            
        default:
            break;
    }
    
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.center=CGPointMake(kDeviceWidth/2, kDeviceHeight/2);
    
    self.titleLabel2.frame = CGRectMake(20*MCscale,25*MCscale, self.width-40*MCscale,25*MCscale);
    self.lineView.frame = CGRectMake(10*MCscale, self.titleLabel2.bottom +5*MCscale, self.width - 20*MCscale, 1);
    
    self.cancalBtn.frame = CGRectMake(0*MCscale, self.lineView.bottom+10*MCscale, self.width/2, 30*MCscale);
    self.sureBtn.frame = CGRectMake(self.width/2, self.lineView.bottom+10*MCscale, self.width/2, 30*MCscale);
    self.lineView2.frame = CGRectMake(self.cancalBtn.right, self.cancalBtn.top, 1, self.cancalBtn.height);
}

-(void)reshData{
//    HTTPTool getWithUrl:<#(NSString *)#> params:<#(NSMutableDictionary *)#> success:<#^(id json)success#> failure:<#^(NSError *error)failure#>
    
    
}
-(void)buttonClick:(UIButton *)button
{
    if (button == self.cancalBtn) {
        if (_block) {
          _block(0);
        }
    }
    else
    {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        mbHud.mode = MBProgressHUDModeIndeterminate;
        mbHud.delegate = self;
        mbHud.labelText = @"请稍等...";
        [mbHud show:YES];
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangongid":user_id,
                                                                                    @"status":[NSString stringWithFormat:@"%ld",(long)[self.status integerValue]+1]}];
        [HTTPTool getWithUrl:@"yuangongClock.action" params:pram success:^(id json) {
            [mbHud hide:YES];
            NSLog(@"json %@",json);
            if (_block) {
                 _block(1);
            }
            
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
}

-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1.5);
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
