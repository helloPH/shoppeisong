//
//  helpCenterViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/22.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "helpCenterViewController.h"
#import "Header.h"
#import "OnlineServiceViewController.h"
#import "feedbackViewController.h"
#import "UseDirectionViewController.h"
@interface helpCenterViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIWebView *mainWebView;
@property(nonatomic,strong)UIButton *leftButton,*rightButton,*bottomButton;
@end

@implementation helpCenterViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self initWebView];
    [self.view addSubview:self.bottomButton];
}
-(UIWebView *)mainWebView
{
    if (!_mainWebView) {
        _mainWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _mainWebView.backgroundColor = [UIColor whiteColor];
        _mainWebView.scalesPageToFit = YES;//自动放缩适应屏幕
        _mainWebView.opaque = NO;
        [self.view addSubview:_mainWebView];
    }
    return _mainWebView;
}

-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton =[BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"wdkf_shuomingshu"];
        [_rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(UIButton *)bottomButton
{
    if (!_bottomButton) {
        _bottomButton = [BaseCostomer buttonWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49) font:[UIFont systemFontOfSize:MLwordFont_15] textColor:[UIColor whiteColor] backGroundColor:txtColors(4, 196, 153, 1) cornerRadius:0 text:@"在线客服" image:@""];
        _bottomButton.alpha = 0.95;
        [_bottomButton addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}
#pragma mark 设置导航栏
-(void)initNavigation
{
    [self.navigationItem setTitle:@"我的客服"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
    
    UIBarButtonItem *rightbarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem =rightbarBtn;
}
-(void)initWebView
{
    NSString *helpStr =[NSString stringWithFormat:@"%@MshcShopYewu/yewuwenti.jsp",HTTPWeb];
    NSURL *url =[NSURL URLWithString:helpStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}
-(void)btnAction:(UIButton *)btn
{
    if (btn == self.leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UseDirectionViewController *peiSongShuomingVC = [[UseDirectionViewController alloc]init];
        peiSongShuomingVC.hidesBottomBarWhenPushed = YES;
        peiSongShuomingVC.pageUrl =[NSString stringWithFormat:@"%@shuoming/peisongshuoming.htm",HTTPImage];
        peiSongShuomingVC.titStr= @"妙店佳配送端说明文档";
        [self.navigationController pushViewController:peiSongShuomingVC animated:YES];
    }
}
-(void)bottomBtnClick
{
    OnlineServiceViewController *vc = [[OnlineServiceViewController alloc]init];
    vc.isOrder = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
