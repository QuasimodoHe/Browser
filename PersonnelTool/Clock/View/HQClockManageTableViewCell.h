//
//  HQClockManageTableViewCell.h
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/26.
//  Copyright © 2018年 gd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQClockManageTableViewCell : UITableViewCell
@property (nonatomic, strong)HQClockModel *model;
@property (strong, nonatomic) IBOutlet UISwitch *clockSwitch;

@end
