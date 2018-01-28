//
//  CZZPickerView.m
//  StadiumOrder
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 UFO. All rights reserved.
//

#import "CZZPickerView.h"
#import "DAYCalendarView.h"
#import "UIView+Extension.h"
#define ONE_PIX_WIDTH (1/[UIScreen mainScreen].scale)
#define HORIZENTAL_SCALE (KWidth/375.0)

@implementation CZZPickerView

+ (instancetype)pickerViewWithArray:(NSArray *)array {
    CZZPickerView *instance = [[CZZPickerView alloc] init];
    instance.frame = [UIScreen mainScreen].bounds;
    instance.dataArray = array;
    [instance createView];
    [instance updateViewsFrame];
    instance.selectedDatas = [NSMutableArray array];
    instance.formatDictionary = [NSMutableDictionary dictionary];
    return instance;
}

- (void)createView {
    self.coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.coverButton addTarget:self action:@selector(actionCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.coverButton];
    
    self.pickerBgView = [[UIView alloc] init];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    [self.coverButton addSubview:self.pickerBgView];
    
    self.topBgView = [[UIView alloc] init];
    [self.pickerBgView addSubview:self.topBgView];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.confirmButton addTarget:self action:@selector(actionConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:self.confirmButton];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.cancelButton addTarget:self action:@selector(actionCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:self.cancelButton];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.topBgView addSubview:self.lineView];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerBgView addSubview:self.pickerView];
    
}

- (void)updateViewsFrame {
    CGFloat width = self.layout_width;
//    CGFloat height = self.layout_height;
    
    self.coverButton.frame = self.bounds;
    
    self.pickerBgView.frame = CGRectMake(0, KHeight, KHeight, 220 * HORIZENTAL_SCALE);
    
    self.topBgView.layout_size = CGSizeMake(width, 40);
    [self.topBgView changeAnchorPoint:0 :0 toPoint:0 :0];
    
    self.cancelButton.layout_size = CGSizeMake(self.topBgView.layout_width/2, self.topBgView.layout_height);
    [self.cancelButton changeAnchorPoint:0 :0 toPoint:0 :0];
    
    self.confirmButton.layout_size = CGSizeMake(self.topBgView.layout_width/2, self.topBgView.layout_height);
    [self.confirmButton changeAnchorPoint:1 :0 toPoint:self.topBgView.layout_width :0];
    
    self.lineView.layout_size = CGSizeMake(self.topBgView.layout_width, ONE_PIX_WIDTH);
    [self.lineView changeAnchorPoint:0 :1 toPoint:0 :self.topBgView.layout_height];
    
    self.pickerView.layout_size = CGSizeMake(width, self.pickerBgView.layout_height - self.topBgView.layout_height);
    [self.pickerView changeAnchorPoint:0 :1 toPoint:0 :self.pickerBgView.layout_height];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.dataArray.count > 0 && [self.dataArray[0] isKindOfClass:[NSArray class]]) {
        return self.dataArray.count;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dataArray.count > 0 && [self.dataArray[0] isKindOfClass:[NSArray class]]) {
        return [self.dataArray[component] count];
    }
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    NSString *changeTitle = nil;
    if (self.dataArray.count > 0 && [self.dataArray[0] isKindOfClass:[NSArray class]]) {
        title = self.dataArray[component][row];
    }else{
        title = self.dataArray[row];
    }
    if (self.formatDictionary.count) {
        NSString *format = self.formatDictionary[[NSString stringWithFormat:@"c%zd",component]];
        if (format.length > 0) {
            if ([format rangeOfString:@"%@"].location != NSNotFound) {
                changeTitle = [NSString stringWithFormat:format,title];
            }else{
                changeTitle = format;
            }
        }
    }
    return changeTitle ? changeTitle : title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(czzPickerView:didSelectedForRow:forComponent:)]) {
        [self.delegate czzPickerView:self didSelectedForRow:row forComponent:component];
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
        pickerLabel.textColor = [UIColor darkTextColor];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.pickerBgView.layout_y = KHeight;
    [window addSubview:self];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pickerBgView.layout_max_y = KHeight;
    } completion:nil];
}

- (void)dismiss {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(czzPickerViewDidDismiss:)]) {
        [self.delegate czzPickerViewDidDismiss:self];
    }
    
}

- (void)actionConfirmButton:(UIButton *)sender {
    [self.selectedDatas removeAllObjects];
    if ([self.dataArray[0] isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < self.dataArray.count; i++) {
            NSString *data = self.dataArray[i][[self.pickerView selectedRowInComponent:i]];
            [self.selectedDatas addObject:data];
        }
    }else{
        [self.selectedDatas addObject:self.dataArray[[self.pickerView selectedRowInComponent:0]]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewDidDetermineClick:identifier:selectData:)]) {
        [self.delegate pickerViewDidDetermineClick:self identifier:self.identify selectData:self.selectedDatas];
    }
    
    [self dismiss];
}

- (void)actionCancelButton:(UIButton *)sender {
    [self dismiss];

}


- (void)reloadPickerViewComponent:(NSInteger)component withData:(NSArray *)datas {
    if (datas == nil) {
        return;
    }
    NSMutableArray *temArray = [NSMutableArray arrayWithArray:self.dataArray];
    if (component < self.dataArray.count) {
//        NSInteger row = [self.pickerView selectedRowInComponent:component];
        [temArray replaceObjectAtIndex:component withObject:datas];
        self.dataArray = temArray;
        [self.pickerView reloadComponent:component];
    }
}

- (void)changeFormat:(NSString *)format inComponent:(NSInteger)component{
    [self.formatDictionary setObject:format forKey:[NSString stringWithFormat:@"c%zd",component]];
}


@end
