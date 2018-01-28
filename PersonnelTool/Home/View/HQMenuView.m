//
//  HQMenuView.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/26.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQMenuView.h"
@interface HQMenuView()
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;

@end
@implementation HQMenuView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.label1.text = NSLocalizedString(@"快捷键", nil);
    self.label2.text = NSLocalizedString(@"推送设置", nil);
    self.label3.text = NSLocalizedString(@"老黄历",nil);
    self.label4.text = NSLocalizedString(@"清除缓存",nil);
}
- (IBAction)kuaiJieAction:(id)sender {
    [_delegate addKuaiJianVCAction];
}
- (IBAction)clockButtonAction:(id)sender {
    [_delegate addClockVCAction];
}
- (IBAction)closeAction:(id)sender {
    [_delegate closeMenuView];
}
- (IBAction)huangliAction:(id)sender {
    [_delegate huangliAction];
}
- (IBAction)clearTheButton:(id)sender {
    [_delegate clearTheCache];
}

@end
