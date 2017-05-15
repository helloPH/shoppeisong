//
//  OrderDetailCellOne.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/8.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "OrderDetailCellOne.h"
#import "Header.h"
@interface OrderDetailCellOne ()
@property(nonatomic,strong)UILabel *leftLabel,*rightLabel;
@end
@implementation OrderDetailCellOne
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:0 text:@""];
        [self.contentView addSubview:_leftLabel];
    }
    return _leftLabel;
}

-(UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight numOfLines:1 text:@""];
        [self.contentView addSubview:_rightLabel];
    }
    return _rightLabel;
}

-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath WithArray:(NSArray *)array
{
    if (indexpath.section == 0) {
        NSDictionary *dict = array[indexpath.row];
        self.leftLabel.text = dict[@"key"];
        self.rightLabel.text = dict[@"value"];
    }
    else if (indexpath.section == 1)
    {
        NSDictionary *dic = array[indexpath.row];
        self.leftLabel.text = dic[@"key"];
        self.rightLabel.text = dic[@"value"];
    }
    else if (indexpath.section == 3)
    {
        NSDictionary *dic = array[indexpath.row];
        self.leftLabel.text = dic[@"key"];
        self.rightLabel.text = dic[@"value"];
    }
    else if (indexpath.section == 4)
    {
        NSDictionary *dic = array[indexpath.row];
        self.leftLabel.text = dic[@"key"];
        self.rightLabel.text = dic[@"value"];
    }
    else
    {
        NSDictionary *dic = array[indexpath.row];
        NSString *godName = [NSString stringWithFormat:@"%@%@",dic[@"key"],dic[@"value"]];
        CGSize size = [godName boundingRectWithSize:CGSizeMake(300, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        self.leftLabel.frame =CGRectMake(15*MCscale, self.height/2.0-10*MCscale,size.width,size.height +10*MCscale);
        self.leftLabel.text = godName;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftLabel.frame = CGRectMake(15*MCscale, self.height/2.0-10*MCscale, (self.width-30*MCscale)/3.0, 20);
    self.rightLabel.frame = CGRectMake((self.width-30*MCscale)/3.0+16*MCscale, self.height/2.0-10*MCscale, (self.width-30*MCscale)/3.0*2.0, 20*MCscale);
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    //重置图片
    self.leftLabel.text = nil;
    self.rightLabel.text = nil;
    //更新位置
    self.leftLabel.frame = self.contentView.bounds;
}
@end
