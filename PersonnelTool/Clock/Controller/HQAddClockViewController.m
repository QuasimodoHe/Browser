//
//  HQAddClockViewController.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/23.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQAddClockViewController.h"
#import "HQAddClockTableViewCell1.h"
#import "HQAddClockTableViewCell2.h"
#import "HQClockLoopViewController.h"
@interface HQAddClockViewController ()<UITableViewDelegate,UITableViewDataSource,HQClockLoopDelegate>
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong)UIView *blackView;
@property (nonatomic,strong)UIView *pickerBackView;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)NSString *theDateString;//时间戳
@property (nonatomic,assign)BOOL dateChange;
@property (nonatomic,strong)UILabel *theDateLabel;//提示日期
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *settintLabel;

@property (nonatomic,assign)ClockLoopType loopType;
@end

@implementation HQAddClockViewController
- (instancetype)init{
    self = [super init];
    if (self){
        _model = [[HQClockModel alloc]init];
        _model.repeatType = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cancelButton setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
    self.settintLabel.text = NSLocalizedString(@"设置",nil);
    self.topView.sd_layout.heightIs(TopHeightIs);
    self.backView.sd_layout.topSpaceToView(self.topView, 0).bottomSpaceToView(self.view, 0);
    
    [self.backView addSubview:self.myTableView];
    self.myTableView.sd_layout.topSpaceToView(self.backView, 44).bottomSpaceToView(self.backView, 0).leftSpaceToView(self.backView, 0).rightSpaceToView(self.backView, 0);

   
    [self.backView addSubview:self.blackView];
    self.blackView.sd_layout.topSpaceToView(self.backView, 44).bottomSpaceToView(self.backView, 0).leftSpaceToView(self.backView, 0).rightSpaceToView(self.backView, 0);
    
    [self addPickerView];
    self.theDateString = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    self.loopType = ClockNaverReplace;

}

- (UIView *)blackView{
    if (!_blackView){
        _blackView = ({
            UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
            backView.backgroundColor = [UIColor blackColor];
            backView.alpha = 0.0;
            backView.hidden = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTheDatePickerView)];
            backView.userInteractionEnabled = YES;
            [backView addGestureRecognizer:tap];
            backView;
        });
    }
    return _blackView;
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UITableView *)myTableView{
    if (!_myTableView){
        _myTableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, KWidth, KHeight-64) style:UITableViewStyleGrouped];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView;
        });
    }
    return _myTableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 88;
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        if (indexPath.row == 0){
            [self showThePickerView];//显示时间选择器
        }else{//选择循环次数
            HQClockLoopViewController *clockVC = [[HQClockLoopViewController alloc]init];
            clockVC.delegate = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:clockVC animated:YES completion:nil];
            });
        }
    }
    if (indexPath.section == 2){
       //添加或修改指定通知
        NSIndexPath *  indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        HQAddClockTableViewCell1 * cell = [self.myTableView cellForRowAtIndexPath:indexPath];
        if ([cell.titleTextField.text isEqualToString:@""]){
            [HUDProgress showTheInfo:NSLocalizedString(@"标题不能为空",nil) showTime:1.5];
        }else if ([cell.urlTextField.text isEqualToString:@""]){
            [HUDProgress showTheInfo:NSLocalizedString(@"网络地址不能为空",nil) showTime:1.5];
        }else{
            if([self.theDateString integerValue] < (long)[[NSDate date] timeIntervalSince1970]){
                [HUDProgress showTheInfo:NSLocalizedString(@"时间不能在现在之前哦！请重新修改时间",nil) showTime:1.5];
            }else{
                //添加或者修改
                self.model.urlString = cell.urlTextField.text;
                self.model.titleString = cell.titleTextField.text;
                self.model.repeatType = self.loopType;
                self.model.timeString = self.theDateString;
                self.model.isOpen = YES;
                if (self.isChange){
                    [HQClockManagerTool changeTheClock:self.model];//修改通知
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    if ([HQDataManager readTheClockData].count){
                        self.model.index = [[[HQDataManager readTheClockData] lastObject][@"index"] integerValue] + 1;
                    }
                    [HQClockManagerTool addTheNewClock:self.model];//添加通知
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        static NSString *cellIdentifer = @"HQAddClockTableViewCell1";
        HQAddClockTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:cellIdentifer owner:nil options:nil];
            cell = [cellArr firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleTextField.text = self.model.titleString;
        cell.urlTextField.text = self.model.urlString;
        if ([self.model.titleString isEqualToString:@""] || !self.model.titleString){
            [cell.titleTextField becomeFirstResponder];
        }
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellIdentifer = @"HQAddClockTableViewCell2";
        HQAddClockTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:cellIdentifer owner:nil options:nil];
            cell = [cellArr firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0){
            self.theDateLabel = cell.dataLabel;
            cell.theTitle.text = NSLocalizedString(@"提醒时间",nil);
            if ([self.model.titleString isEqualToString:@""] || !self.model.titleString){
                self.theDateString = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
            }else{
                self.theDateString = self.model.timeString;
            }
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.theTitle.text = NSLocalizedString(@"重复",nil);
            cell.dataLabel.text = NSLocalizedString(@"永不重复",nil);
        }
        return cell;
    }else{
        static NSString *cellIdentifer = @"HQAddClockTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.model.titleString isEqualToString:@""] || !self.model.titleString){
            cell.textLabel.text = NSLocalizedString(@"确认添加",nil);
        }else{
            cell.textLabel.text = NSLocalizedString(@"确认修改",nil);
        }
        cell.textLabel.textColor = [UIColor colorWithRed:0.00f green:0.48f blue:1.00f alpha:1.00f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}
//表头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 0.01)];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 20)];
    return view;
}
#pragma mark - DatePickerView
//选择器
- (UIView *)pickerBackView{
    if (!_pickerBackView){
        _pickerBackView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,KHeight,KWidth,244*bili)];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _pickerBackView;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker){
        _datePicker = ({
            UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44*bili, KWidth, 200*bili)];
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            datePicker.backgroundColor = [UIColor colorWithWhite:0.788 alpha:1.000];
            datePicker.minimumDate = [NSDate date];
            [datePicker setDate:[NSDate date] animated:YES];
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
            datePicker;
        });
    }
    return _datePicker;
}

- (void)addPickerView{
    [self.backView addSubview:self.pickerBackView];
    self.pickerBackView.sd_layout.leftSpaceToView(self.backView, 0).rightSpaceToView(self.backView, 0).bottomSpaceToView(self.backView, -244*bili).heightIs(244*bili);
    
    [self.pickerBackView addSubview:self.datePicker];
    
    
    UIButton *cencelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cencelButton.frame = CGRectMake(16, 0, 46*bili, 44*bili);
    [cencelButton setTitle:NSLocalizedString(@"取消1",nil) forState:UIControlStateNormal];
    cencelButton.titleLabel.font = [UIFont systemFontOfSize:15*bili];
    [cencelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cencelButton.tag = 101;
    [cencelButton addTarget:self action:@selector(chooseTheDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:cencelButton];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(KWidth - 46*bili - 16, 0, 46*bili, 44*bili);
    [sureButton setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:15*bili];
    [sureButton setTitleColor:[UIColor colorWithRed:0.00f green:0.48f blue:1.00f alpha:1.00f] forState:UIControlStateNormal];
    sureButton.tag = 102;
    [sureButton addTarget:self action:@selector(chooseTheDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:sureButton];
    
}
//展示选择器
- (void)showThePickerView{
    self.datePicker.minimumDate = [NSDate date];

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.blackView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.5;
        self.pickerBackView.sd_layout.leftSpaceToView(self.backView, 0).rightSpaceToView(self.backView, 0).bottomSpaceToView(self.backView, 0).heightIs(244*bili);
        [self.pickerBackView updateLayout];

    } completion:^(BOOL finished) {
        self.pickerBackView.sd_layout.leftSpaceToView(self.backView, 0).rightSpaceToView(self.backView, 0).bottomSpaceToView(self.backView, 0).heightIs(244*bili);
        [self.pickerBackView updateLayout];
    }];
}
-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    self.theDateString = [NSString stringWithFormat:@"%ld",(long)[control.date timeIntervalSince1970]];
    self.dateChange = YES;
}

- (void)chooseTheDate:(UIButton *)sender{
    if (sender.tag == 102){
        //把时间取出来
        if (self.theDateString){
            if (!self.dateChange){
                self.theDateString = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
            }
        }else{
            self.theDateString = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        }
    }
    [self hideTheDatePickerView];
}

- (void)setTheDateString:(NSString *)theDateString{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[theDateString longLongValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyy/MM/dd"];
    NSString *ymdString = [formatter stringFromDate:date];
    [formatter setDateFormat:@"ccc"];
    NSString *cccString = [formatter stringFromDate:date];
    [formatter setDateFormat:@"HH:mm"];
    NSString *hhmmString = [formatter stringFromDate:date];
    self.theDateLabel.text = [ymdString stringByAppendingString:[NSString stringWithFormat:@"%@ %@",cccString,hhmmString]];
    _theDateString = theDateString;
}
//隐藏时间选择器
- (void)hideTheDatePickerView{
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.0;
        self.pickerBackView.sd_layout.leftSpaceToView(self.backView, 0).rightSpaceToView(self.backView, 0).bottomSpaceToView(self.backView, -244*bili).heightIs(244*bili);
        [self.pickerBackView updateLayout];
    } completion:^(BOOL finished) {
        self.blackView.hidden = YES;
        self.pickerBackView.sd_layout.leftSpaceToView(self.backView, 0).rightSpaceToView(self.backView, 0).bottomSpaceToView(self.backView, -244*bili).heightIs(244*bili);
        [self.pickerBackView updateLayout];
    }];
    self.dateChange = NO;
}

- (void)finishChoose:(ClockLoopType)loopType{
    self.loopType = loopType;
}

- (void)setLoopType:(ClockLoopType)loopType{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    HQAddClockTableViewCell2 *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    NSArray *array = @[NSLocalizedString(@"永不重复",nil),NSLocalizedString(@"每天重复",nil),NSLocalizedString(@"每周重复",nil),NSLocalizedString(@"每月重复",nil)];
    cell.dataLabel.text = array[loopType];
    _loopType = loopType;
}
@end
