//
//  ToolsMath.m
//  威尼斯人
//
//  Created by  Quan He on 2017/3/23.
//  Copyright © 2017年 888. All rights reserved.
//

#import "ToolsMath.h"
#import "LBXAlertAction.h"
@implementation ToolsMath
/**<错误提示 */
+ (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"温馨提示" msg:str chooseBlock:nil buttonsStatement:@"确定",nil];
}

/** 系统弹框 */
+ (void)alertViewOfSystemWithAlertTitle:(NSString *)alertTitle context:(NSString *)context  action_One:(NSString *)action_One  action_Two:(NSString *)action_Two colseTime:(NSString *)closeTime  completion:(void (^ )(void))completion{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:alertTitle message:context preferredStyle:UIAlertControllerStyleAlert];
    
    if (![action_One isEqual: @""]) {
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:action_One style:UIAlertActionStyleDefault handler:nil];
        
        [alertVc addAction:actionOne];
    }
    
    if (![action_Two isEqualToString:@""]) {
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:action_Two style:UIAlertActionStyleCancel handler:nil];
        
        [alertVc addAction:actionTwo];
        
    }
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [vc presentViewController:alertVc animated:YES completion:completion];
    
    if (![closeTime isEqualToString:@""]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([closeTime intValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [vc dismissViewControllerAnimated:YES completion:nil];
        });
    }
}


/** 温馨提示 */
+ (void)alertViewOfSystemWithAlertTitle:(NSString *)alertTitle context:(NSString *)context  action_One:(NSString *)action_One  completion:(void (^ )(void))completion{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:alertTitle message:context preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:action_One style:UIAlertActionStyleCancel handler:nil];
    
    [alertVc addAction:actionOne];
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [vc presentViewController:alertVc animated:YES completion:completion];
}

+ (void)hiddeTheKeyboard{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
