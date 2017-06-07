//
//  PHJavaScriptHelper.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/2.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHJavaScriptHelper : NSObject
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)NSString * htmlString;
-(void)getInfoById:(NSString *)Id;
-(NSArray *)getInfoS;
@end
