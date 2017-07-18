//
//  ShuomingView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/30.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "ShuomingView.h"
#import "SureSongdaView.h"
#import "Header.h"

@interface ShuomingView() <MBProgressHUDDelegate>
@property(nonatomic,strong)UITextView *shuomingTextView;//

@end
@implementation ShuomingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}

-(UITextView *)shuomingTextView
{
    if (!_shuomingTextView) {
        _shuomingTextView = [[UITextView alloc]initWithFrame:CGRectZero];
        _shuomingTextView.textColor = textColors;
        _shuomingTextView.font = [UIFont systemFontOfSize:MLwordFont_4];
        _shuomingTextView.textAlignment = 1;
        _shuomingTextView.editable = YES;
        _shuomingTextView.backgroundColor = [UIColor clearColor];
        [self addSubview:_shuomingTextView];
    }
    return _shuomingTextView;
}

-(void)reloadDataWithZhangdanId:(NSString *)zhangdanID
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"zhangdanid":zhangdanID}];
    [HTTPTool getWithUrl:@"shuoming.action" params:pram success:^(id json){
        NSLog(@"账单说明%@",json);
        [mHud hide:YES];
        if ([[json valueForKey:@"message"]integerValue] == 0) {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if ([[json valueForKey:@"message"]integerValue] == 2)
        {
            [self promptMessageWithString:@"无此账单"];
        }
        else
        {
            self.shuomingTextView.text =[NSString stringWithFormat:@"%@",[json valueForKey:@"shuoming"]];
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize addressSize = [self.shuomingTextView.text boundingRectWithSize:CGSizeMake(self.width-30*MCscale, self.height - 30*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_4],NSFontAttributeName, nil] context:nil].size;
    self.shuomingTextView.frame = CGRectMake(0,0, addressSize.width+30*MCscale, addressSize.height+20*MCscale);
    self.shuomingTextView.center = CGPointMake(self.width/2.0, self.height/2.0);
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
    sleep(1);
}
@end



