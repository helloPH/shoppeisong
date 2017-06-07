//
//  PHJavaScriptHelper.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/2.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "PHJavaScriptHelper.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation PHJavaScriptHelper
-(void)getInfoById:(NSString *)Id{
    
//    JSContext *context=[_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    
}
-(NSArray *)getInfoS{
    NSMutableArray * infos = [NSMutableArray array];
    NSRange  range11 = [_htmlString rangeOfString:@"<body>"];
    NSRange  range12 = [_htmlString rangeOfString:@"</body>"];
    NSString * str1 = [_htmlString substringWithRange:NSMakeRange(range11.location+range11.length, range12.location-range11.location)];
    
    NSArray * arr1 = [str1 componentsSeparatedByString:@"<input"];
    for (int i = 0; i < arr1.count; i ++) {
        NSString * originSt = arr1[i];
        
        NSDictionary * dic = [self getInfoWithString:originSt];
        if (dic.allKeys.count!=0) {
          [infos addObject:[self getInfoWithString:originSt]];  
        }
        
    }
    return infos;
}
-(NSDictionary *)getInfoWithString:(NSString *)string{
   NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
    if ([trimedString length]!=0) {
        NSRange  range1 = [string rangeOfString:@"/>"];
        NSString * str1 = [string substringWithRange:NSMakeRange(0, range1.location)];
        
        NSArray * keyValue = [str1 componentsSeparatedByString:@" "];
        for (int i = 0; i < keyValue.count; i ++) {
            
            NSString * keyv = keyValue[i];
            NSArray * arr1 = [keyv componentsSeparatedByString:@"="];
            
            NSString * key = arr1.firstObject;
            NSString * value = arr1.lastObject;
            value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([key length] != 0) {
               [dic addEntriesFromDictionary:@{key:value}];
            }
        }

    }
    
    
    
      return dic;
}
@end
