//
//  OrderDetailBeizhuCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "OrderDetailBeizhuCell.h"
#import "Header.h"
@interface OrderDetailBeizhuCell ()
@property(nonatomic,strong)UILabel *leftLabel;
@end
@implementation OrderDetailBeizhuCell
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

-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath WithDict:(NSDictionary *)dict
{
    NSString *godName = [NSString stringWithFormat:@"%@%@",dict[@"key"],dict[@"value"]];
    CGSize size = [godName boundingRectWithSize:CGSizeMake(kDeviceWidth - 30*MCscale,80) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
    self.leftLabel.frame =CGRectMake(15*MCscale,10*MCscale,size.width,size.height +10*MCscale);
    self.leftLabel.text = godName;
}
@end

