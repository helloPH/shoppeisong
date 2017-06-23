//
//  UseDirectionViewController.m
//  LifeForMM
//
//  Created by HUI on 15/8/4.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "UseDirectionViewController.h"
#import "Header.h"
@interface UseDirectionViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIWebView *mainWebView;

@end

@implementation UseDirectionViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    [self initNavigation];
    NSURL *url =[NSURL URLWithString:_pageUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton =[BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
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
-(void)initNavigation
{
    self.navigationItem.title = _titStr;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}

-(void)btnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
