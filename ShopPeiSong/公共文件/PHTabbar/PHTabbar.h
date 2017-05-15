//
//  PHTabbar.h
//  PHPackAge
//
//  Created by wdx on 2016/12/28.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,TabbarType){
    TabbarTypeDefault =0, // 不能滚动 按钮的宽度会根据按钮的个数自动计算得出
    TabbarTypeScrollUnderline=1,// 带有下划线的 可滚动的  按钮的宽度，根据自身内容算出
    TabbarTypeScrollRound=2,// 不带下滑线的 可滚动的  按钮的宽度，根据自身内容算出
};
@interface PHTabbar : UIScrollView
@property (nonatomic,strong)void (^block)(NSInteger index);
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)TabbarType tabbarType;

@property (nonatomic,assign)BOOL isDrag;
+(instancetype)insWithTitles:(NSArray *)titles type:(TabbarType)type themeColor:(UIColor*)themeColor frame:(CGRect)frame;
-(UIScrollView*)initWithTitles:(NSArray *)titles type:(TabbarType)type themeColor:(UIColor*)themeColor frame:(CGRect)frame;
-(void)changeType:(TabbarType)type;
-(void)changeTitles:(NSArray<NSString *> *)titles;
-(void)changeUnderLineOffSet:(float)percent; /* 向后翻传正的百分比  向前翻传负的百分比*/
@end
