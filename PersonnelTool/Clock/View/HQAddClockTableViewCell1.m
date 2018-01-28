//
//  HQAddClockTableViewCell1.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/23.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQAddClockTableViewCell1.h"
@interface HQAddClockTableViewCell1()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;

@end
@implementation HQAddClockTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = NSLocalizedString(@"标题",nil);
    self.urlLabel.text = NSLocalizedString(@"网址",nil);
}

@end
