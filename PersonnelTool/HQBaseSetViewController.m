//
//  HQBaseSetViewController.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/24.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQBaseSetViewController.h"

@interface HQBaseSetViewController ()
@property (strong, nonatomic) UILabel *topTitleLabel;
@property (strong, nonatomic) UIView *topStatusView;

@end

@implementation HQBaseSetViewController
- (UIView *)topStatusView{
    if (!_topStatusView){
        _topStatusView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, TopHeightIs)];
            view.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.97f alpha:1.00f];
            view;
        });
    }
    return _topStatusView;
}

- (UIView *)backView{
    if (!_backView){
        _backView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, TopHeightIs, KWidth, KHeight - TopHeightIs)];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
    }
    return _backView;
}

- (UIView *)topView{
    if (!_topView){
        _topView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 44)];
            view.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.97f alpha:1.00f];
            
            view;
        });
    }
    return _topView;
}

- (UIView *)contentView{
    if (!_contentView){
        _contentView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, KWidth, KHeight - TopHeightIs - 44)];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
    }
    return _contentView;
}

- (UIButton *)leftButton{
    if (!_leftButton){
        _leftButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            [button setTitleColor:[UIColor colorWithRed:0.00f green:0.48f blue:1.00f alpha:1.00f] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button addTarget:self action:@selector(leftButtonBeTouched) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
            button;
        });
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (!_rightButton){
        _rightButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            [button setTitleColor:[UIColor colorWithRed:0.00f green:0.48f blue:1.00f alpha:1.00f] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitle:NSLocalizedString(@"完成",nil) forState:UIControlStateNormal];
            button;
        });
    }
    return _rightButton;
}

- (UILabel *)topTitleLabel{
    if (!_topTitleLabel){
        _topTitleLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"Heiti SC-Medium" size:17];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _topTitleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f]];
    [self.view addSubview:self.topStatusView];
    self.topStatusView.sd_layout.heightIs(TopHeightIs).topEqualToView(self.view).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0);
   
    [self.view addSubview:self.backView];
    self.backView.sd_layout.topSpaceToView(self.topStatusView, 0).bottomSpaceToView(self.view, 0).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0);
    
    [self.backView addSubview:self.topView];
    self.topView.sd_layout.topSpaceToView(self.backView, 0).leftSpaceToView(self.backView, 0).rightSpaceToView(self.backView, 0).heightIs(44);
    
    [self.backView addSubview:self.contentView];
    self.contentView.sd_layout.topSpaceToView(self.topView, 0).leftSpaceToView(self.backView, 0).rightSpaceToView(self.backView, 0).bottomSpaceToView(self.backView, 0);
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    lineView.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.79f alpha:1.00f];
    [self.topView addSubview:lineView];
    lineView.sd_layout.bottomSpaceToView(self.topView, 0).leftSpaceToView(self.topView, 0).rightSpaceToView(self.topView, 0).heightIs(0.5);
    
    [self.topView addSubview:self.leftButton];
    self.leftButton.sd_layout.leftSpaceToView(self.topView, 16).heightIs(30).widthIs(46).centerYEqualToView(self.topView);
    
    [self.topView addSubview:self.rightButton];
    self.rightButton.sd_layout.rightSpaceToView(self.topView, 16).heightIs(30).widthIs(46).centerYEqualToView(self.topView);

    [self.topView addSubview:self.topTitleLabel];
    self.topTitleLabel.sd_layout.heightIs(21).widthIs(140).centerXEqualToView(self.topView).centerYEqualToView(self.topView);
}
- (void)leftButtonBeTouched{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTitle:(NSString *)title{
    self.topTitleLabel.text = title;
}


@end
