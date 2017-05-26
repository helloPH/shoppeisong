//
//  OrdersViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/6.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrdersCell.h"
#import "OrderDetailViewController.h"
#import "OrdersModel.h"
#import "ShuohuoMoneyView.h"
#import "SureSongdaView.h"
#import "Header.h"

@interface OrdersViewController ()<MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource,OrdersCellDelegate,ShuohuoMoneyViewDelegate,SureSongdaViewDelegate>

@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *ordersArray;
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)ShuohuoMoneyView *shouhuoView;
@property(nonatomic,strong)SureSongdaView *songdaView;
@property(nonatomic,assign)BOOL isRefresh;



@end

@implementation OrdersViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self getOrdersData];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setTitle:@"已接订单"];
    [self refresh];
}
-(BOOL)isRefresh
{
    if (!_isRefresh) {
        _isRefresh = 0;
    }
    return _isRefresh;
}
-(NSMutableArray *)ordersArray
{
    if (!_ordersArray) {
        _ordersArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _ordersArray;
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_mainTableView];
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 49, 0));
        }];
    }
    return _mainTableView;
}
-(UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

-(ShuohuoMoneyView *)shouhuoView
{
    if (!_shouhuoView) {
        _shouhuoView = [[ShuohuoMoneyView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth-60*MCscale, 180*MCscale)];
        _shouhuoView.shouhuoDelegate = self;
    }
    return _shouhuoView;
}
-(SureSongdaView *)songdaView
{
    if (!_songdaView) {
        _songdaView = [[SureSongdaView alloc]initWithFrame:CGRectMake(50*MCscale,230*MCscale, kDeviceWidth-100*MCscale,150*MCscale)];
        _songdaView.songdaDelegate = self;
    }
    return _songdaView;
}

#pragma mark 获取已接订单信息
-(void)getOrdersData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id}];
    [HTTPTool getWithUrl:@"getDingdan.action" params:pram success:^(id json) {
        [mHud hide:YES];
        NSLog(@"已接订单 %@",json);
        if (self.isRefresh) {
            [self endRefresh];
        }
        [self.ordersArray removeAllObjects];
        
        if ([[json valueForKey:@"message"]integerValue]== 0) {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if ([[json valueForKey:@"message"] integerValue] == 1)
        {
            self.mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"订单无内容"]];
        }
        else
        {
            self.mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
            NSArray *diandanList = [json valueForKey:@"orders"];
            for (NSDictionary *dic in diandanList) {
                OrdersModel *model = [[OrdersModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ordersArray addObject:model];
            }
        }
        [self.mainTableView reloadData];
        
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ordersArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    OrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OrdersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.orderDelegate = self;
    [cell reloadDataWithIndexpath:indexPath AndArray:self.ordersArray];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrdersModel *model = self.ordersArray[indexPath.row];
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc]init];
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    orderDetailVC.viewTag = 1;
    orderDetailVC.danhao = model.danhao;
    orderDetailVC.model = model;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180*MCscale;
}

#pragma mark 收货与确认收货
-(void)shouhuoSuccessWithDanhao:(NSString *)danhao AndCaigouchengbenStr:(NSString *)caigouchengben AndZhidufangshiIndex:(NSInteger)zhifufangshi Index:(NSInteger)index
{
    if (index == 4) {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self.view addSubview:self.maskView];
            self.shouhuoView.alpha = 0.95;
            self.shouhuoView.danhao = danhao;
            self.shouhuoView.caigouchengben = caigouchengben;
            [self.view addSubview:self.shouhuoView];
        }];
    }
    else
    {
        if (zhifufangshi != 1) {
            [self querensongdaWithDanhao:danhao];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.maskView.alpha = 1;
                [self.view addSubview:self.maskView];
                self.songdaView.danhao = danhao;
                self.songdaView.alpha = 0.95;
                [self.view addSubview:self.songdaView];
            }];
        }
    }
}

#pragma mark 收货成功
-(void)shouhuoSuccess
{
    [self maskViewDisMiss];
    [self getOrdersData];
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = @"收货成功";
    mHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    mHud.mode = MBProgressHUDModeCustomView;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

#pragma mark 收货成功
-(void)sureSongdaSuccessWithDanhao:(NSString *)danhao
{
    [self querensongdaWithDanhao:danhao];
    [self maskViewDisMiss];
}

-(void)querensongdaWithDanhao:(NSString *)danhao
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id,@"danhao":danhao}];
    [HTTPTool getWithUrl:@"songda.action" params:pram success:^(id json) {
        [mHud hide:YES];
        NSLog(@"已接订单 %@",json);
        
        if ([[json valueForKey:@"message"]integerValue]== 0) {
            [self promptMessageWithString:@"确认送达失败"];
        }
        else
        {
            MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mHud.labelText = @"确认送达成功";
            mHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            mHud.mode = MBProgressHUDModeCustomView;
            [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            [self getOrdersData];
            
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.maskView removeFromSuperview];
        [self.view endEditing:YES];
        self.shouhuoView.alpha = 0;
        [self.shouhuoView removeFromSuperview];
        self.songdaView.alpha = 0;
        [self.songdaView removeFromSuperview];
    }];
}
-(void)refresh
{
    //下拉刷新
    [self.mainTableView addHeaderWithTarget:self action:@selector(headReFreshing)];
    self.mainTableView.headerPullToRefreshText = @"下拉刷新数据";
    self.mainTableView.headerReleaseToRefreshText = @"松开刷新";
    self.mainTableView.headerRefreshingText = @"拼命加载中";
}
-(void)headReFreshing
{
    self.isRefresh = 1;
    [self getOrdersData];
}

-(void)endRefresh
{
    [self.mainTableView headerEndRefreshing];
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
