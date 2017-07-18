//
//  SystemMessageViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/7/18.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessageTableViewCell.h"
#import "SuperWebViewController.h"

@interface SystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * dataS;


@property (nonatomic,strong)UITableView * mainTableView;

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)initData{
  self.navigationItem.title=@"消息";
    _dataS = [NSMutableArray array];
}
-(void)newView{
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    _mainTableView.delegate=self;
    _mainTableView.dataSource=self;
    [self.view addSubview:_mainTableView];
    _mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.mainTableView.estimatedRowHeight = 100;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    
    [_mainTableView registerClass:[SystemMessageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SystemMessageTableViewCell class])];
 
}
-(void)reshData{
    [_dataS removeAllObjects];
    
    UIImageView * backView =[[UIImageView  alloc]initWithFrame:_mainTableView.frame];
    backView.image=[UIImage imageNamed:@""];
    _mainTableView.backgroundView=backView;
    
    
    [Request getSystemMessageListSuccess:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
        NSArray  * list = [json valueForKey:@"list"];
        
        if ([message isEqualToString:@"1"]) {
            for (NSDictionary * dic in list) {
                SystemMessageModel * model = [SystemMessageModel new];
                [model setValuesForKeysWithDictionary:dic];
                [_dataS addObject:model];
            }
        }else{
                backView.image=[UIImage imageNamed:@"zanwuxinxi"];
                _mainTableView.backgroundView=backView;
        }
             [_mainTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark --  tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataS.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemMessageModel * model = _dataS[indexPath.section];
    
    SystemMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SystemMessageTableViewCell class])];
    cell.model= model;

    cell.block=^(BtnType btnType,SystemMessageModel * backModel){
        if (btnType == btnTypeDetail || btnType == btnTypeImg) {
          
            if ([backModel.url isEmptyString] || [backModel.url isEqualToString:@"0"]) {
                return ;
            }
            [self.navigationController pushViewController:[SuperWebViewController insWithTitle:backModel.title urlString:backModel.url] animated:YES];

        }
        if (btnType == btnTypeDelete) {
            [Request deleteFromSystemMessageListWithMessageId:backModel.xinxiid success:^(id json) {
                NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
                if ([message isEqualToString:@"1"]) {
                    [MBProgressHUD promptWithString:@"删除成功"];
                    [self reshData];
                }else{
                     [MBProgressHUD promptWithString:@"删除失败"];
                }
            } failure:^(NSError *error) {
                
            }];

        }
        
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
