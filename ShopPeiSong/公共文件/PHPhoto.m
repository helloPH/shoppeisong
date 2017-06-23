//
//  PHPhoto.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/20.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PHPhoto.h"
#import "UIViewController+Helper.h"

@interface PHPhoto()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UIImagePickerController * picker;
@end
@implementation PHPhoto
-(void)showPicker{
    _picker = [[UIImagePickerController alloc]init];
    _picker.delegate=self;
    _picker.allowsEditing=YES;
    _picker.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [[UIViewController presentingVC]presentViewController:_picker animated:YES completion:^{
        
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (_block) {
        _block(image);
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}
@end
