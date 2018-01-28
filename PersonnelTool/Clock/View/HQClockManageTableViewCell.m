



//
//  HQClockManageTableViewCell.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/26.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQClockManageTableViewCell.h"
@interface HQClockManageTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *theTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;

@end
@implementation HQClockManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _model = [[HQClockModel alloc]init];
}
- (void)setModel:(HQClockModel *)model{
    _model = model;
    self.theTitleLabel.attributedText = [self getTitleString:model.repeatType timeString:model.timeString];
    self.urlLabel.text = [NSString stringWithFormat:@"%@:%@  %@:%@",NSLocalizedString(@"标题",nil),model.titleString,NSLocalizedString(@"网址",nil),model.urlString];
    [self.clockSwitch setOn:model.isOpen];
}

- (NSMutableAttributedString *)getTitleString:(NSInteger)repeatType timeString:(NSString *)timeString{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString longLongValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"HH:mm"];
    NSString *hhmmString = [formatter stringFromDate:date];
    [formatter setDateFormat:@"MM/dd"];
    NSString *dayString = [formatter stringFromDate:date];
    [formatter setDateFormat:@"ccc"];
    NSString *cccString = [formatter stringFromDate:date];
    switch (repeatType) {
        case 2:{
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(%@)",hhmmString,cccString]];
            UIFont *baseFont = [UIFont systemFontOfSize:22];
            
            [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, hhmmString.length)];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(hhmmString.length, cccString.length)];
            return attrString;
        }
            break;
        case 3:{
            NSString *string = [NSString stringWithFormat:@"%@(%@,%@)",hhmmString,dayString,cccString];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
            UIFont *baseFont = [UIFont systemFontOfSize:22];
            
            [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, hhmmString.length)];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(hhmmString.length, string.length-hhmmString.length)];
            return attrString;
        }
            break;
        default:
            break;
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:hhmmString];
    
    UIFont *baseFont = [UIFont systemFontOfSize:22];
    
    [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, hhmmString.length)];
    return attrString;
}
@end
