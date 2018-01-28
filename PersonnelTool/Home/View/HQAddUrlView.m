//
//  HQAddUrlView.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/22.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQAddUrlView.h"
@interface HQAddUrlView()
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) IBOutlet UIView *backView1;
@property (strong, nonatomic) IBOutlet UIView *backView2;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *urllabel;

@property (strong, nonatomic) IBOutlet UIButton *selectedButton;
@property (strong, nonatomic) IBOutlet UILabel *titlelabel;
@property (strong, nonatomic) IBOutlet UILabel *label2;

@end
@implementation HQAddUrlView
- (void)showKeyBoard{
    [self.urlTextFiled becomeFirstResponder];
    _model = [[HomeCollectionModel alloc]init];
    self.sd_layout.heightIs(170);
}

- (void)hideAction{
    [self.urlTextFiled resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.urlTextFiled setText:@""];
    [self.nameTextField setText:@""];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.urllabel.text = NSLocalizedString(@"网址", nil);
    self.titlelabel.text = NSLocalizedString(@"名称", nil);
    self.urlTextFiled.placeholder = NSLocalizedString(@"请输入网址", nil);
    self.nameTextField.placeholder = NSLocalizedString(@"请输入名称", nil);
    self.label2.text = NSLocalizedString(@"添加导航", nil);
    [self.selectedButton setTitle:NSLocalizedString(@"设为主页",nil)forState:UIControlStateNormal];
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.cornerRadius = 4;
    self.cancelButton.layer.borderColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f].CGColor;
    self.cancelButton.layer.masksToBounds = YES;
    [self.cancelButton setTitle:NSLocalizedString(@"取消1", nil) forState:UIControlStateNormal];
    self.sureButton.layer.cornerRadius = 4;
    self.sureButton.layer.masksToBounds = YES;
    [self.sureButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];

    self.backView1.layer.borderWidth = 1;
    self.backView1.layer.cornerRadius = 4;
    self.backView1.layer.borderColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f].CGColor;
    self.backView1.layer.masksToBounds = YES;
    
    self.backView2.layer.borderWidth = 1;
    self.backView2.layer.cornerRadius = 4;
    self.backView2.layer.borderColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f].CGColor;
    self.backView2.layer.masksToBounds = YES;
}

//确认添加
- (IBAction)sureAction:(id)sender {
    if ([self.nameTextField.text isEqualToString:@""] || [self.urlTextFiled.text isEqualToString:@""]){
        [HUDProgress showTheInfo:NSLocalizedString(@"网址和名称不能为空！",nil) showTime:2];
    }else{
        if (self.isChange){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:@"null" forKey:@"imageUrl"];
            [dic setObject:self.nameTextField.text forKey:@"title"];
            [dic setObject:self.urlTextFiled.text forKey:@"urlString"];
            [dic setObject:[NSString stringWithFormat:@"%d",self.selectedButton.selected] forKey:@"isHomeUrl"];
            [HQDataManager changeTheHomeData:dic index:self.index];
            [_delegate addUrlViewSureAction];
            [HUDProgress showTheInfo:NSLocalizedString(@"修改成功",nil) showTime:1];
        }else{
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:@"null" forKey:@"imageUrl"];
            [dic setObject:self.nameTextField.text forKey:@"title"];
            [dic setObject:self.urlTextFiled.text forKey:@"urlString"];
            [dic setObject:[NSString stringWithFormat:@"%d",self.selectedButton.selected] forKey:@"isHomeUrl"];
            [HQDataManager addTheNewHomeData:dic];
            [_delegate addUrlViewSureAction];
            [HUDProgress showTheInfo:NSLocalizedString(@"添加成功",nil) showTime:1];
        }
    }
}

//取消添加
- (IBAction)cancelAction:(id)sender {
    [_delegate addUrlViewCancelAction];
}

- (void)setIsChange:(BOOL)isChange{
    if (isChange){
        self.titleLabel.text = NSLocalizedString(@"修改导航",nil);
    }
    _isChange = isChange;
}

- (void)setModel:(HomeCollectionModel *)model{
    _model = model;
    if (![model.titleString isEqualToString:@""]){
        self.nameTextField.text = model.titleString;
    }
    if (![model.targetUrl isEqualToString:@""]){
        self.urlTextFiled.text = model.targetUrl;
    }
    self.selectedButton.selected = model.isHomeUrl;
    NSLog(@"%d",self.selectedButton.selected);

}
- (IBAction)selectedAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSLog(@"%d",button.selected);
}
@end
