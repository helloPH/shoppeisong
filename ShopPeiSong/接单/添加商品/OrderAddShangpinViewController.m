

//
//  OrderAddShangpinViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/13.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "OrderAddShangpinViewController.h"
#import "ReviewSelectedView.h"
#import "ShangpinMessagesModel.h"
#import "OrderAddShangpinCell.h"
#import "GoodDetailViewController.h"

#import "Header.h"
@interface OrderAddShangpinViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,ReviewSelectedViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIButton *fenleiBtn,*leftButton,*searchBtn;
@property(nonatomic,strong)UIView  *lineView,*line1,*line2,*backView;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UILabel *nameLabel,*priceLabel,*fujiaLabel;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *shangpinArray;
@property(nonatomic,strong)ReviewSelectedView *selectedView;
@property(nonatomic,strong)UIView *maskView;


@property(nonatomic,strong)NSMutableArray * addGoodsArray;
@end

@implementation OrderAddShangpinViewController
-(void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
    [self getShangpinMessagesData];
    [self setNavigationItem];
    
    [self initData];
}
-(void)initData{
    _addGoodsArray= [NSMutableArray array];
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}


#pragma mark 设置 导航栏
-(void)setNavigationItem
{
    [self.navigationItem setTitle:self.dianpuName];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
  
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_block) {
        _block(_hasGoodArray);
    }
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
-(ReviewSelectedView *)selectedView
{
    if (!_selectedView) {
        _selectedView = [[ReviewSelectedView  alloc]initWithFrame:CGRectMake(60*MCscale,230*MCscale, kDeviceWidth - 120*MCscale, 240*MCscale)];
        _selectedView.selectedDelegate = self;
    }
    return _selectedView;
}
-(UIButton *)fenleiBtn
{
    if (!_fenleiBtn) {
        _fenleiBtn = [BaseCostomer buttonWithFrame:CGRectMake(20*MCscale, 20*MCscale+64,80*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textColors backGroundColor:txtColors(236, 236, 236, 1) cornerRadius:0 text:@"分类" image:@""];
        [_fenleiBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_fenleiBtn];
    }
    return _fenleiBtn;
}

-(UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [BaseCostomer textfieldWithFrame:CGRectMake(self.fenleiBtn.right +10*MCscale, self.fenleiBtn.top,180*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors textAlignment:1 keyboardType:0 borderStyle:0 placeholder:@"请输入商品名称"];
        _nameTextField.delegate = self;
        _nameTextField.returnKeyType = UIReturnKeyDone;
        [self.view addSubview:self.nameTextField];
    }
    return _nameTextField;
}
-(UIView *)line1
{
    if (!_line1) {
        _line1 = [BaseCostomer viewWithFrame:CGRectMake(self.nameTextField.left-5,self.nameTextField.bottom-2, 1, 3) backgroundColor:txtColors(25, 182, 133, 1)];
        [self.view addSubview:_line1];
    }
    return _line1;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectMake(self.line1.right,self.nameTextField.bottom, self.nameTextField.width +10*MCscale,1) backgroundColor:txtColors(25, 182, 133, 1)];
        [self.view addSubview:_lineView];
    }
    return _lineView;
}
-(UIView *)line2
{
    if (!_line2) {
        _line2 = [BaseCostomer viewWithFrame:CGRectMake(self.lineView.right,self.nameTextField.bottom-2, 1, 3) backgroundColor:txtColors(25, 182, 133, 1)];
        [self.view addSubview:_line2];
    }
    return _line2;
}

-(UIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [BaseCostomer buttonWithFrame:CGRectMake(self.line2.right +10*MCscale, self.nameTextField.top+3*MCscale,25*MCscale,25*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textColors backGroundColor:[UIColor clearColor] cornerRadius:0 text:@"" image:@"searchicons"];
        [_searchBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_searchBtn];
    }
    return _searchBtn;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [BaseCostomer labelWithFrame:CGRectMake(10*MCscale, 0,kDeviceWidth-200*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"名称"];
    }
    return _nameLabel;
}
-(UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [BaseCostomer labelWithFrame:CGRectMake(self.nameLabel.right +5*MCscale, 0,50*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"现价"];
    }
    return _priceLabel;
}
-(UILabel *)fujiaLabel
{
    if (!_fujiaLabel) {
        _fujiaLabel = [BaseCostomer labelWithFrame:CGRectMake(self.priceLabel.right+5*MCscale,0,50*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"状态"];
    }
    return _fujiaLabel;
}

-(UIView *)backView
{
    if (!_backView) {
        _backView = [BaseCostomer viewWithFrame:CGRectMake(0, self.searchBtn.bottom+20*MCscale, kDeviceWidth, 30*MCscale) backgroundColor:txtColors(236, 236, 236, 1)];
        [self.view addSubview:_backView];
        [_backView addSubview:self.nameLabel];
        [_backView addSubview:self.priceLabel];
        [_backView addSubview:self.fujiaLabel];
    }
    return _backView;
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.backView.bottom, kDeviceWidth, kDeviceHeight - 64-100*MCscale) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}
-(NSMutableArray *)shangpinArray
{
    if (!_shangpinArray) {
        _shangpinArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _shangpinArray;
}
#pragma mark 获得商品信息
-(void)getShangpinMessagesData
{
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":self.dianpuID}];
    [self getShangpinMessagesWithUrl:@"enterDianpu.action" AndDict:pram AndIndex:1];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shangpinArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    OrderAddShangpinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OrderAddShangpinCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    


    [cell reloadDataWithIndexPath:indexPath AndArray:self.shangpinArray];
    cell.addBtnBlock=^(NSIndexPath *indexPath){
      //添加商品
        //获取商品id
        NSString * goodsId = [NSString stringWithFormat:@"%@",((ShangpinMessagesModel *)(_shangpinArray[indexPath.row])).shangpinid];
        [self addGooWithId:goodsId];
    };
    return cell;
}
-(void)addGooWithId:(NSString *)goodsId{
    [Request getGoodsInfoWithDic:@{@"shop.id":goodsId} success:^(id json) {
        if ([[NSString stringWithFormat:@"%@",[json valueForKey:@"message"]] isEqualToString:@"2"]) {
            [self addGoodWithDic:[json objectForKey:@"shop"]];
        }else{
            [MBProgressHUD promptWithString:@"获取商品信息失败"];
        }
    } failure:^(NSError *error) {
    }];
}
-(void)addGoodWithDic:(NSDictionary *)dic{


    BOOL hasContain=NO;
    
    NSMutableArray * goodsArr = _hasGoodArray;
    
    for (int i = 0; i < goodsArr.count; i ++) {
        NSMutableDictionary * indexDic = [NSMutableDictionary dictionaryWithDictionary:(_hasGoodArray[i])];
        if ([[NSString stringWithFormat:@"%@",indexDic[@"shopid"]] isEqualToString:[NSString stringWithFormat:@"%@",dic[@"id"]]]) {//如果商品存在
            hasContain=YES;
            // 修改 数量
            NSString * count = [indexDic valueForKey:@"shuliang"];
            count = [NSString stringWithFormat:@"%.2f",[count floatValue]+1];
//            [indexDic setObject:count forKey:@"shuliang"];// 商品数量加一
            [indexDic setObject:count forKey:@"shuliang"];
            
            // 修改总价
            NSString * jiage = [indexDic valueForKey:@"xianjia"];
            float  totalMoney = [jiage floatValue]*[count floatValue];
            [indexDic setValue:[NSString stringWithFormat:@"%.2f",totalMoney] forKey:@"total_money"];
            
            [_hasGoodArray replaceObjectAtIndex:i withObject:indexDic];
        };
    }
    if (!hasContain) {
        NSDictionary * currentDic = @{
                                      @"fujiafei_money":[NSString stringWithFormat:@"%@",dic[@"fujiafeiyong_money"]],
                                      @"fujiafeishop":[NSString stringWithFormat:@"%@",dic[@"fujiafeiyong_name"]],
                                      @"jiage":[NSString stringWithFormat:@"%@",dic[@"yuanjia"]],
                                      @"shopid":[NSString stringWithFormat:@"%@",dic[@"id"]],
                                      @"shopimg":[NSString stringWithFormat:@"%@",dic[@"canpinpic"]],
                                      @"shopname":[NSString stringWithFormat:@"%@",dic[@"shangpinname"]],
                                      @"shuliang":@"1",
                                      @"total_money":[NSString stringWithFormat:@"%@",dic[@"xianjia"]],
                                      @"xianjia":[NSString stringWithFormat:@"%@",dic[@"xianjia"]],
                                      @"xinghao":[NSString stringWithFormat:@"%@",dic[@"0"]],
                                      @"yanse":@"0",
                                      };
        [_hasGoodArray addObject:[NSMutableDictionary dictionaryWithDictionary:currentDic]];
    }
    [MBProgressHUD promptWithString:@"商品添加成功"];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShangpinMessagesModel * model = _shangpinArray[indexPath.row];
    
    NSString * goodId = model.shangpinid;
    
    GoodDetailViewController *goodDetail = [[GoodDetailViewController alloc]init];
    goodDetail.goodId = goodId;
    goodDetail.ViewTag = 1;
    goodDetail.hasGoodArray=self.hasGoodArray;
    goodDetail.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:goodDetail animated:YES];
    goodDetail.block=^(NSMutableArray * hasGoodArray){
        _hasGoodArray=hasGoodArray;
    };
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*MCscale;
}

#pragma mark 选择商品类别
-(void)selectedLeixingWithString:(NSString *)string
{
    [self maskViewDisMiss];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":self.dianpuID,@"leibie":string}];
    [self getShangpinMessagesWithUrl:@"getDianpuShopByLeibie.action" AndDict:pram AndIndex:2];
}
-(void)getShangpinMessagesWithUrl:(NSString *)url AndDict:(NSMutableDictionary *)pram AndIndex:(NSInteger )index
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    [HTTPTool postWithUrl:url params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"商品信息 %@",json);
        if (index == 1) {
            if ([[json valueForKey:@"message"]integerValue]==0) {
                [self promptMessageWithString:@"无可显示商品"];
            }
            else
            {
                [self.shangpinArray removeAllObjects];
                NSArray *shangpinList = [json valueForKey:@"shangpinList"];
                for (NSDictionary *dict in shangpinList) {
                    
           
                    
                    ShangpinMessagesModel *model = [[ShangpinMessagesModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.shangpinArray addObject:model];
                }
            }
        }
        else if(index  == 2){
            if ([[json valueForKey:@"message"]integerValue]==3) {
                [self promptMessageWithString:@"无可显示商品"];
            }
            else if ([[json valueForKey:@"message"]integerValue]==2)
            {
                [self promptMessageWithString:@"参数不能为空"];
            }
            else
            {
                [self.shangpinArray removeAllObjects];
                NSArray *shangpinList = [json valueForKey:@"shoplist"];
                for (NSDictionary *dict in shangpinList) {
                  
                    
                    ShangpinMessagesModel *model = [[ShangpinMessagesModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.shangpinArray addObject:model];
                }
            }
        }
        else if (index == 3)
        {
            
            if ([[json valueForKey:@"message"]integerValue]==1) {
                [self.shangpinArray removeAllObjects];
                
                self.mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索无数据"]];
            }
            else if ([[json valueForKey:@"message"]integerValue]==0)
            {
                [self promptMessageWithString:@"参数不能为空"];
            }
            else
            {
                [self.shangpinArray removeAllObjects];
                
                self.mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
                
                NSArray *shangpinList = [json valueForKey:@"listShangpin"];
                for (NSDictionary *dict in shangpinList) {
                    ShangpinMessagesModel *model = [[ShangpinMessagesModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.shangpinArray addObject:model];
                }
            }
        }
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
-(void)buttonAction:(UIButton *)button
{
    if (button == self.leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(button == self.fenleiBtn)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self.view addSubview:self.maskView];
            self.selectedView.alpha = 0.95;
            self.selectedView.dianpuId = self.dianpuID;
            [self.selectedView reloadDataWithViewTag:2];
            [self.view addSubview:self.selectedView];
        }];
    }
    else if (button == self.searchBtn)
    {
        if (![self.nameTextField.text isEqualToString:@""]) {
            NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":self.dianpuID,@"shangpinname":self.nameTextField.text}];
            [self getShangpinMessagesWithUrl:@"shopinfo.action" AndDict:pram AndIndex:3];
        }
        else
        {
            [self promptMessageWithString:@"请输入商品名称"];
        }
        [self.nameTextField resignFirstResponder];
    }
}
#pragma mark UITextDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![self.nameTextField.text isEqualToString:@""]) {
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"dianpuid":self.dianpuID,@"shangpinname":self.nameTextField.text}];
        [self getShangpinMessagesWithUrl:@"shopinfo.action" AndDict:pram AndIndex:3];
    }
    else
    {
        [self promptMessageWithString:@"请输入商品名称"];
    }
    [self.nameTextField resignFirstResponder];
    
    return YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.maskView removeFromSuperview];
        [self.view endEditing:YES];
        self.selectedView.alpha = 0;
        [self.selectedView removeFromSuperview];
    }];
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

