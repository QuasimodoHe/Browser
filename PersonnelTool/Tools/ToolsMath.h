//
//  ToolsMath.h
//  威尼斯人
//
//  Created by  Quan He on 2017/3/23.
//  Copyright © 2017年 888. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolsMath : NSObject
/**<错误提示 */
+ (void)showError:(nullable NSString *)str;

/** 温馨提示 */
+ (void)alertViewOfSystemWithAlertTitle:(nullable NSString *)alertTitle context:(nullable NSString *)context  action_One:(nullable NSString *)action_One  completion:(void (^ _Nullable)(void))completion;


/** 系统弹框 */
+ (void)alertViewOfSystemWithAlertTitle:(nullable NSString * )alertTitle context:(nullable NSString * )context  action_One:(nullable NSString * )action_One  action_Two:(nullable NSString * )action_Two colseTime:(nullable NSString * )closeTime completion:(void (^ _Nullable)(void))completion;
    
+ (void)hiddeTheKeyboard;
@end
