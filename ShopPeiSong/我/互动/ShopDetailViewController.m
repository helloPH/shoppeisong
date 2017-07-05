//
//  ShopDetailViewController.m
//  LifeForMM
//
//  Created by HUI on 15/7/26.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "Header.h"
#import "RatingView.h"
#import "shopDetailModel.h"
#import "ShopEvaluateModel.h"
#import "ShopEvaluateCell.h"
#import "ShopManagerAddAddAlter.h"
#import "ReplyEvaluateView.h"

@interface ShopDetailViewController ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *shopDetailTabel;
    NSMutableArray *detailDataAry; //店铺相关信息
    NSMutableArray *evaluateDataAry; //店铺相关信息
    NSArray *huodTitleAry;//活动标题
    NSArray *huodImageAry;//活动图片
    NSArray *shopMessageImgAry;//店铺信息图片数组
    NSInteger secCellCount;
    UIView *btnView;
    UIView *lineView;
    UIView *hearderView;
    
    UIButton *shopMessageBtn;//常用按钮
    UIButton *evaluateBtn;//全部按钮
    BOOL isEvaluate;
    BOOL isSelected;
    UIImageView *selectImage;
    BOOL isRefresh;
    NSInteger loadType;
    int pageNum;
    int lastPage;
//    UIImageView *caozuotishiImage;

}
@end

@implementation ShopDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(NSString *)dianpuId{
    return user_dianpuID;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isEvaluate = 1;
    isSelected = 0;
    pageNum = 0;
    isRefresh =1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    huodImageAry = [[NSArray alloc]init];
    huodTitleAry = [[NSArray alloc]init];
    shopMessageImgAry = [[NSArray alloc]init];
    detailDataAry = [[NSMutableArray alloc]init];
    evaluateDataAry = [[NSMutableArray alloc]init];
    secCellCount = 0;
    [self initNavigation];
    [self initTableView];
    [self getEvaluateData];
//    [self slidingSelectionView];
    [self judgeTheFirst];
}
-(void)judgeTheFirst
{
//    [self showGuideImageWithUrl:@"images/caozuotishi/shoucang.png"];

}
//初始化导航栏
-(void)initNavigation
{
    self.navigationItem.title = @"互动";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, NVbtnWight, NVbtnWight);
    [leftButton setImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [leftButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}


//获取数据
-(void)reloadData
{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":user_dianpuID}];
    [HTTPTool getWithBaseUrl:@"http://www.shp360.com/MshcShop/" url:@"findbyshequdianpuid.action" params:pram success:^(id json) {
        NSLog(@"店铺数据%@",json);
        
        NSDictionary *dic = [json valueForKey:@"shangpinlist"];
        shopDetailModel *modl = [[shopDetailModel alloc]init];
        [modl setValuesForKeysWithDictionary:dic];
        [detailDataAry addObject:modl];
        
        if (![modl.dianpudizhi isEqual:[NSNull null]]) {
            secCellCount = 2;
        }
        else
        {
            secCellCount = 1;
        }
        
        //活动title
        huodTitleAry = (NSArray *)[json valueForKey:@"tatlelist"];
        //活动图片
        huodImageAry = (NSArray *)[json valueForKey:@"tupianlist"];
        //店铺信息图片
        shopMessageImgAry = (NSArray *)[json valueForKey:@"dianpuxiangqing"];
        [shopDetailTabel reloadData];
        [self initTableHeald];

    } failure:^(NSError *error) {
        MBProgressHUD *bud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        bud.mode = MBProgressHUDModeCustomView;
        bud.labelText = @"网络连接错误";
        [bud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];

    }];
}
//初始化表格
-(void)initTableView
{

    
    shopDetailTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];

    shopDetailTabel.delegate = self;
    shopDetailTabel.dataSource = self;
    shopDetailTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    shopDetailTabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shopDetailTabel];
}

-(void)shopMessageBtnClick:(UIButton *)button
{
    shopMessageBtn.selected=NO;
    evaluateBtn.selected=NO;
    
//    [button setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
    if (button == shopMessageBtn) {
        isEvaluate = 0;
        shopMessageBtn.selected=YES;
        lineView.frame = CGRectMake(0, 38*MCscale, kDeviceWidth/2.0, 2);
        [self reloadData];
    }
    else
    {
        isEvaluate = 1;
        pageNum = 1;
        isRefresh =0;
        evaluateBtn.selected=YES;
        lineView.frame = CGRectMake(kDeviceWidth/2.0, 38*MCscale, kDeviceWidth/2.0, 2);
        [self getEvaluateData];
        [self refresh];
    }
    [shopDetailTabel reloadData];
}

#pragma mark 滑动选择发布或接收页面
//-(void)slidingSelectionView
//{
//    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipClick:)];
//    [leftSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:leftSwip];
//    
//    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipClick:)];
//    [rightSwip setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:rightSwip];
//}

//-(void)swipClick:(UISwipeGestureRecognizer *)swip
//{
//    if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
//        isEvaluate = 0;
//        [shopMessageBtn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
//        [evaluateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        lineView.frame = CGRectMake(0, 38*MCscale, kDeviceWidth/2.0, 2);
//        [self reloadData];
//    }
//    else
//    {
//        isEvaluate = 1;
//        pageNum = 1;
//        isRefresh =0;
//        [shopMessageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [evaluateBtn setTitleColor:txtColors(25, 182, 133, 1) forState:UIControlStateNormal];
//        lineView.frame = CGRectMake( kDeviceWidth/2.0, 38*MCscale, kDeviceWidth/2.0, 2);
//        [self getEvaluateData];
//        [self refresh];
//    }
//    [shopDetailTabel reloadData];
//}

#pragma 获取用户评价数据
-(void)getEvaluateData
{
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.mode = MBProgressHUDModeIndeterminate;
    mbHud.labelText = @"请稍后...";
    mbHud.delegate =self;
    [mbHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":user_dianpuID,@"leimu":[NSString stringWithFormat:@"%d",isSelected],@"pagemum":[NSString stringWithFormat:@"%d",pageNum]}];
    
    
    
    UIImageView * backView = [[UIImageView alloc]initWithFrame:shopDetailTabel.backgroundView.frame];
    backView.image=nil;
    shopDetailTabel.backgroundView=backView;
    
    [HTTPTool getWithBaseUrl:@"http://www.shp360.com/MshcShop/" url:@"findbyyonghupingjia.action" params:pram success:^(id json) {
        [mbHud hide:YES];
        NSLog(@"用户评价%@",json);
        
        if (isRefresh) {
            [self endRefresh:loadType];
        }
        if (lastPage == pageNum) {
            [evaluateDataAry removeAllObjects];
            
        }
        lastPage = pageNum;
        if ([[json valueForKey:@"massages"]integerValue] !=0) {
            NSArray *listArray = [json valueForKey:@"list"];
            for (NSDictionary *dict in listArray) {
                ShopEvaluateModel *evaluateModel = [[ShopEvaluateModel alloc]init];
                [evaluateModel setValuesForKeysWithDictionary:dict];
                [evaluateDataAry addObject:evaluateModel];
            }
        }else{
            backView.image=[UIImage imageNamed:@"互动为空"];
        }
        [shopDetailTabel reloadData];

    } failure:^(NSError *error) {
        [mbHud hide:YES];
        backView.image=[UIImage imageNamed:@"互动为空"];
        [self promptMessageWithString:@"网络连接错误1"];

    }];
    
//    [HTTPTool getWithUrlPath:HTTPHEADER AndUrl:@"findbyyonghupingjia.action" params:pram success:^(id json) {
//           } failure:^(NSError *error) {
//           }];
}

//表头
-(void)initTableHeald
{
    shopDetailModel *modl = detailDataAry[0];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 160)];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *shopLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 73*MCscale, 73*MCscale)];
    shopLogo.center = CGPointMake(kDeviceWidth/2.0, 46);
    [shopLogo sd_setImageWithURL:[NSURL URLWithString:modl.dianputupian] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    shopLogo.backgroundColor = [UIColor clearColor];
    [headView addSubview:shopLogo];
    UILabel *shopTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, shopLogo.bottom+5, kDeviceWidth, 20)];
    shopTitle.text = modl.dianpumingcheng;
    shopTitle.textAlignment = NSTextAlignmentCenter;
    shopTitle.textColor = textBlackColor;
    shopTitle.font = [UIFont systemFontOfSize:MLwordFont_4];
    shopTitle.backgroundColor = [UIColor clearColor];
    [headView addSubview:shopTitle];
    
    RatingView *rating = [[RatingView alloc]initWithFrame:CGRectMake(0, 0, 170*MCscale, 30*MCscale)];
    
    
    rating.ratingScore = [modl.pingja floatValue]*MCscale;
    if (rating.ratingScore==0) {
        rating.ratingScore=100;
    }
    
    
    rating.center = CGPointMake(kDeviceWidth/2.0, shopTitle.bottom+20);
    rating.backgroundColor = [UIColor clearColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 159*MCscale, kDeviceWidth, 1)];
    line.backgroundColor = lineColor;
    [headView addSubview:line];
    [headView addSubview:rating];
    
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    shopDetailTabel.tableHeaderView = headView;
}
#pragma mark -- UiTableViewDeldegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isEvaluate == 0) {
        return 3;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isEvaluate == 0) {
        if (section==0) {
            return secCellCount;
        }
        else if (section == 1){
            return huodTitleAry.count;
        }
        else{
            if (shopMessageImgAry.count>0) {
                if ([shopMessageImgAry[0] isEqualToString:@""]) {
                    return 0;
                }
                return shopMessageImgAry.count;
            }
            return 0;
        }
    }
    else
    {
        if (evaluateDataAry.count!=0) {
             return evaluateDataAry.count+1;
        }else{
            return 0;
        }
       
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEvaluate == 0) {
        NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        NSArray *imageArray1;
        if (secCellCount == 2) {
            imageArray1 = @[@"营业时间",@"地址"];
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
            image.tag = 101;
            image.backgroundColor = [UIColor clearColor];
            [cell addSubview:image];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectZero];
            title.tag = 102;
            title.backgroundColor = [UIColor clearColor];
            title.textAlignment = NSTextAlignmentLeft;
            title.textColor = textBlackColor;
            title.font = [UIFont systemFontOfSize:MLwordFont_6];
            [cell addSubview:title];
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.tag = 103;
            line.backgroundColor = lineColor;
            [cell addSubview:line];
        }
        UILabel *title = (UILabel *)[cell viewWithTag:102];
        UIImageView *imageDisplay = (UIImageView *)[cell viewWithTag:101];
        UIView *line = (UIView *)[cell viewWithTag:103];
        shopDetailModel *model = detailDataAry[0];
        if(indexPath.section == 0){
            if (secCellCount == 1) {
                imageDisplay.frame = CGRectMake(20, 13, 23*MCscale, 23*MCscale);
                imageDisplay.image = [UIImage imageNamed:@"营业时间"];
                title.frame = CGRectMake(imageDisplay.right+10*MCscale, 10, 300*MCscale, 30*MCscale);
                title.text = [NSString stringWithFormat:@"营业时间:上午%@ 下午%@",model.amtime,model.pmtime];
                line.frame = CGRectMake(0, title.bottom+9, kDeviceWidth, 1);
            }
            else
            {
                if(indexPath.row == 0){
                    imageDisplay.frame = CGRectMake(20, 13, 23*MCscale, 23*MCscale);
                    imageDisplay.image = [UIImage imageNamed:imageArray1[indexPath.row]];
                    title.frame = CGRectMake(imageDisplay.right+10*MCscale, 10, 300*MCscale, 30*MCscale);
                    title.text = [NSString stringWithFormat:@"营业时间:上午%@ 下午%@",model.amtime,model.pmtime];
                    line.frame = CGRectMake(0, title.bottom+9, kDeviceWidth, 1);
                }
                else if (indexPath.row == 1){
                    imageDisplay.frame = CGRectMake(20, 13, 23*MCscale, 23*MCscale);
                    imageDisplay.image =[UIImage imageNamed:imageArray1[indexPath.row]];
                    title.frame = CGRectMake(imageDisplay.right+10*MCscale, 10, 260, 30*MCscale);
                    title.text = [NSString stringWithFormat:@"地址:%@",model.dianpudizhi];
                }
            }
        }
        else if(indexPath.section == 1){
            imageDisplay.frame = CGRectMake(20, 13, 23*MCscale, 23*MCscale);
            [imageDisplay sd_setImageWithURL:[NSURL URLWithString:huodImageAry[indexPath.row]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
            title.frame = CGRectMake(imageDisplay.right+10*MCscale, 10, 260, 30*MCscale);
            title.text = [NSString stringWithFormat:@"%@",huodTitleAry[indexPath.row]];
            if (indexPath.row != huodTitleAry.count-1) {
                line.frame = CGRectMake(0, title.bottom+9, kDeviceWidth, 1);
            }
        }
        else{
            //            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shopMessageImgAry[indexPath.row]]];
            //            UIImage *image = [UIImage imageWithData:data];
            //            CGSize imgSize = image.size;
            
            imageDisplay.frame = CGRectMake(0, 0,kDeviceWidth, 200*MCscale);
            imageDisplay.center = CGPointMake(kDeviceWidth/2.0, 100*MCscale);
            [imageDisplay sd_setImageWithURL:[NSURL URLWithString:shopMessageImgAry[indexPath.row]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NSString *identifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        ShopEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ShopEvaluateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell reloadDataWithIndexPath:indexPath AndArray:evaluateDataAry];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        
        
        
        isSelected = !isSelected;
        ShopEvaluateCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (isSelected == 1) {
            cell.selectImage.image = [UIImage imageNamed:@"选中"];
        }
        else
        {
            cell.selectImage.image = [UIImage imageNamed:@"选择"];
        }
        [evaluateDataAry removeAllObjects];
        pageNum = 1;
        isRefresh =0;
        [self getEvaluateData];
        
        return;
    }
    
    
    if ([user_dianpu_banben isEqualToString:@"0"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"商铺权限暂不能操作评价回复" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    ReplyEvaluateView * reply = [ReplyEvaluateView new];
    __block ReplyEvaluateView * weakReply = reply;
    [reply appear];
    
    reply.block=^(NSString * string){
        ShopEvaluateModel *model = evaluateDataAry[indexPath.row-1];
                NSString * dingdanid = [NSString stringWithFormat:@"%@",model.dingdanid];
        
                NSDictionary * pram = @{@"id":dingdanid,
                                        @"content":string};
        
                [Request orderPingJiaWithDic:pram Success:^(id json) {
                    NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
                    if ([message isEqualToString:@"1"]) {
                        [weakReply disAppear];
                        [MBProgressHUD promptWithString:@"评价成功"];
                        [self getEvaluateData];
        
                    }else{
                        [MBProgressHUD promptWithString:@"评价失败"];
                    }
                } failure:^(NSError *error) {
                    
                }];

    };
    
//    ShopManagerAddAddAlter * alter = [ShopManagerAddAddAlter new];
//    __block ShopManagerAddAddAlter * weakAlter = alter;
//    
//    
//    UITextField * tf = [alter valueForKey:@"textField"];
//    UIButton    * btn = [alter valueForKey:@"submitBtn"];
//    tf.placeholder=@"请输入评价内容";
//    [btn setTitle:@"提交" forState:UIControlStateNormal];
//    [alter appear];
//    alter.block=^(NSString * string){
//       //    };

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (isEvaluate == 0) {
//        if (indexPath.section == 0 || indexPath.section == 1) {
//            return 50*MCscale;
//        }
//        return 190*MCscale;
//    }
//    else
//    {
        CGFloat cellHeight;
        if (indexPath.row == 0) {
            cellHeight = 40*MCscale;
        }
        else
        {
            ShopEvaluateModel *model = evaluateDataAry[indexPath.row-1];
            cellHeight = 80*MCscale;
            NSString *content =[NSString stringWithFormat:@"%@",model.neirong];
            NSLog(@"content  %@",content);
            
            if (![content isEqualToString:@"0"]) {
                CGSize size = [content boundingRectWithSize:CGSizeMake(360*MCscale,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
                cellHeight = cellHeight+ size.height +10*MCscale;
            }
            
            NSString *huifu =[NSString stringWithFormat:@"商家回复: %@",model.guanjia];
            if (![model.guanjia isEqualToString:@"0"]) {
                CGSize huifuSize = [huifu boundingRectWithSize:CGSizeMake(360*MCscale,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
                cellHeight = huifuSize.height+cellHeight+10*MCscale;
            }
            NSLog(@"%lf",cellHeight);
        }
        return cellHeight;
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isEvaluate == 0) {
        if (section == 0) {
            return CGFLOAT_MIN;
        }
        else
            return 8;
    }
    else
    {
        return 0*MCscale;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isEvaluate == 0) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 5)];
        headView.backgroundColor = txtColors(233, 234, 235, 1);
        return headView;
    }
    else
    {
        return nil;
    }
}
-(void)refresh
{
    //下拉刷新
    [shopDetailTabel addHeaderWithTarget:self action:@selector(headReFreshing)];
    //上拉加载
    [shopDetailTabel addFooterWithTarget:self action:@selector(footRefreshing)];
    shopDetailTabel.headerPullToRefreshText = @"下拉刷新数据";
    shopDetailTabel.headerReleaseToRefreshText = @"松开刷新";
    shopDetailTabel.headerRefreshingText = @"拼命加载中";
    shopDetailTabel.footerPullToRefreshText = @"上拉加载数据";
    shopDetailTabel.footerReleaseToRefreshText = @"松开加载数据";
    shopDetailTabel.footerRefreshingText = @"拼命加载中";
}
-(void)headReFreshing
{
    loadType = 0;
    isRefresh = 1;
    lastPage = 1;
    pageNum = 1;
    [self getEvaluateData];
}
-(void)footRefreshing
{
    isRefresh = 1;
    loadType = 1;
    pageNum ++;
    [self getEvaluateData];
}
-(void)endRefresh:(BOOL)success
{
    if (success) {
        [shopDetailTabel footerEndRefreshing];
    }
    else{
        [shopDetailTabel headerEndRefreshing];
    }
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    sleep(2);
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSNotification *daohanglanHidden = [NSNotification notificationWithName:@"daohanglanHidden" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:daohanglanHidden];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"daohanglanHidden" object:nil];
}
@end
