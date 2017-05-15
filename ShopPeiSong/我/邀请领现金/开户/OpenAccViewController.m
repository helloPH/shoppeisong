//
//  OpenAccViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/8.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//
#import "PHTabbar.h"
#import "OpenAccViewController.h"
#import "Header.h"

#import "FreeOpenView.h"
#import "ZengQiangOpenView.h"
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface OpenAccViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * mainScrollView;

@property (nonatomic,strong)PHTabbar * titleView;
@property (nonatomic,strong)FreeOpenView * freeOpenView;
@property (nonatomic,strong)ZengQiangOpenView * zengOpneView;

@property (nonatomic,assign)BOOL isFree;

@property (nonatomic,strong)UIButton * rightBackBtn;

@end

@implementation OpenAccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    [self initNavi];
    [self newView];


    
    // Do any additional setup after loading the view.
}
-(void)initNavi{
    self.navigationItem.title=@"开户";
    

    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftButton setImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    leftButton.tag = 1003;
    [leftButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}
-(void)initData{
    _isFree=YES;
}
-(void)newView{
    self.view.backgroundColor=[UIColor whiteColor];

    _titleView = [PHTabbar insWithTitles:@[@"标准版",@"升级版"] type:0 themeColor:mainColor frame:CGRectMake(0, 69, kDeviceWidth, 40*MCscale)];
    [self.view addSubview:_titleView];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    __block OpenAccViewController * weakSelf = self;
    _titleView.block=^(NSInteger index){
        _isFree=index==0?YES:NO;
        [weakSelf reshView];
    };
    
    
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _titleView.bottom, kDeviceWidth, kDeviceHeight-_titleView.bottom)];
    _mainScrollView.contentSize=CGSizeMake(_mainScrollView.width*2, _mainScrollView.height);
    _mainScrollView.pagingEnabled=YES;
    [self.view addSubview:_mainScrollView];
    _mainScrollView.delegate=self;
    
    _freeOpenView= [[FreeOpenView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, _mainScrollView.height)];
    _freeOpenView.controller=self;
    [_mainScrollView addSubview:_freeOpenView];
    
    _zengOpneView = [[ZengQiangOpenView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0, kDeviceWidth, _mainScrollView.height)];
    _zengOpneView.controller=self;
    [_mainScrollView addSubview:_zengOpneView];

}
-(void)reshView{
    [UIView animateWithDuration:0.3 animations:^{
        _mainScrollView.contentOffset=CGPointMake(_isFree?0:kDeviceWidth, 0);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  scroll 的代理方法
 *
 *  @param scrollView 的代理方法
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_titleView setIndex:scrollView.contentOffset.x/kDeviceWidth];
}

#pragma mark  -- 按钮事件
-(void)pop{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
