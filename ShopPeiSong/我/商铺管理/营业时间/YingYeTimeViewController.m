//
//  YingYeTimeViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/20.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "YingYeTimeViewController.h"
#import "Header.h"
#import "CellView.h"
#import "DatePickerView.h"



@interface YingYeTimeViewController ()
@property (nonatomic,strong)NSMutableDictionary * dataDic;

@end

@implementation YingYeTimeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    
    // Do any additional setup after loading the view.
}
-(void)initData{
    _dataDic =[NSMutableDictionary dictionary];
}
-(void)newNavi{
    
    
    //    SuperNavigationView * navi = [SuperNavigationView new];
    //    [self.view addSubview:navi];
    
    
    
    
    
}
-(void)newView{
    self.navigationItem.title=@"营业时间";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    CGFloat setY = 64;
    for (int i =0; i < 2; i ++) {
        
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, setY, kDeviceWidth, 100)];
        [self.view addSubview:backView];
        backView.backgroundColor=[UIColor whiteColor];
        
        CGFloat BsetY = 0;
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, BsetY, backView.width, 20)];
        headerView.backgroundColor=lineColor;
        [backView addSubview:headerView];
        BsetY = headerView.bottom;
        
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, BsetY+10, 120, 25)];
        [backView addSubview:titleLabel];
        titleLabel.font=[UIFont systemFontOfSize:MLwordFont_3];
        titleLabel.textColor=textBlackColor;
        titleLabel.text=i==0?@"上午营业时间":@"下午营业时间";
        BsetY =titleLabel.bottom;
        
        
        CellView * cellView = [[CellView alloc]initWithFrame:CGRectMake(10, BsetY+10, backView.width-20, 40)];
        [cellView addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backView addSubview:cellView];
        cellView.titleTF.placeholder=@"开始时间";
        cellView.rightImg.image=[UIImage imageNamed:@"xialas"];
        BsetY = cellView.bottom;
        cellView.titleTF.enabled=NO;
        
        
        
        CellView * cellView1 = [[CellView alloc]initWithFrame:CGRectMake(10, BsetY+10, backView.width-20, 40)];
        [cellView1 addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:cellView1];
        cellView1.titleTF.placeholder=@"结束时间";
        cellView1.rightImg.image=[UIImage imageNamed:@"xialas"];
        BsetY = cellView1.bottom;
        cellView1.titleTF.enabled=NO;
        
        backView.height= BsetY +10;
        setY = backView.bottom;
        
        cellView.tag=i==0?100:102;
        cellView1.tag=i==0?101:103;
    }
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(10*MCscale, setY+40*MCscale, kDeviceWidth-20*MCscale, 50*MCscale);
    saveBtn.backgroundColor = txtColors(249, 54, 73, 1);
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 5.0;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

-(void)reshData{
    NSDictionary * pram= @{@"id":user_dianpuID};
    
  [Request getDianPuYingYeShiJianWithDic:pram Success:^(id json) {
      NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
      if ([message isEqualToString:@"1"]) {
          
          [_dataDic removeAllObjects];
          [_dataDic addEntriesFromDictionary:[NSDictionary dictionaryWithDictionary:json]];
          [self reshView];
      }else{
          [MBProgressHUD promptWithString:@"获取失败"];
      }
  } failure:^(NSError *error) {
      
  }];
}
-(void)reshView{
    CellView * amQ = [self.view viewWithTag:100];
    CellView * amZ = [self.view viewWithTag:101];
    CellView * pmQ = [self.view viewWithTag:102];
    CellView * pmZ = [self.view viewWithTag:103];
    
    
    NSString * amQst = [NSString stringWithFormat:@"%@",_dataDic[@"ama"]];
    NSString * amZst = [NSString stringWithFormat:@"%@",_dataDic[@"amb"]];
    NSString * pmQst = [NSString stringWithFormat:@"%@",_dataDic[@"pma"]];
    NSString * pmZst = [NSString stringWithFormat:@"%@",_dataDic[@"pmb"]];
    amQst=[amQst isEmptyString]?@"请选择时间":amQst;
    amZst=[amZst isEmptyString]?@"请选择时间":amZst;
    pmQst=[pmQst isEmptyString]?@"请选择时间":pmQst;
    pmZst=[pmZst isEmptyString]?@"请选择时间":pmZst;
    
    amQ.contentLabel.text=amQst;
    amZ.contentLabel.text=amZst;
    pmQ.contentLabel.text=pmQst;
    pmZ.contentLabel.text=pmZst;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- btnCLick
-(void)saveBtnClick:(UIButton *)sender{
    CellView * amQ = [self.view viewWithTag:100];
    CellView * amZ = [self.view viewWithTag:101];
    CellView * pmQ = [self.view viewWithTag:102];
    CellView * pmZ = [self.view viewWithTag:103];
    
    if ([amQ.contentLabel.text isEqualToString:@"请选择时间"]) {
        [MBProgressHUD promptWithString:@"请选择上午营业开始时间"];
        return;
    }
    if ([amZ.contentLabel.text isEqualToString:@"请选择时间"]) {
         [MBProgressHUD promptWithString:@"请选择上午营业结束时间"];
        return;
    }
    if ([pmQ.contentLabel.text isEqualToString:@"请选择时间"]) {
         [MBProgressHUD promptWithString:@"请选择下午营业开始时间"];
        return;
    }
    if ([pmZ.contentLabel.text isEqualToString:@"请选择时间"]) {
         [MBProgressHUD promptWithString:@"请选择下午营业结束时间"];
        return;
    }
    

    NSDictionary * pram = @{@"id":user_dianpuID,
                            @"dianpu.yingyetime_ama":amQ.contentLabel.text,
                            @"dianpu.yingyetime_amb":amZ.contentLabel.text,
                            @"dianpu.yingyetime_pma":pmQ.contentLabel.text,
                            @"dianpu.yingyetime_pmb":pmZ.contentLabel.text};

    [Request alterDianPuYingYeShiJianWithDic:pram Success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
        if ([message isEqualToString:@"1"]) {
            [MBProgressHUD promptWithString:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD promptWithString:@"修改失败"];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 时间
-(void)timeBtnClick:(CellView *)sender{
    DatePickerView * datpick = [DatePickerView new];
    [datpick appear];
    datpick.block=^(NSString * timeString){
        sender.contentLabel.text=timeString;
    };
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
