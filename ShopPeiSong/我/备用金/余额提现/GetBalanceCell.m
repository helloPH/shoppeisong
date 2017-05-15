//
//  GetBalanceCell.m
//  LifeForMM
//
//  Created by MIAO on 16/5/31.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "GetBalanceCell.h"
#import "Header.h"
@implementation GetBalanceCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self SubViews];
    }
    return self;
}
-(void)SubViews
{
    self.bindingTypeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.bindingTypeLabel.textColor = textColors;
    self.bindingTypeLabel.backgroundColor = [UIColor clearColor];
    self.bindingTypeLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    self.bindingTypeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.bindingTypeLabel];
    
    self.accountNumberLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.accountNumberLabel.textAlignment= NSTextAlignmentLeft;
    self.accountNumberLabel.textColor = lineColor;
    self.accountNumberLabel.backgroundColor = [UIColor clearColor];
    self.accountNumberLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [self.contentView addSubview:self.accountNumberLabel];
    
    self.selectedBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.selectedBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [self.selectedBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [self.selectedBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:self.selectedBtn];
    
    self.changeBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.changeBtn setTitle:@"更换" forState:UIControlStateNormal];
    self.changeBtn.backgroundColor = [UIColor clearColor];
    [self.changeBtn setImage:[UIImage imageNamed:@"xialas_xia"] forState:UIControlStateNormal];
    [self.changeBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 50, 5, 2)];
    [self.changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-50, 0, 0)];
    [self.changeBtn.titleLabel setFont:[UIFont systemFontOfSize:MLwordFont_2]];
    [self.changeBtn setTitleColor:lineColor forState:UIControlStateNormal];
    [self.changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.changeBtn];
}

-(void)loadDataForCellWithModel:(BindAccountModel *)model
{
    self.selectedBtn.selected = YES;
    //不可点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bindingTypeLabel.text = model.name;
    if (model.zhanghao.length == 11) {
        self.accountNumberLabel.text = [model.zhanghao stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"****"];
    }
    else
    {
        NSString *eml;
        NSRange rang = [model.zhanghao rangeOfString:@"@"];
        NSInteger length = rang.location;
        eml = [model.zhanghao stringByReplacingCharactersInRange:NSMakeRange(3, length-3) withString:@"****"];
        self.accountNumberLabel.text = eml;
    }
}

-(void)changeBtnClick:(UIButton *)button
{
    if (button == self.changeBtn) {
        if ([self.balanceDelegate respondsToSelector:@selector(changeAccountForBalance)]) {
            [self.balanceDelegate changeAccountForBalance];
        }
    }
    else
    {
        button.selected = !button.selected;
        if ([self.balanceDelegate respondsToSelector:@selector(changeSeletedForButton:)]) {
            [self.balanceDelegate changeSeletedForButton:button];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.bindingTypeLabel.frame = CGRectMake(10*MCscale, 10*MCscale,70*MCscale,30*MCscale);
    self.accountNumberLabel.frame = CGRectMake(self.bindingTypeLabel.right +10*MCscale, 10*MCscale, 180*MCscale, 30*MCscale);
    self.changeBtn.frame = CGRectMake(self.width - 80*MCscale, 15*MCscale,70*MCscale,20*MCscale);
    self.selectedBtn.frame = CGRectMake(self.width - 100*MCscale, 15*MCscale, 20*MCscale, 20*MCscale);
}

@end
