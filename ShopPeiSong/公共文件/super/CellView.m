//
//  CellView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/20.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "CellView.h"
#import "Header.h"
@interface CellView()

@end
@implementation CellView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self newView];
    }
    return self;
}
-(void)newView{

    
    _rightImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_rightImg];
    
    
    _titleTF = [[UITextField alloc]initWithFrame:CGRectZero];
    [self addSubview:_titleTF];
    _titleTF.font=[UIFont systemFontOfSize:MLwordFont_4];
    _titleTF.textColor=textBlackColor;
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_contentLabel];
    _contentLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    _contentLabel.textColor=lineColor;
    _contentLabel.textAlignment=NSTextAlignmentRight;
    
    _bottomLine = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_bottomLine];
    _bottomLine.backgroundColor=lineColor;
    
    
    _rightImg.frame=CGRectMake(0, 0, 25, 25);
    _rightImg.right=self.width-10;
    
    _contentLabel.frame=CGRectMake(0, 0, self.width*0.3, 25);
    _contentLabel.right=_rightImg.left-5;
    
    _titleTF.frame=CGRectMake(10, 0, self.width*0.4, 25);
    _titleTF.centerY=_contentLabel.centerY=_rightImg.centerY=self.height/2;
    
    _bottomLine.frame=CGRectMake(10, self.height-1, self.width-20, 1);
}
-(void)layoutSubviews{
    [super layoutSubviews];


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
