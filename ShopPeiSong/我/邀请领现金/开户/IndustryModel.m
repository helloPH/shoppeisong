//
//  IndustryModel.m
//  GoodYeWu
//
//  Created by MIAO on 16/11/15.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "IndustryModel.h"

@implementation IndustryModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _industryID = value;
    }
}

-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
