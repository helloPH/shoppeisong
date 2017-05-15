
//
//  PalmformDetailViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/24.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "PalmformDetailViewController.h"
#import "OrderDetailCellOne.h"
#import "OrderDetailCellTwo.h"
#import "OrderDetailShangpinModel.h"
#import "Header.h"

@interface PalmformDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)NSMutableArray *shangpinListArray,*zhifushangshiArray,*shuliangArray;
@property(nonatomic,strong)NSArray *dataArray;
@end
@implementation PalmformDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mainTableView];
    [self setNavigationItem];
    [self getOrderDetailData];
}
#pragma mark 设置导航栏
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

-(void)setNavigationItem
{
    [self.navigationItem setTitle:@"抢单详情"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kDeviceWidth, kDeviceHeight - 64) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _mainTableView;
}
-(NSMutableArray *)shangpinListArray
{
    if (!_shangpinListArray) {
        _shangpinListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _shangpinListArray;
}
-(NSMutableArray *)zhifushangshiArray
{
    if (!_zhifushangshiArray) {
        _zhifushangshiArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _zhifushangshiArray;
}
-(NSMutableArray *)shuliangArray
{
    if (!_shuliangArray) {
        _shuliangArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _shuliangArray;
}

#pragma mark 获取订单详情
-(void)getOrderDetailData
{
    [Request getOrderInfoWithDic:@{@"danhao":self.danhao} success:^(id json) {
        if ([[json valueForKey:@"message"]integerValue]== 0) {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if ([[json valueForKey:@"message"] integerValue] == 1)
        {
            [self promptMessageWithString:@"加载失败"];
        }
        else
        {
            NSDictionary *dict = [json valueForKey:@"dingdanxq"];
            
            NSArray *shangpinList = dict[@"shoplist"];
            for (NSDictionary *dic in shangpinList) {
                OrderDetailShangpinModel *model = [[OrderDetailShangpinModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.shangpinListArray addObject:model];
            }
            
            NSDictionary *dict1 = @{@"key":@"预约送达时间:",@"value":dict[@"yuyuesongda"]};
            [self.zhifushangshiArray addObject:dict1];
            if ([dict[@"fapiao"] integerValue] != 0) {
                NSDictionary *dict2 = @{@"key":@"发票:",@"value":dict[@"fapiao"]};
                [self.zhifushangshiArray addObject:dict2];
            }
            NSDictionary *dict3 = @{@"key":@"下单时间:",@"value":dict[@"cretdate"]};
            NSDictionary *dict4 = @{@"key":@"单号:",@"value":dict[@"dingdanhao"]};
            [self.zhifushangshiArray addObject:dict3];
            [self.zhifushangshiArray addObject:dict4];
            
            if ([dict[@"shuliang"] integerValue] != 0) {
                NSDictionary *dict11 = @{@"key":@"数量:",@"value":[NSString stringWithFormat:@"%@",dict[@"shuliang"]]};
                [self.shuliangArray addObject:dict11];
            }
            if ([dict[@"dindanbeizhu"] integerValue] != 0) {
                NSDictionary *dict11 = @{@"key":@"备注:",@"value":[NSString stringWithFormat:@"%@",dict[@"dindanbeizhu"]]};
                [self.shuliangArray addObject:dict11];
            }
            
            self.dataArray = [NSArray arrayWithObjects:self.zhifushangshiArray,self.shangpinListArray,self.shuliangArray,nil];
        }
        [self.mainTableView reloadData];

    } failure:^(NSError *error) {
        
    }];
    
    
    
    
//    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    mHud.mode = MBProgressHUDModeIndeterminate;
//    mHud.delegate = self;
//    mHud.labelText = @"请稍等...";
//    [mHud show:YES];
//    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"danhao":self.danhao}];
    
//    [HTTPTool getWithUrl:@"dingdanInfo.action" params:pram success:^(id json) {
//        [mHud hide:YES];
//        NSLog(@"抢单详情 %@",json);
//        if ([[json valueForKey:@"message"]integerValue]== 0) {
//            [self promptMessageWithString:@"参数不能为空"];
//        }
//        else if ([[json valueForKey:@"message"] integerValue] == 1)
//        {
//            [self promptMessageWithString:@"加载失败"];
//        }
//        else
//        {
//            NSDictionary *dict = [json valueForKey:@"dingdanxq"];
//            
//            NSArray *shangpinList = dict[@"shoplist"];
//            for (NSDictionary *dic in shangpinList) {
//                OrderDetailShangpinModel *model = [[OrderDetailShangpinModel alloc]init];
//                [model setValuesForKeysWithDictionary:dic];
//                [self.shangpinListArray addObject:model];
//            }
//            
//            NSDictionary *dict1 = @{@"key":@"预约送达时间:",@"value":dict[@"yuyuesongda"]};
//            [self.zhifushangshiArray addObject:dict1];
//            if ([dict[@"fapiao"] integerValue] != 0) {
//                NSDictionary *dict2 = @{@"key":@"发票:",@"value":dict[@"fapiao"]};
//                [self.zhifushangshiArray addObject:dict2];
//            }
//            NSDictionary *dict3 = @{@"key":@"下单时间:",@"value":dict[@"cretdate"]};
//            NSDictionary *dict4 = @{@"key":@"单号:",@"value":dict[@"dingdanhao"]};
//            [self.zhifushangshiArray addObject:dict3];
//            [self.zhifushangshiArray addObject:dict4];
//            
//            if ([dict[@"shuliang"] integerValue] != 0) {
//                NSDictionary *dict11 = @{@"key":@"数量:",@"value":[NSString stringWithFormat:@"%@",dict[@"shuliang"]]};
//                [self.shuliangArray addObject:dict11];
//            }
//            if ([dict[@"dindanbeizhu"] integerValue] != 0) {
//                NSDictionary *dict11 = @{@"key":@"备注:",@"value":[NSString stringWithFormat:@"%@",dict[@"dindanbeizhu"]]};
//                [self.shuliangArray addObject:dict11];
//            }
//            
//            self.dataArray = [NSArray arrayWithObjects:self.zhifushangshiArray,self.shangpinListArray,self.shuliangArray,nil];
//        }
//        [self.mainTableView reloadData];
//        
//    } failure:^(NSError *error) {
//        [mHud hide:YES];
//        [self promptMessageWithString:@"网络连接错误"];
//    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return self.zhifushangshiArray.count;
    else if (section == 1) return self.shangpinListArray.count;
    else return self.shuliangArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0||indexPath.section == 2){
        static NSString *identifier = @"cell";
        OrderDetailCellOne *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[OrderDetailCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell reloadDataWithIndexpath:indexPath WithArray:self.dataArray[indexPath.section]];
        return cell;
    }
    else
    {
        static NSString *identifier = @"cellTwo";
        OrderDetailCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[OrderDetailCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell reloadDataWithIndexpath:indexPath WithArray:self.shangpinListArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0||indexPath.section == 2) return 30*MCscale;
    else return 70*MCscale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1*MCscale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.5;
    else return 4*MCscale;
}
-(void)btnAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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


