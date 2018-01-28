//
//  HQHomeCollectionViewCell.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/22.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQHomeCollectionViewCell.h"
@interface HQHomeCollectionViewCell()
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation HQHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _model = [[HomeCollectionModel alloc]init];
    
}

- (void)setModel:(HomeCollectionModel *)model{
    _model = model;
    self.titleLabel.text = model.titleString;
    if ([model.titleString isEqualToString:@"添加"] || [model.titleString isEqualToString:@"Add"]){
        self.titleLabel.text = NSLocalizedString(@"添加", nil);
    }
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    [self.imageButton setTitle:@"" forState:UIControlStateNormal];
    
    if ([model.imageUrl isEqualToString:@"add"]){
        UIImage *img = [UIImage imageNamed:@"add"];
        [self.imageButton setImage:[img imageByScalingToSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
    }else if ([model.imageUrl isEqualToString:@"null"]){
        [self.imageButton setTitle:[model.titleString substringToIndex:1] forState:UIControlStateNormal];
    }
}

@end
