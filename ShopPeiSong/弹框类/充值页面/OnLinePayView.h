//
//  OnLinePayView.h
//  LifeForMM
//
//  Created by MIAO on 16/5/27.
//  Copyright © 2016年 时元尚品. All rights reserved.
////在线支付

#import <UIKit/UIKit.h>

@protocol OnLinePayViewDelegate <NSObject>


#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wprotocol"

//这里是会报警告的代码
-(void)PaymentPasswordViewWithDanhao:(NSString *)danhao AndLeimu:(NSString *)leimu AndMoney:(NSString *)money;

-(void)pingjiaGuanjiaForMoney;

#pragma clang diagnostic pop
//-(void)pingjiaGuanjiaForMoney;
@end

@interface OnLinePayView : UIView<UITextFieldDelegate>

@property (nonatomic ,strong)UIView *moneyView;//
@property (nonatomic ,strong)UIImageView *alipayImageView;//支付宝
@property (nonatomic ,strong)UIImageView *wChatImageView;//微信
@property (nonatomic ,strong)UIView *moreView;//更多
@property (nonatomic ,strong)UIView *line1;
@property (nonatomic ,strong)UIView *line2;//
@property (nonatomic ,strong)UIView *line3;//
@property (nonatomic,strong)UILabel *titleName;
@property (nonatomic,strong)UILabel *yueZhifu;
@property (nonatomic,strong)UILabel *promptInformationLabel;//充值金额
@property (nonatomic,strong)UITextField *moneyTextFiled;//充值金额
@property (nonatomic ,strong)NSString *danhao;//单号
@property (nonatomic ,strong)NSString *payMoney;//应付金额
@property (nonatomic ,strong)NSString *body;
@property(nonatomic,strong)NSString *shouldMoney;
@property (nonatomic ,assign)NSInteger isFrom;//判断是哪种界面
@property (nonatomic ,assign)BOOL isFromSure;//判断是哪种界面

@property (nonatomic,strong)id<OnLinePayViewDelegate>onLinePayDelegate;
@property (nonatomic,strong)void (^payBlock)(BOOL isSuccess);
-(void)reloadDataFromDanhao:(NSString *)danhao AndMoney:(NSString *)money AndBody:(NSString *)body AndLeiming:(NSString *)leimu;
-(void)setMoney:(NSString *)money;
-(void)appear;
-(void)disAppear;

@end
