//
//  XuFeiViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/23.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "XuFeiViewController.h"
#import "SelectFuWuFeiBanBen.h"
#import "TopUpView.h"

@interface XuFeiViewController ()
@property (nonatomic,assign)NSInteger loadCount;


@property (nonatomic,strong)UILabel        * titleLabel;
@property (nonatomic,strong)NSString       * fuWudate;
@property (nonatomic,strong)NSMutableArray * datas;

@property (nonatomic,strong)UIScrollView * mainScroll;


@property (nonatomic,assign)NSInteger selectedIndex;
@end

@implementation XuFeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"配置延期";
    [self initData];
    [self reshData];
//    SelectFuWuFeiBanBen * sele = [SelectFuWuFeiBanBen new];
//    [sele appear];
    
    // Do any additional setup after loading the view.
}
-(void)initData{
    _selectedIndex=100;
}
-(void)reshData{
 
    _loadCount = 0;
    [Request getFuWuYouXiaoQiWithDic:@{} success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"1"]) {
            _fuWudate = [NSString stringWithFormat:@"%@",[json valueForKey:@"enddate"]];
            _loadCount++;
            if (_loadCount==2) {
                [self newView];
            }
            
        }
    } failure:^(NSError *error) {
    }];
    
    
    [Request getFuWuDateListWithDic:@{} success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"1"]) {
            _datas = [json valueForKey:@"priceInfo"];
        
            _loadCount++;
            if (_loadCount==2) {
                [self newView];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
//    _fuWudate = @"2014-2-3";
//    _datas = [NSMutableArray array];
//    [_datas addObject:@{@"title":@"一个月"}];
//    [_datas addObject:@{@"title":@"一个月"}];
//    [_datas addObject:@{@"title":@"一个月"}];
//    [_datas addObject:@{@"title":@"一个月"}];
//    [_datas addObject:@{@"title":@"一个月"}];
//    [_datas addObject:@{@"title":@"一个月"}];
//    [self newView];
    

}
-(void)newView{
    _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:_mainScroll];
    
    
    CGFloat setY = 100*MCscale;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 20*MCscale)];
    titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    titleLabel.textColor=redTextColor;
    titleLabel.text=[NSString stringWithFormat:@"服务有效期:%@",_fuWudate];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [_mainScroll addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    setY =titleLabel.bottom+10*MCscale;
    

    
    CGFloat bX = 0;
    CGFloat bW = self.view.width;
    CGFloat bH = 40*MCscale;
    for (int i = 0 ; i < _datas.count; i ++) {
        
        NSDictionary * dic = _datas[i];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(bX, setY, bW, bH)];
        [_mainScroll  addSubview:btn];
        [btn setTitleColor:textBlackColor forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        
        UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*MCscale, 0, 110, 20)];
        [leftBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
        leftBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
        [leftBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [leftBtn setTitle:[NSString stringWithFormat:@"   %@个月",dic[@"month"]] forState:UIControlStateNormal];
        leftBtn.userInteractionEnabled=NO;
        [btn addSubview:leftBtn];
        leftBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
        leftBtn.centerY=btn.height/2;
        
        
        
        
        UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        rightLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
        rightLabel.textColor=textBlackColor;
        rightLabel.textAlignment=NSTextAlignmentRight;
        [btn addSubview:rightLabel];
        rightLabel.text=[NSString stringWithFormat:@"%@元",dic[@"price"]];
        rightLabel.centerY=btn.height/2;
        rightLabel.right=btn.width-20*MCscale;
        

        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, btn.width, 1)];
        line.bottom=btn.height;
        line.backgroundColor=lineColor;
        [btn addSubview:line];
        
        
        setY=btn.bottom;
    }

    UIButton * submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20*MCscale, setY+20*MCscale, _mainScroll.width-40*MCscale, 40*MCscale)];
    submitBtn.backgroundColor=redTextColor;
    [submitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius=5;
    submitBtn.layer.masksToBounds=YES;
    [_mainScroll addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    setY=submitBtn.bottom;
}
-(void)btnClick:(UIButton *)sender{

    
    
    for (int i = 0; i < _datas.count ; i ++) {
        UIButton * btn = [_mainScroll viewWithTag:i+100];
        btn.selected=NO;
        
        for (UIButton * subBtn  in btn.subviews) {
            if ([subBtn isKindOfClass:[UIButton class]]) {
                subBtn.selected=btn.selected;
            }
        }
    }
    
    
    
    sender.selected=!sender.selected;
    _selectedIndex=sender.tag-100;
    for (UIButton * subBtn  in sender.subviews) {
        if ([subBtn isKindOfClass:[UIButton class]]) {
            subBtn.selected=sender.selected;
        }
    }
    
    [self reshTitleLabel];

    
}
-(void)reshTitleLabel{
    NSDate * date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd";
    if ([_fuWudate isEqualToString:@"0"]) {
        date = [NSDate date];
    }else{
        date = [formatter dateFromString:_fuWudate];
    }
    
    NSInteger month;
    if (_selectedIndex==100) {
        month=0;
    }else{

        NSDictionary * dic = _datas[_selectedIndex];
        NSString * monthString = [NSString stringWithFormat:@"%@",dic[@"month"]];
        month=[monthString integerValue];
    }

    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:month];
    [adcomps setDay:0];
    NSDate * newDate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    
   NSString * newDateString = [formatter stringFromDate:newDate];
    
    _titleLabel.text=[NSString stringWithFormat:@"服务有效期:%@",newDateString];
    
}
-(void)submitBtnClick:(UIButton *)sender{
    if (_selectedIndex==100) {
        [MBProgressHUD promptWithString:@"请选择服务选项"];
        return;
    }
    
    NSDictionary * dic = _datas[_selectedIndex];
    float price = [[dic valueForKey:@"price"] floatValue];
    NSString * month = [dic valueForKey:@"month"];
    
    TopUpView * top = [TopUpView new];
    __block TopUpView * weaktop = top;
    
    [top setMoney:price limitMoney:0 title:[NSString stringWithFormat:@"妙店佳商铺+%@开户",user_tel] body:user_Id canChange:NO];
    [top appear];
    top.payBlock=^(BOOL isSuccess){
        if (isSuccess) {
            NSDictionary * pram = @{@"dianpu.id":user_dianpuID,
                                    @"month":month};
            [Request dianPuXuFeiWithDic:pram success:^(id json) {
                NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                if ([message isEqualToString:@"1"]) {
                    [MBProgressHUD promptWithString:@"续费成功"];
                    [weaktop disAppear];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else
                {
                    [MBProgressHUD promptWithString:@"续费失败"];
                }
            } failure:^(NSError *error) {
                
            }];
        }else{
            [MBProgressHUD promptWithString:@"支付失败"];
        }
    };
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
