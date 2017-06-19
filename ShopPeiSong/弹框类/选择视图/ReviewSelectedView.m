//
//  ReviewSelectedView.m
//  ManageForMM
//
//  Created by MIAO on 16/11/1.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ReviewSelectedView.h"
#import "TypeSelectedCell.h"
#import "Header.h"

@interface ReviewSelectedView ()

@property(nonatomic,strong)UITableView *mainTableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *statesArray;
@property(nonatomic,strong)UIButton * backView;
@end
@implementation ReviewSelectedView
{
    NSInteger viewTag;
}
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
-(void)appear{
    _backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    self.frame=CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 240*MCscale);
    [_backView addTarget:self action:@selector(dissAppear) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    
    
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    [_backView addSubview:self];
    
    _backView.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=1;
    }];
}
-(void)dissAppear{
    if (!_backView) {
        return;
    }
    
    __block ReviewSelectedView * weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.backView removeFromSuperview];
    }];
    
    
}


-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
-(NSArray *)statesArray
{
    if (!_statesArray) {
        _statesArray = @[@"上架",@"下架"];
    }
    return _statesArray;
}

-(void)reloadDataWithViewTag:(SeleType)index
{
    viewTag = index;
    if (index == 1) [self getShopMessageData];
    else if (index == 2)  [self getshangpinFenleiData];
    else if (index == 3)  [self getAddShangpinFenleiData];
    else if (index == 4)  [self getAddShangpinBiaoqianData];
    else if (index == 6)  [self getNOshenheShopMessageData];
    else if (index == 7)  [self getHangYeLeiBieData];
    [self.mainTableview reloadData];
}

-(UITableView *)mainTableview
{
    if (!_mainTableview) {
        _mainTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableview.frame = CGRectMake(0, 15*MCscale, self.width, self.height - 30*MCscale);
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
        _mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_mainTableview];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [_mainTableview addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [_mainTableview addGestureRecognizer:longPress];
        
        
        
        
    }
    return _mainTableview;
}




#pragma mark 获得店铺数据
-(void)getShopMessageData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangongid":user_id}];
    _dataArray = nil;
    [HTTPTool getWithUrl:@"enterShop.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"店铺信息 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 0){
            [self promptMessageWithString:@"无可显示店铺"];
        }
        else
        {
            [self.dataArray removeAllObjects];
            NSArray *shopList = [json valueForKey:@"dianpulist"];
            for (NSDictionary *dict in shopList) {
                [self.dataArray addObject:dict];
            }
            [self.mainTableview reloadData];
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}

#pragma mark 获取商品分类数据
-(void)getshangpinFenleiData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":user_dianpuID}];
    
    
    [HTTPTool getWithUrl:@"dianpuLeibie.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"店铺类别 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 3){
            [self promptMessageWithString:@"无可显示店铺"];
        }
        else if ([[json valueForKey:@"message"]integerValue]== 2)
        {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else
        {
            [self.dataArray removeAllObjects];
            NSArray *shopList = [json valueForKey:@"leibielist"];
            for (NSDictionary *dict in shopList) {
                [self.dataArray addObject:dict];
            }
            [self.mainTableview reloadData];
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark 获取添加商品分类数据
-(void)getAddShangpinFenleiData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":_dianpuId}];
    [HTTPTool getWithUrl:@"dianpuLeibie.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"添加店铺类别 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 2){
            [self promptMessageWithString:@"当前店铺无类别"];
        }
        else if ([[json valueForKey:@"message"]integerValue]== 0)
        {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else
        {
            [self.dataArray removeAllObjects];
            NSArray *leibieList = [json valueForKey:@"leibielist"];
            for (NSDictionary *dict in leibieList) {
                [self.dataArray addObject:dict];
            }
            [self.mainTableview reloadData];
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark 获取添加商品标签数据
-(void)getAddShangpinBiaoqianData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    
    [HTTPTool getWithUrl:@"biaoqian.action" params:nil success:^(id json){
        [mHud hide:YES];
        NSLog(@"添加店铺标签 %@",json);
        [self.dataArray removeAllObjects];
        NSArray *leibieList = [json valueForKey:@"biaoqian"];
        for (NSDictionary *dict in leibieList) {
            [self.dataArray addObject:dict];
        }
        [self.mainTableview reloadData];
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark -- 获取没有审核店铺的列表
-(void)getNOshenheShopMessageData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"zhiyuanid":user_id}];
    
    [HTTPTool getWithUrl:@"dianpuNoShenhe.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"店铺信息 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 0){
            [self promptMessageWithString:@"无可显示店铺"];
        }
        else
        {
            [self.dataArray removeAllObjects];
            NSArray *shopList = [json valueForKey:@"kaihucaogao"];
            for (NSDictionary *dict in shopList) {
                [self.dataArray addObject:dict];
            }
            [self.mainTableview reloadData];
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark -- 获取行业类别的列表
-(void)getHangYeLeiBieData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    //    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"zhiyuanid":user_id}];
    
    [HTTPTool getWithUrl:@"hangye.action" params:nil success:^(id json){
        [mHud hide:YES];
        NSLog(@"店铺信息 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 0){
            [self promptMessageWithString:@"无可显示店铺"];
        }
        else
        {
            [self.dataArray removeAllObjects];
            NSArray *shopList = [json valueForKey:@"hangye"];
            for (NSDictionary *dict in shopList) {
                [self.dataArray addObject:dict];
            }
            [self.mainTableview reloadData];
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (viewTag == 5) {
        return self.statesArray.count;
    }
    else
    {
        return self.dataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TypeSelectedCell";
    
    TypeSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.indexPath=indexPath;
  
    
    
    
    if (cell == nil) {
        cell = [[TypeSelectedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (int i = 0; i < cell.gestureRecognizers.count; i ++) {
        UIGestureRecognizer * ges = cell.gestureRecognizers[i];
        [cell removeGestureRecognizer:ges];
    }
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//    [cell addGestureRecognizer:tap];

    
    
    
    
    
    if (viewTag == 1)
    {
        [cell reloadDataForShopWithIndexPath:indexPath AndArray:self.dataArray];
    }
    else if (viewTag == 2||viewTag == 3)
    {
        [cell reloadDataForLeibieWithIndexPath:indexPath AndArray:self.dataArray];
    }
    else if (viewTag == 4)
    {
        [cell reloadDataForBiaoqianWithIndexPath:indexPath AndArray:self.dataArray];
    }
    else if (viewTag == 5)
    {
        [cell reloadDataForStatesWithIndexPath:indexPath AndArray:self.statesArray];
    }else if(viewTag == 6){
        [cell reloadDataForShopWithIndexPath:indexPath AndArray:self.dataArray];
        //        [cell reloadDataForBiaoqianWithIndexPath:indexPath AndArray:self.dataArray];
    }else if(viewTag == 7){
        [cell reloadDataForHangyeWithIndexPath:indexPath AndArray:self.dataArray];
    }
    return cell;
}
-(void)tap:(UITapGestureRecognizer *)tap{
    CGPoint p = [tap locationInView:tap.view];
    NSIndexPath * indexPath = [self.mainTableview indexPathForRowAtPoint:p];
    
    __block ReviewSelectedView * weakSelf = self;
    if (_block) {
        [weakSelf dissAppear];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
        [dic setValue:@"0" forKey:@"isLongPress"];
        
        id data = dic;
        _block(data);
    }
    
    if (viewTag == 1) {
        NSDictionary *dict = self.dataArray[indexPath.row];
        if ([self.selectedDelegate respondsToSelector:@selector(selectedIndustryWithString:AndId:)]) {
            [self.selectedDelegate selectedIndustryWithString:dict[@"dianpuname"] AndId:dict[@"dianpuid"]];
        }
    }
    else if(viewTag == 2)
    {
        if ([self.selectedDelegate respondsToSelector:@selector(selectedLeixingWithString:)]) {
            [self.selectedDelegate selectedLeixingWithString:self.dataArray[indexPath.row][@"leibie"]];
            //leibie
        }
    }
    else if(viewTag == 3)
    {
        NSDictionary *dict = self.dataArray[indexPath.row];
        if ([self.selectedDelegate respondsToSelector:@selector(selectedAddShangpinLeixinWithString:AndId:)]) {
            [self.selectedDelegate selectedAddShangpinLeixinWithString:dict[@"leibie"] AndId:dict[@"id"]];
        }
    }
    else if(viewTag == 4)
    {
        NSDictionary *dict = self.dataArray[indexPath.row];
        if ([self.selectedDelegate respondsToSelector:@selector(selectedAddShangpinBiaoqianWithString:AndId:)]) {
            [self.selectedDelegate selectedAddShangpinBiaoqianWithString:dict[@"biaoqianname"] AndId:dict[@"biaoqianid"]];
        }
    }
    else if(viewTag == 5)
    {
        if ([self.selectedDelegate respondsToSelector:@selector(selectedStatesWithString:)]) {
            [self.selectedDelegate selectedStatesWithString:self.statesArray[indexPath.row]];
        }
    }else if (viewTag == 6){
        NSDictionary *dict = self.dataArray[indexPath.row];
        if ([self.selectedDelegate respondsToSelector:@selector(selectedNoShenheStoreWithString:AndId:)]) {
            [self.selectedDelegate selectedNoShenheStoreWithString:dict[@"dianpuname"] AndId:dict[@"dianpuid"]];
        }
    }else if (viewTag == 7){
        NSDictionary *dict = self.dataArray[indexPath.row];
        if ([self.selectedDelegate respondsToSelector:@selector(selectedHangyeWithString:AndId:)]) {
            [self.selectedDelegate selectedHangyeWithString:dict[@"name"] AndId:dict[@"id"]];
        }
    }

    
}
-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state==UIGestureRecognizerStateEnded) {
        if (_block) {
            
            CGPoint p = [longPress locationInView:longPress.view];
            NSIndexPath * indexPath = [self.mainTableview indexPathForRowAtPoint:p];

            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
            
            [dic setValue:@"1" forKey:@"isLongPress"];
            id data = dic;
            
            _block(data);
        }

    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*MCscale;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_notLayout) {
        return;
    }
    self.mainTableview.frame = CGRectMake(0, 15*MCscale, self.width, self.height - 30*MCscale);
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

@end

