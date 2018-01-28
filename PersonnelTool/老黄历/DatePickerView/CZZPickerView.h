//
//  CZZPickerView.h
//  StadiumOrder
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 UFO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZZPickerView;
@class DAYCalendarView;

@protocol CZZPickerViewDelegate <NSObject>

- (void)pickerViewDidDetermineClick:(CZZPickerView *)pickerView identifier:(NSString *)identifier selectData:(NSArray *)datas;
- (void)czzPickerView:(CZZPickerView *)pickerView didSelectedForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)czzPickerViewDidDismiss:(CZZPickerView *)pickerView;

@end

@interface CZZPickerView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UIButton *coverButton;
@property (strong, nonatomic) UIView *topBgView;
@property (strong, nonatomic) UIView *pickerBgView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) DAYCalendarView *calendarView;
@property (strong, nonatomic) NSMutableArray *selectedDatas;

@property (strong, nonatomic) NSString *identify;
@property (strong, nonatomic) NSMutableDictionary *formatDictionary;

@property (weak, nonatomic) id <CZZPickerViewDelegate> delegate;

+ (instancetype)pickerViewWithArray:(NSArray *)array;

- (void)reloadPickerViewComponent:(NSInteger)component withData:(NSArray *)datas;
- (void)changeFormat:(NSString *)format inComponent:(NSInteger)component;
//- (void)changeFormat:(NSString *)format inComponent:(NSInteger)component row:(NSInteger)row;

- (void)show;
- (void)dismiss;

@end
