//
//  HQClockLoopViewController.h
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/24.
//  Copyright © 2018年 gd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ClockLoopType) {
    ClockNaverReplace,
    ClockLoopEveryDay,
    ClockLoopEveryWeek,
    ClockLoopEveryMonth
};

@protocol HQClockLoopDelegate<NSObject>
- (void)finishChoose:(ClockLoopType)loopType;
@end
@interface HQClockLoopViewController : HQBaseSetViewController

@property (nonatomic, weak) id <HQClockLoopDelegate>delegate;
@end
