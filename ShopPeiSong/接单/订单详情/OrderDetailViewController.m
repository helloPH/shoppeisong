//
//  OrderDetailViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/8.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailCellOne.h"
#import "OrderDetailCellTwo.h"
#import "OrderDetailShangpinModel.h"
#import "OrderDetailDrawerView.h"
#import "ChangeFujiafeiView.h"
#import "PaymentPasswordView.h"
#import "OrderDetailBeizhuCell.h"
#import "CancalOrderView.h"
#import "OrderAddShangpinViewController.h"
#import "Header.h"
#import "daoHangOfXiangqing.h"
#import "PHMap.h"
#import "AlterOrderPeiSongFeiView.h"
@interface OrderDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,OrderDetailDrawerViewDelegate,ChangeFujiafeiViewDelegate,PaymentPasswordViewDelegate,CancalOrderViewDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIButton *leftButton,*rightButton;
@property(nonatomic,strong)NSMutableArray *shangpinListArray,*zhifushangshiArray,*shuliangArray,*shouhuoMoney;
@property(nonatomic,strong)NSArray *shouhuorenArray,*dataArray;
@property(nonatomic,strong)NSDictionary *DdxqDict;
@property(nonatomic,assign)float tihuofeiMoney,fujiafeiCount;
@property(nonatomic,strong)UIView *choutiBackView,*maskView;
@property(nonatomic,strong)UIImageView *choutiImage;
@property(nonatomic,strong)OrderDetailDrawerView *DrawerView;
@property(nonatomic,strong)ChangeFujiafeiView *changeFujjia;
@property(nonatomic,strong)PaymentPasswordView *passPopView;
@property(nonatomic,strong)CancalOrderView *cancalView;

@property(nonatomic,strong)UIImageView *caozuotishiImage;
@property(nonatomic,assign)BOOL isOpen,isRepeat;//抽屉是否打开,取消订单是否重复
@end
@implementation OrderDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.viewTag == 1) {
        [self.view addSubview:self.choutiBackView];
    }
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
-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"主页"];
        [_rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(void)setNavigationItem
{
    [self.navigationItem setTitle:@"东北麻辣烫"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(UIImageView *)caozuotishiImage
{
    if (!_caozuotishiImage) {
        _caozuotishiImage = [BaseCostomer imageViewWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@""];
        _caozuotishiImage.alpha = 0.9;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
        [_caozuotishiImage addGestureRecognizer:imageTap];
    }
    return _caozuotishiImage;
}
-(void)judgeTheFirst
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstDingdanDetil"] isEqualToString:@"1"]) {
        NSString *url = @"images/caozuotishi/chouti.png";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPHEADER,url];
        [self.view addSubview:self.caozuotishiImage];
        [self.caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
    }
}
-(void)imageHidden
{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstDingdanDetil"];
    [self.caozuotishiImage removeFromSuperview];
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kDeviceWidth, kDeviceHeight - 64-20*MCscale) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}
-(UIImageView *)choutiImage
{
    if (!_choutiImage) {
        _choutiImage = [BaseCostomer imageViewWithFrame:CGRectMake(self.choutiBackView.width/2.0-10*MCscale, 2*MCscale, 20*MCscale, 15*MCscale) backGroundColor:[UIColor clearColor] image:@"oop1"];
    }
    return _choutiImage;
}

-(UIView *)choutiBackView
{
    if (!_choutiBackView) {
        _choutiBackView = [BaseCostomer viewWithFrame:CGRectMake(10*MCscale, kDeviceHeight - 20*MCscale, kDeviceWidth-20*MCscale, 20*MCscale) backgroundColor:[UIColor clearColor]];
        [_choutiBackView  addSubview:self.choutiImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openDrawerClick)];
        [_choutiBackView addGestureRecognizer:tap];
    }
    return _choutiBackView;
}
-(UIView *)maskView
{
    if (!_maskView) {
        _maskView = [BaseCostomer viewWithFrame:self.view.bounds backgroundColor: [UIColor clearColor]];
        _maskView.alpha = 0;
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
        //        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
-(OrderDetailDrawerView *)DrawerView
{
    if (!_DrawerView) {
        _DrawerView = [[OrderDetailDrawerView alloc]initWithFrame:CGRectMake(10*MCscale, kDeviceHeight-330*MCscale, kDeviceWidth-20*MCscale, 320*MCscale)];
        _DrawerView.drawerDelegate = self;
    }
    return _DrawerView;
}

-(ChangeFujiafeiView *)changeFujjia
{
    if (!_changeFujjia) {
        _changeFujjia = [[ChangeFujiafeiView alloc]initWithFrame:CGRectMake(50*MCscale,180*MCscale, kDeviceWidth-100*MCscale,120*MCscale)];
        _changeFujjia.changeFujiaDelegate = self;
    }
    return _changeFujjia;
}
-(PaymentPasswordView *)passPopView
{
    if (!_passPopView) {
        //支付密码
        _passPopView = [[PaymentPasswordView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 360*MCscale)];
        _passPopView.paymentPasswordDelegate = self;
        _passPopView.alpha = 0;
    }
    return _passPopView;
}
-(CancalOrderView *)cancalView
{
    if (!_cancalView) {
        //支付密码
        _cancalView = [[CancalOrderView alloc]initWithFrame:CGRectMake(50*MCscale,180*MCscale, kDeviceWidth-100*MCscale,120*MCscale)];
        _cancalView.cancalDelegate = self;
        _cancalView.alpha = 0;
    }
    return _cancalView;
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
-(NSMutableArray *)shouhuoMoney
{
    if (!_shouhuoMoney) {
        _shouhuoMoney = [NSMutableArray arrayWithCapacity:0];
    }
    return _shouhuoMoney;
}
-(float)tihuofeiMoney
{
    if (!_tihuofeiMoney) {
        _tihuofeiMoney = 0;
    }
    return _tihuofeiMoney;
}
-(float)fujiafeiCount
{
    if (!_fujiafeiCount) {
        _fujiafeiCount = 0;
    }
    return _fujiafeiCount;
}
-(BOOL)isOpen
{
    if (!_isOpen) {
        _isOpen = 0;
    }
    return _isOpen;
}
-(BOOL)isRepeat
{
    if (!_isRepeat) {
        _isRepeat = 0;
    }
    return _isRepeat;
}
-(NSDictionary *)DdxqDict
{
    if (!_DdxqDict) {
        _DdxqDict = @{};
    }
    return _DdxqDict;
}

#pragma mark 抽屉打开关闭
-(void)openDrawerClick
{
    if (self.isOpen) {
        [self maskViewDisMiss];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0.9;
            [self.view addSubview:self.maskView];
            self.DrawerView.alpha = 0.95;
            [self.view addSubview:self.DrawerView];
            [self.choutiBackView removeFromSuperview];
            [self.view addSubview:self.choutiBackView];
            self.choutiBackView.frame = CGRectMake(10*MCscale, kDeviceHeight-350*MCscale, kDeviceWidth-20*MCscale, 20*MCscale);
            self.choutiImage.image = [UIImage imageNamed:@"oop2"];
            [self.choutiBackView bringSubviewToFront:self.view];
        }];
    }
    self.isOpen = !self.isOpen;
}
#pragma mark 获取订单详情
-(void)getOrderDetailData
{
    self.dataArray=nil;
    self.zhifushangshiArray=nil;
    self.shangpinListArray=nil;
    self.shuliangArray=nil;
    self.shouhuoMoney=nil;
    /**
    yingfujines			  //应付金额
     youhuis	    		 //优惠（已去掉）
     
     
     shifuchengben           //实付成本
     dianpuid			  	//店铺id
     dinapuname			  	//店铺名字
     address_x              //收货地址X坐标
     address_y              //收货地址Y坐标
     dianpu_x               //店铺地址X坐标
     dianpu_y               //店铺地址Y坐标
     dingdanshoucha       //实付退差 （值为0=不用退差 ,
     值不为0=退差金额）
     huodongleixing       //活动类型（1=首减 2=满减  0=无活动）
     goumaimoney           //活动购买金额（无活动传0）
     jianmoney             //活动减的金额（无活动传0）
         buttonstatus         //按键状态（1=取消订单按键为红色，点击调取接口，保存订单点击系统提示“暂未开放”；0=取消订单和保存订单按键为灰色，不能调取接口，系统提示“目前订单不能修改”。）
     jine			 	    //金额（优惠前)
     */
    
    
    
    
    [Request getOrderInfoWithDic:@{@"danhao":self.danhao} success:^(id json) {
        NSLog(@"订单详情 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 0) {
            [MBProgressHUD promptWithString:@"参数不能为空"];
        }
        else if ([[json valueForKey:@"message"] integerValue] == 1)
        {
            [MBProgressHUD promptWithString:@"加载失败"];
        }
        else
        {
            self.DdxqDict = [json valueForKey:@"dingdanxq"];
            NSArray *shangpinList = self.DdxqDict[@"shoplist"];
            for (NSDictionary *dic in shangpinList) {
                OrderDetailShangpinModel *model = [[OrderDetailShangpinModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                
    
                [self.shangpinListArray addObject:model];
                self.tihuofeiMoney = self.tihuofeiMoney+[model.total_money floatValue];
            }
        
            NSDictionary *dict1 = @{@"key":@"收货人:",@"value":self.DdxqDict[@"shouhuoren"]};
            NSDictionary *dict2 = @{@"key":@"手机号码:",@"value":[NSString stringWithFormat:@"%@",self.DdxqDict[@"tel"]]};
            NSDictionary *dict3 = @{@"key":@"收货地址:",@"value":self.DdxqDict[@"shouhuodizhi"]};
            NSDictionary *dict4 = @{@"key":@"下单时间:",@"value":self.DdxqDict[@"cretdate"]};
            NSDictionary *dict5 = @{@"key":@"单号:",@"value":self.DdxqDict[@"dingdanhao"]};
            self.shouhuorenArray = [NSArray arrayWithObjects:dict1,dict2,dict3,dict4,dict5, nil];
            
            NSDictionary *dict6 = @{@"key":@"支付方式:",@"value":self.DdxqDict[@"zhifufangshi"]};
            NSDictionary *dict7 = @{@"key":@"预约送达时间:",@"value":self.DdxqDict[@"yuyuesongda"]};
            [self.zhifushangshiArray addObject:dict6];
            [self.zhifushangshiArray addObject:dict7];
            
            
            NSString * fapiaoS = [NSString stringWithFormat:@"%@",self.DdxqDict[@"fapiao"]];
            if ([fapiaoS integerValue] != 0) {
                NSDictionary *dict8 = @{@"key":@"发票:",@"value":fapiaoS};
                [self.zhifushangshiArray addObject:dict8];
            }
            
            
            NSString * shuliangS = [NSString stringWithFormat:@"%@",self.DdxqDict[@"shuliang"]];
            if ([shuliangS integerValue] != 0) {
                NSDictionary *dict11 = @{@"key":@"数量:",@"value":[NSString stringWithFormat:@"%@",self.DdxqDict[@"shuliang"]]};
                [self.shuliangArray addObject:dict11];
            }
            
            
            if ([self.DdxqDict[@"youhui"] integerValue] != 0) {
                NSDictionary *dict11 = @{@"key":@"优惠:",@"value":[NSString stringWithFormat:@"¥%.2f",[self.DdxqDict[@"youhui"] floatValue]]};
                [self.shuliangArray addObject:dict11];
            }
            if ([self.DdxqDict[@"youhuiquan"] integerValue] != 0) {
                NSDictionary *dict11 = @{@"key":@"优惠券:",@"value":[NSString stringWithFormat:@"%@",self.DdxqDict[@"youhuiquan"]]};
                [self.shuliangArray addObject:dict11];
            }
            if ([self.DdxqDict[@"fujiafei"] integerValue] != 0) {
                NSDictionary *dict11 = @{@"key":@"附加费:",@"value":[NSString stringWithFormat:@"¥%.2f",[self.DdxqDict[@"fujiafei"] floatValue]]};
                self.fujiafeiCount = [self.DdxqDict[@"fujiafei"] floatValue];
                self.tihuofeiMoney = self.tihuofeiMoney +self.fujiafeiCount;
                [self.shuliangArray addObject:dict11];
            }
            if ([self.DdxqDict[@"peisongfei"] integerValue] != 0) {
                NSDictionary *dict11 = @{@"key":@"配送费:",@"value":[NSString stringWithFormat:@"¥%.2f",[self.DdxqDict[@"peisongfei"] floatValue]]};
                [self.shuliangArray addObject:dict11];
            }
            if ([self.DdxqDict[@"shifukuan"] integerValue] != 0) {
                NSDictionary *dict11 = @{@"key":@"实付款:",@"value":[NSString stringWithFormat:@"¥%.2f",[self.DdxqDict[@"shifukuan"] floatValue]]};
                [self.shuliangArray addObject:dict11];
            }
            
            NSDictionary *dict9 = @{@"key":@"收货额:",@"value":[NSString stringWithFormat:@"¥%.1f",[self.DdxqDict[@"shifuchengben"] floatValue]]};
            [self.shouhuoMoney addObject:dict9];
            NSDictionary *dict10 = @{@"key":@"提货费:",@"value":[NSString stringWithFormat:@"¥%.2f",self.tihuofeiMoney]};
            [self.shouhuoMoney addObject:dict10];
            
            if (![self.DdxqDict[@"dindanbeizhu"] isEqualToString:@"0"])
            {
                NSDictionary *dict12 = @{@"key":@"备注:",@"value":[NSString stringWithFormat:@"%@",self.DdxqDict[@"dindanbeizhu"]]};
                self.dataArray = [NSArray arrayWithObjects:self.zhifushangshiArray,self.shouhuorenArray,self.shangpinListArray,self.shouhuoMoney,self.shuliangArray,dict12,nil];
            }
            else self.dataArray = [NSArray arrayWithObjects:self.zhifushangshiArray,self.shouhuorenArray,self.shangpinListArray,self.shouhuoMoney,self.shuliangArray,nil];
        }
        [self.mainTableView reloadData];

    } failure:^(NSError *error) {
        
    }];
    
    

}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return self.zhifushangshiArray.count;
    else if (section == 1) return self.shouhuorenArray.count;
    else if (section == 2) return self.shangpinListArray.count;
    else if (section == 3) return self.shouhuoMoney.count;
    else if (section == 4) return self.shuliangArray.count;
    else return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.5;
    else if (section == 2){
        return 30*MCscale;
    }else return 4*MCscale;
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30*MCscale)];
    backView.backgroundColor=[UIColor clearColor];
    
    
    UILabel * lable= [[UILabel alloc]initWithFrame:CGRectMake(10*MCscale, 10*MCscale, 100, 20*MCscale)];
    lable.textColor=textBlackColor;
    [backView addSubview:lable];
    lable.text=[NSString stringWithFormat:@"满减:满%@减%@",_DdxqDict[@"goumaimoney"],_DdxqDict[@"jianmoney"]];
    [lable sizeToFit];
    
    
    UILabel * lable1= [[UILabel alloc]initWithFrame:CGRectMake(0, 10*MCscale, 100, 20*MCscale)];
    lable1.textColor=redTextColor;
    [backView addSubview:lable1];
 
    lable1.text=[NSString stringWithFormat:@"优惠:%@元",_DdxqDict[@"youhui"]];
    [lable1 sizeToFit];
    lable1.right=kDeviceWidth-10*MCscale;
    
    if (section==2) {
           return backView;
    }else{
        return nil;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0||indexPath.section == 1||indexPath.section == 3 ||indexPath.section == 4){
        static NSString *identifier = @"cell";
        OrderDetailCellOne *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[OrderDetailCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell reloadDataWithIndexpath:indexPath WithArray:self.dataArray[indexPath.section]];
        return cell;
    }
    else if (indexPath.section == 5){
        static NSString *identifier = @"beizhucell";
        OrderDetailBeizhuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[OrderDetailBeizhuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell reloadDataWithIndexpath:indexPath WithDict:self.dataArray[indexPath.section]];
        return cell;
    }
    else
    {
        static NSString *identifier = @"cellTwo";
        OrderDetailCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[OrderDetailCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            UIView *btnView = [BaseCostomer viewWithFrame:CGRectMake(kDeviceWidth,0,200,70*MCscale) backgroundColor:txtColors(206, 207, 208, 1)];
            
            UIImageView *image = [BaseCostomer imageViewWithFrame:CGRectMake(25/MCscale,17*MCscale, 35*MCscale, 35*MCscale) backGroundColor:[UIColor clearColor] image:@"red_delet"];
            [btnView addSubview:image];
            [cell.contentView addSubview:btnView];
        }
        [cell reloadDataWithIndexpath:indexPath WithArray:self.shangpinListArray];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) return YES;
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0||indexPath.section == 1||indexPath.section == 3 ||indexPath.section == 4) return 30*MCscale;
    else return 70*MCscale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1*MCscale;
}

#pragma mark 抽屉响应事件(OrderDetailDrawerViewDelegate)
-(void)selectedTargetWithIndex:(NSInteger)index
{
    NSInteger btnTag = index - 2000;
    switch (btnTag) {
        case 0:
        {
            if ([self.model.button integerValue] == 6||self.model.type == 0 ) {
                [self promptMessageWithString:@"不能修改附加"];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.DrawerView.alpha = 0;
                    [self.DrawerView removeFromSuperview];
                    self.choutiBackView.frame = CGRectMake(10*MCscale, kDeviceHeight-20*MCscale, kDeviceWidth-20*MCscale, 20*MCscale);
                    self.choutiImage.image = [UIImage imageNamed:@"oop1"];
                    self.changeFujjia.alpha = 1;
                    [self.changeFujjia getFujiafeiMoney:[NSString stringWithFormat:@"当前附加费:%.2f",self.fujiafeiCount] AndViewTag:1];
                    [self.view addSubview:self.changeFujjia];
                }];
            }
        }
            break;
        case 1:
        {
            if ([self.DdxqDict[@"zhifufangshi"] isEqualToString:@"货到付款"]||[self.DdxqDict[@"dingdanshoucha"] integerValue] == 0) {
                [self promptMessageWithString:@"当前订单不符合退查条件"];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.DrawerView.alpha = 0;
                    [self.DrawerView removeFromSuperview];
                    self.choutiBackView.frame = CGRectMake(10*MCscale, kDeviceHeight-20*MCscale, kDeviceWidth-20*MCscale, 20*MCscale);
                    self.choutiImage.image = [UIImage imageNamed:@"oop1"];
                    self.passPopView.alpha = 0.95;
                    [self.view addSubview:self.passPopView];
                }];
            }
        }
            break;
        case 2:
        {
            NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.DdxqDict[@"shanghurexian"]]];
            UIWebView *phoneWeb = [[UIWebView alloc]initWithFrame:CGRectZero];
            [phoneWeb loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
            [self.mainTableView addSubview:phoneWeb];
        }
            break;
        case 3:
        {
            
            if (self.isRepeat) [self promptMessageWithString:@"不能多次操作"];
            else
            {
                
                
                if ([self.DdxqDict[@"dindanbeizhu"] isEqualToString:@"订单已申请取消"])  [self promptMessageWithString:@"订单已申请取消"];
                else
                {
                    
                    
                    
                    
                    
                    [self maskViewDisMiss];
                    if ([self.DdxqDict[@"quxiaoquanxian"] integerValue] == 0) {
                        [UIView animateWithDuration:0.3 animations:^{
                            self.DrawerView.alpha = 0;
                            [self.DrawerView removeFromSuperview];
                            self.choutiBackView.frame = CGRectMake(10*MCscale, kDeviceHeight-20*MCscale, kDeviceWidth-20*MCscale, 20*MCscale);
                            self.choutiImage.image = [UIImage imageNamed:@"oop1"];
                            self.cancalView.alpha = 0.95;
                            self.cancalView.danhaoStr = self.danhao;
                            [self.view addSubview:self.cancalView];
                        }];
                    }
                    else if ([self.DdxqDict[@"quxiaoquanxian"] integerValue] == 1)  [self cancalOrder];
                }
            }
            self.isRepeat = 1;
        }
            break;
        case 4:
        {
            
            
            if ([self.DdxqDict[@"identity"]integerValue] == 0 && [self.DdxqDict[@"zhifufangshi"] isEqualToString:@"在线支付"]) [self promptMessageWithString:@"不能提交修改"];
            else
            {
                if ([self.model.button integerValue] == 6 ||[self.model.type integerValue] == 0)  [self promptMessageWithString:@"不能提交修改"];
                else
                {
                    if (self.shangpinListArray.count ==0) [self promptMessageWithString:@"不能提交修改"];
                    else [self saveMessages];
                }
            }
        }
            break;
        case 5:
        {
//            if ([self.model.button integerValue] == 6|| self.model.type ==0) [self promptMessageWithString:@"不能增加商品"];
//            else
//            {
                OrderAddShangpinViewController *shangpingVC = [[OrderAddShangpinViewController alloc]init];
                shangpingVC.hidesBottomBarWhenPushed = YES;
                shangpingVC.dianpuID = self.DdxqDict[@"dianpuid"];
                shangpingVC.dianpuName = self.DdxqDict[@"dinapuname"];
                [self.navigationController pushViewController:shangpingVC animated:YES];
//            }
        }
            break;
        case 6://送货导航
        {
            NSString * dianpux = [NSString stringWithFormat:@"%@",_DdxqDict[@"dianpu_x"]];
            NSString * dianpuy = [NSString stringWithFormat:@"%@",_DdxqDict[@"dianpu_y"]];
            
            
            NSString * addressx = [NSString stringWithFormat:@"%@",_DdxqDict[@"address_x"]];
            NSString * addressy = [NSString stringWithFormat:@"%@",_DdxqDict[@"address_y"]];
            
            
            daoHangOfXiangqing * dao = [daoHangOfXiangqing new];
            dao.qiLati=[dianpuy doubleValue];
            dao.qiLongi=[dianpux doubleValue];
            dao.zhongLati=[addressy doubleValue];
            dao.zhongLongi=[addressx doubleValue];
    
            [dao appear];
           
    
        }
            break;
        case 7://免配送费
        {
            NSDictionary * pram = @{@"danhao":_danhao};
            [Request cancelOrderPeiSongFeiWithDic:pram success:^(id json) {
                NSString * messge = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                if ([messge isEqualToString:@"1"]) {
                    [MBProgressHUD promptWithString:@"成功免配送费"];
                    [self getOrderDetailData];
                }else{
                    [MBProgressHUD promptWithString:@"免配送费失败"];
                    [self getOrderDetailData];
                }
                

                
        
            } failure:^(NSError *error) {
                
            }];
        
        }
            break;
        case 8:// 取货导航
        {
            daoHangOfXiangqing * dao = [daoHangOfXiangqing new];
            PHMapHelper * helper = [PHMapHelper new];
            [helper locationStartLocation:^{
            } locationing:^(BMKUserLocation *location, NSError *error) {
                [helper endLocation];
                if (error) {
                    [MBProgressHUD promptWithString:@"定位失败"];
                    return ;
                };
                NSString * dianpux = [NSString stringWithFormat:@"%@",_DdxqDict[@"dianpu_x"]];
                NSString * dianpuy = [NSString stringWithFormat:@"%@",_DdxqDict[@"dianpu_y"]];
                
                dao.qiLati=location.location.coordinate.latitude;
                dao.qiLongi=location.location.coordinate.longitude;
                dao.zhongLati=[dianpuy doubleValue];
                dao.zhongLongi=[dianpux doubleValue];
         

                [dao appear];
             
            } stopLocation:^{
            }];
            
 
      
        }
            break;
        case 9:// 修改配送费
        {
            
            AlterOrderPeiSongFeiView * alterOrerpeisongfei = [AlterOrderPeiSongFeiView new];
            alterOrerpeisongfei.danhao = _danhao;
            [alterOrerpeisongfei appear];
            
        }
        default:
            break;
    }
}

#pragma mark 保存修改
-(void)saveMessages
{
    /**
     youhui           订单优惠的金额
     yingfujine       优惠后订单总金额
     jine             优惠前订单总金额
     fudongfei        附加费
     shifukuan        用户实付金额（优惠后订单总金额+附加费+配送费）
     danhao 					  //单号
     shuliang				 //商品数量（，拼接）
     yanse					 /颜色（，拼接  无颜色传0代替）
     xinghao				 //型号（，拼接  无型号传0代替）
     shangpinid					//商品id（，拼接）
     C.返回结果：message      --------0     //订单失败
     --------1	 //订单成功
     */
    
    
    NSDictionary * dic = @{@"youhui":@"",
                           @"yingfujine":@"",
                           @"jine":@"",
                           @"fudongfei":@"",
                           @"shifukuan":@"",
                           @"danhao":self.danhao,
                           @"shuliang":@"",
                           @"yanse":@"",
                           @"xinghao":@"",
                           @"shangpinid":@""};
    
    [Request saveOrderEditWithDic:dic success:^(id json) {
        NSLog(@"取消订单 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 1) {
            [self promptSuccessWithString:@"订单修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else  [self promptMessageWithString:@"订单修改失败"];
    } failure:^(NSError *error) {

    }];
    

}

#pragma mark 取消订单
-(void)cancalOrder
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"danhao":self.danhao}];
    [HTTPTool getWithUrl:@"quxiaoDingdan.action" params:pram success:^(id json) {
        [mHud hide:YES];
        NSLog(@"取消订单 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 1) {
            [self promptSuccessWithString:@"取消订单成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if([[json valueForKey:@"message"]integerValue]== 2) [self promptMessageWithString:@"取消订单失败"];
        else [self promptMessageWithString:@"参数不能为空"];
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark 修改附费(ChangeFujiafeiViewDelegate)
-(void)changeFujiafeiSuccessWithMoney:(NSString *)money AndIndex:(NSInteger)index
{
    if (index == 0) {
        [self.shuliangArray removeAllObjects];
        [self.shouhuoMoney removeAllObjects];
        [self.shangpinListArray removeAllObjects];
        self.tihuofeiMoney = 0;
        self.fujiafeiCount = 0;
        
        NSArray *shangpinList = self.DdxqDict[@"shoplist"];
        for (NSDictionary *dic in shangpinList) {
            OrderDetailShangpinModel *model = [[OrderDetailShangpinModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.shangpinListArray addObject:model];
            self.tihuofeiMoney = self.tihuofeiMoney+[model.total_money floatValue];
        }
        
        if ([self.DdxqDict[@"shuliang"] integerValue] != 0) {
            NSDictionary *dict11 = @{@"key":@"数量:",@"value":[NSString stringWithFormat:@"%@",self.DdxqDict[@"shuliang"]]};
            [self.shuliangArray addObject:dict11];
        }
        if ([self.DdxqDict[@"youhui"] integerValue] != 0) {
            NSDictionary *dict11 = @{@"key":@"优惠:",@"value":[NSString stringWithFormat:@"¥%.2f",[self.DdxqDict[@"youhui"] floatValue]]};
            [self.shuliangArray addObject:dict11];
        }
        if ([self.DdxqDict[@"youhuiquan"] integerValue] != 0) {
            NSDictionary *dict11 = @{@"key":@"优惠券:",@"value":[NSString stringWithFormat:@"%@",self.DdxqDict[@"youhuiquan"]]};
            [self.shuliangArray addObject:dict11];
        }
        
        if ([money integerValue] != 0) {
            NSDictionary *dict11 = @{@"key":@"附加费:",@"value":[NSString stringWithFormat:@"¥%.2f",[money  floatValue]]};
            [self.shuliangArray addObject:dict11];
        }
        self.fujiafeiCount = [money floatValue];
        self.tihuofeiMoney = self.tihuofeiMoney + self.fujiafeiCount;
        
        float shifukuan = 0;
        shifukuan = self.tihuofeiMoney + [self.DdxqDict[@"peisongfei"] floatValue];
        
        if ([self.DdxqDict[@"peisongfei"] integerValue] != 0) {
            NSDictionary *dict11 = @{@"key":@"配送费:",@"value":[NSString stringWithFormat:@"¥%.2f",[self.DdxqDict[@"peisongfei"] floatValue]]};
            [self.shuliangArray addObject:dict11];
        }
        
        if ([self.DdxqDict[@"shifukuan"] integerValue] != 0) {
            NSDictionary *dict11 = @{@"key":@"实付款:",@"value":[NSString stringWithFormat:@"¥%.2f",shifukuan]};
            [self.shuliangArray addObject:dict11];
        }
        
        NSDictionary *dict9 = @{@"key":@"收货额:",@"value":[NSString stringWithFormat:@"¥%.1f",[self.DdxqDict[@"shifuchengben"] floatValue]]};
        [self.shouhuoMoney addObject:dict9];
        NSDictionary *dict10 = @{@"key":@"提货费:",@"value":[NSString stringWithFormat:@"¥%.2f",self.tihuofeiMoney]};
        [self.shouhuoMoney addObject:dict10];
        [self.mainTableView reloadData];
    }
    else if(index == 1) [self promptSuccessWithString:@"补差额成功"];
    else if (index == 2) [self promptMessageWithString:@"补差额失败"];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.maskView removeFromSuperview];
        [self.view endEditing:YES];
        self.changeFujjia.alpha = 0;
        [self.changeFujjia removeFromSuperview];
    }];
}

#pragma  mark (支付密码验证成功) PaymentPasswordViewDelegate
-(void)PaymentSuccess
{
    [UIView animateWithDuration:0.3 animations:^{
        self.passPopView.alpha = 0;
        [self.passPopView removeFromSuperview];
        self.changeFujjia.alpha = 1;
        [self.changeFujjia getFujiafeiMoney:[NSString stringWithFormat:@"参考值为:%.2f",[self.DdxqDict[@"dingdanshoucha"] floatValue]] AndViewTag:2];
        self.changeFujjia.danhaoStr = self.danhao;
        self.changeFujjia.buchaMoney = [self.DdxqDict[@"dingdanshoucha"] floatValue];
        [self.view addSubview:self.changeFujjia];
    }];
}

#pragma mark 取消订单申请成功(CancalOrderViewDelegate)
-(void)cancalOrderSuccessWithIndex:(NSInteger)index
{
    if (index == 1) {
        [self promptSuccessWithString:@"取消订单审核提交成功"];
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0;
            [self.maskView removeFromSuperview];
            [self.view endEditing:YES];
            self.cancalView.alpha = 0;
            [self.cancalView removeFromSuperview];
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(index == 2) [self promptMessageWithString:@"取消订单审核提交失败"];
    else  [self promptMessageWithString:@"参数不能为空"];
}

-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.maskView removeFromSuperview];
        [self.view endEditing:YES];
        self.DrawerView.alpha = 0;
        [self.DrawerView removeFromSuperview];
        self.choutiBackView.frame = CGRectMake(10*MCscale, kDeviceHeight-20*MCscale, kDeviceWidth-20*MCscale, 20*MCscale);
        self.choutiImage.image = [UIImage imageNamed:@"oop1"];
    }];
}
-(void)btnAction:(UIButton *)button
{
    if (button == self.leftButton) [self.navigationController popViewControllerAnimated:YES];
    else [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)promptSuccessWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    mHud.mode = MBProgressHUDModeCustomView;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1);
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.changeFujjia.moneyTextField resignFirstResponder];
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

