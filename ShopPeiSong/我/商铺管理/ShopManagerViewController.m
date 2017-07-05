//
//  ShopManagerViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/19.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "ShopManagerViewController.h"

#import "Header.h"
#import "PersonTableViewCell.h"

#import "SuperNavigationView.h"
#import "PHMap.h"


#import "XuFeiViewController.h"
#import "ShengJiViewController.h"

#import "DianPuXinXiViewController.h"
#import "YingYeTimeViewController.h"
#import "DianPuErWeiMaViewController.h"
#import "ShouKuanErWeiMaViewController.h"

@interface ShopManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *   数据属性
 */
@property (nonatomic,strong)NSArray * tableContentArray;

@property (nonatomic,strong)NSMutableDictionary * dataDic;

/**
 *  视图属性
 */


@property (nonatomic,strong)SuperNavigationView * navi;

@property (nonatomic,strong)UIView * tableHeaderView;

@property (nonatomic,strong)UITableView * mainTableView;
@end

@implementation ShopManagerViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    [self reshData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshView];
    
    // Do any additional setup after loading the view.
}

-(void)initData{
    
    _dataDic = [NSMutableDictionary dictionary];
    _tableContentArray = @[@[@{@"img":@"我_商铺",@"title":@"权限配置",@"controller":@"noPush_peizhi"}],
                           @[@{@"img":@"商铺_店铺二维码",@"title":@"店铺二维码",@"controller":NSStringFromClass([DianPuErWeiMaViewController class])},
                           @{@"img":@"商铺_营业时间",@"title":@"营业时间",@"controller":NSStringFromClass([YingYeTimeViewController class])},
                           @{@"img":@"商铺_二维码收款",@"title":@"二维码收款",@"controller":NSStringFromClass([ShouKuanErWeiMaViewController class])},
                           @{@"img":@"商铺_现场定位",@"title":@"现场定位",@"controller":@"noPush_dingwei"},
                           @{@"img":@"商铺_帮助视频",@"title":@"帮助视频",@"controller":@"noPush_shipin"}]
                           ];

}
-(void)newNavi{
    self.hidesBottomBarWhenPushed=YES;
    
    SuperNavigationView * navi = [[SuperNavigationView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    [navi.titleView setTitle:@"商铺" forState:UIControlStateNormal];
    [navi.rightBtn setTitle:@"" forState:UIControlStateNormal];
    navi.block=^(NSInteger index){
        if (index == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    
    [self.view addSubview:navi];
    navi.backgroundColor=naviBarTintColor;
    _navi = navi;

}

-(void)newView{
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, self.view.height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableView];
    _mainTableView.tableHeaderView=[self tableHeaderView];
    _mainTableView.tableFooterView=[self tableViewFooterView];
    [_mainTableView registerClass:[PersonTableViewCell class] forCellReuseIdentifier:@"cell"];
    _mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _mainTableView.delegate=self;
    _mainTableView.dataSource=self;
}
-(void)reshData{
    NSDictionary * pram = @{@"id":user_dianpuID,
                            @"userid":user_Id};
    
    [_dataDic removeAllObjects];
    [Request getDianPuInfoWithDic:pram Success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
        if ([message isEqualToString:@"1"]) {
 
            [_dataDic addEntriesFromDictionary:[NSDictionary dictionaryWithDictionary:json]];
           
        }else{
            [MBProgressHUD promptWithString:@"获取失败"];
        }
         [self reshView];
    } failure:^(NSError *error) {
         [self reshView];
    }];}
-(void)reshView{
    
//    [_mainTableView reloadData];
//    UIImageView * headImg = [self.view viewWithTag:100];
//    UILabel     * nameLabel = [self.view viewWithTag:101];
//    CellView    * phoneCell = [self.view viewWithTag:102];
//    CellView    * addressCell = [self.view viewWithTag:103];
//    CellView    * gonggaoCell = [self.view viewWithTag:104];
//    CellView    * neirongCell = [self.view viewWithTag:105];
    
    NSString * headLink = [NSString stringWithFormat:@"%@",_dataDic[@"logo"]];

    
   
    NSString * nameSt = [NSString stringWithFormat:@"%@",_dataDic[@"dinapuname"]];
    nameSt = [nameSt isEmptyString]?@"点击进行编辑":nameSt;
    
    
    NSString * teseSt = [NSString stringWithFormat:@"%@",_dataDic[@"tese"]];
    teseSt = [teseSt isEmptyString]?@"点击编辑经营范围":teseSt;
    
    
    NSString * gonggaoSt = [NSString stringWithFormat:@"%@",_dataDic[@"gonggao"]];
    gonggaoSt = [gonggaoSt isEmptyString]?@"点击编辑店铺公告":gonggaoSt;

    set_User_Logo(headLink);
    
    
    UIImageView * headerView = [_tableHeaderView viewWithTag:100];
    UILabel * headerLable = [_tableHeaderView viewWithTag:101];
    
    headerView.image = [UIImage imageWithUrl:headLink placeholderImageName:@"yonghutouxiang"];
//    [headerView sd_setImageWithURL:[NSURL URLWithString:headLink] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
//    headerView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:headLink]]];
    
    NSMutableAttributedString * attriHeaderLable = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@\n%@",nameSt,teseSt,gonggaoSt]];
    headerLable.attributedText =attriHeaderLable;
    
    headerLable.centerY=headerView.centerY;
  
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- tableview
-(UIView*)tableHeaderView{
    UIButton * backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 90*MCscale)];
    backView.backgroundColor=naviBarTintColor;
    [backView addTarget:self action:@selector(skipToDianPuXinXi) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80*MCscale, 80*MCscale)];
    [backView addSubview:headImg];
    headImg.centerY=backView.height/2;
    headImg.centerX=backView.width*0.2;
    headImg.tag=100;
    headImg.layer.cornerRadius=8;
    headImg.layer.masksToBounds=YES;
    
    UILabel * content = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+20, headImg.top, kDeviceWidth, headImg.height)];
    content.textColor=textBlackColor;
    content.font=[UIFont systemFontOfSize:MLwordFont_4];
    [backView addSubview:content];
    content.centerY=headImg.centerY;
    content.numberOfLines=3;
    content.tag=101;
    
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, backView.height)];
    rightView.right=backView.width;
    rightView.backgroundColor=backView.backgroundColor;
    [backView addSubview:rightView];
    
    
    _tableHeaderView = backView;
    return _tableHeaderView;
}
-(UIView *)tableViewFooterView{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
//    backView.backgroundColor=[UIColor redColor];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth*0.1 , 10, backView.width*0.8 , 100)];
    [backView addSubview:label];
    label.textColor=txtColors(72, 73, 74, 0.5);
    
    
    label.font=[UIFont systemFontOfSize:MLwordFont_3];
    label.numberOfLines=0;
    
    [HTTPTool getWithBaseUrl:HTTPHEADER url:@"Zonghe_xitongcanshu.action" params:[NSMutableDictionary dictionary] success:^(id json) {
        
        
        label.text = [NSString stringWithFormat:@"        %@",[json valueForKey:@"shuoming"]];
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    return backView;
}

#pragma mark -- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * cellArray = _tableContentArray[section];
    
    return  cellArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tableContentArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSArray * cellArray = _tableContentArray[indexPath.section];
    NSDictionary * cellDic = cellArray[indexPath.row];
    
    cell.leftImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[cellDic valueForKey:@"img"]]];
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[cellDic valueForKey:@"title"]];
    cell.rightImg.image=[UIImage imageNamed:@"xialas"];
    
    cell.bottomLine.hidden=indexPath.row==cellArray.count-1;
    
    if  (indexPath.section==0 && indexPath.row==0) {
        if ([user_dianpu_banben isEqualToString:@"0"]) {
            cell.contentLabel.text = @"基本";
        }else if ([user_dianpu_banben isEqualToString:@"1"]){
            cell.contentLabel.text = @"高级";
        }else if ([user_dianpu_banben isEqualToString:@"2"]){
            cell.contentLabel.text = @"通用";
        }
        cell.contentLabel.textColor=redTextColor;
    }
    

    //    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[cellDic valueForKey:@"img"]]];
    //    cell.textLabel.text= [NSString stringWithFormat:@"%@",[cellDic valueForKey:@"title"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * cellArray = _tableContentArray[indexPath.section];
    NSDictionary * cellDic = cellArray[indexPath.row];
    NSString * controllerString = [NSString stringWithFormat:@"%@",[cellDic valueForKey:@"controller"]];
    if ([controllerString hasPrefix:@"noPush"]) {
        if ([controllerString hasSuffix:@"dingwei"]) {
            if ([user_BuMen isEqualToString:@"管理"]) {
                 [self upDateLocation];
            }else{
                [MBProgressHUD promptWithString:@"自有管理人员才能定位"];
                return;
            }
            

        }
        if ([controllerString hasSuffix:@"shipin"]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.shp360.com/kaihuvideo.jsp"]];
        }
        if ([controllerString hasSuffix:@"peizhi"]) {
            if ([user_dianpu_banben isEqualToString:@"2"]) {
                XuFeiViewController * xufei = [XuFeiViewController new];
                xufei.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:xufei animated:YES];
            }else{
                ShengJiViewController * shengji = [ShengJiViewController new];
                shengji.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:shengji animated:YES];
            }
   
            
        }
        
    }else{
        UIViewController * controller = [NSClassFromString(controllerString) new];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
    
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offY = self.mainTableView.contentOffset.y;
    
    if (offY<0) {
        _navi.height=64-offY;
        [self.view bringSubviewToFront:_navi];
    }else{
        [self.view sendSubviewToBack:_navi];
    }
}


#pragma mark -- btnClick
-(void)skipToDianPuXinXi{
    [self.navigationController pushViewController:[DianPuXinXiViewController new] animated:YES];
}

-(void)upDateLocation{
    PHMapHelper * mapHelper  = [PHMapHelper new];
    [mapHelper configBaiduMap];
    
    

    [mapHelper locationStartLocation:^{
        NSLog(@"开始定位");
    } locationing:^(BMKUserLocation *location, NSError *error) {
       
        
        [mapHelper regeoWithLocation:CLLocationCoordinate2DMake(location.location.coordinate.latitude, location.location.coordinate.longitude) block:^(BMKReverseGeoCodeResult *result, BMKSearchErrorCode error) {
            if (error) {
                return ;
            }
            
           
            NSDictionary * pram = @{@"dianpu.id":user_dianpuID,
                                    @"dianpu.x":[NSString stringWithFormat:@"%f",location.location.coordinate.longitude],
                                    @"dianpu.y":[NSString stringWithFormat:@"%f",location.location.coordinate.latitude],
                                    @"code":result.addressDetail.city};
            
            
            [MBProgressHUD start];
            [Request updateLocationWithDic:pram Success:^(id json) {
                 [MBProgressHUD stop];
                if ([[NSString stringWithFormat:@"%@",[json valueForKey:@"message"]] isEqualToString:@"1"]) {
                    [MBProgressHUD promptWithString:@"定位修改成功"];
                }
                else{
                    [MBProgressHUD promptWithString:@"定位修改失败"];
                }
                
               
            } failure:^(NSError *error) {
                 [MBProgressHUD stop];
            }];
        }];
        
        
        [mapHelper endLocation];
    } stopLocation:^{
        
    }];

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
