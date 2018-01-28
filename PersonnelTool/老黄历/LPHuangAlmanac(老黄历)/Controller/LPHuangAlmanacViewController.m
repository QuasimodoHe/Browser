//
//  LPHuangAlmanacViewController.m
//  LotteryProject
//
//  Created by Mac on 2018/1/18.
//  Copyright © 2018年 LisztCoder. All rights reserved.
//

#import "LPHuangAlmanacViewController.h"
#import "UIView+Extension.h"
#import "HttpRequestManager.h"
#import "HuangAlmanacModel.h"
#import "CZZPickerView.h"
#import "CalendarAssistant.h"
#import "DAYCalendarView.h"
#import "YYModel.h"
@interface LPHuangAlmanacViewController () <CZZPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *monthChLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthEnLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *almanacLabel;
@property (weak, nonatomic) IBOutlet UILabel *zodiacLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodThingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *badThingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *jsyqLabel;
@property (weak, nonatomic) IBOutlet UILabel *xsyjLabel;
@property (weak, nonatomic) IBOutlet UILabel *pzbjLabel;
@property (weak, nonatomic) IBOutlet UILabel *chongshaLabel;
@property (weak, nonatomic) IBOutlet UILabel *wuxingLabel;
@property (weak, nonatomic) IBOutlet UIButton *contentLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *contentRightButton;
@property (weak, nonatomic) IBOutlet UIView *topBarBgView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarBgView;
@property (weak, nonatomic) IBOutlet UIView *topBannerBgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) UIButton *leftCoverButton;
@property (strong, nonatomic) UIButton *rightCoverButton;

@property (strong, nonatomic) UISwipeGestureRecognizer *rightpangesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *leftpangesture;
@property (strong, nonatomic) NSDate *requestDate;
@property (strong, nonatomic) CZZPickerView *pickerView;
@property (strong, nonatomic) DAYCalendarView *calenarView;

@property (strong, nonatomic) HuangAlmanacModel *almanacModel;
@property (strong, nonatomic) NSMutableArray *dateDatas;

@end

@implementation LPHuangAlmanacViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createNavRightButton];
    [self createPangestur];
    [self updateViews];
    [self httpRequestAlmanac];
    // Do any additional setup after loading bthe view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    self.title = NSLocalizedString(@"老黄历", nil);
    self.requestDate = [NSDate date];
    NSInteger year = self.requestDate.components.year;
    self.dateDatas = [NSMutableArray array];
    NSArray *years = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"%zd",year-1],[NSString stringWithFormat:@"%zd",year],[NSString stringWithFormat:@"%zd",year + 1]]];
    NSArray *months = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    NSArray *days = [self daysInMonth:self.requestDate.components.month year:self.requestDate.components.year];
    [self.dateDatas addObject:years];
    [self.dateDatas addObject:months];
    [self.dateDatas addObject:days];
}

- (void)httpRequestAlmanac{
    
    NSString *year = [NSString stringWithFormat:@"%zd",self.requestDate.components.year];
    NSString *month = [NSString stringWithFormat:@"%zd",self.requestDate.components.month];
    NSString *day = [NSString stringWithFormat:@"%zd",self.requestDate.components.day];
    
    NSDictionary *parameters = @{
                              @"appkey":@"0818df5744f088f8",
                              @"year": year,
                              @"month": month,
                              @"day": day,
                              };
    NSString *urlString = @"http://api.jisuapi.com/huangli/date";
    [HttpRequestManager getJsonRequestWithUrl:urlString parameters:parameters success:^(id responseObject) {
        self.almanacModel = [HuangAlmanacModel yy_modelWithDictionary:responseObject[@"result"]];
    } failure:^(NSError *error) {
        [HUDProgress showTheInfo:@"网络错误" showTime:2];
    }];
  
}

- (void)createNavRightButton {
    [self.rightButton setTitle:NSLocalizedString(@"选择日期", nil) forState:UIControlStateNormal];
    self.rightButton.sd_layout.widthIs(80);
    [self.rightButton addTarget:self action:@selector(actionNavRightButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateViews {
    self.topBarBgView.alpha = 0.7;
    self.bottomBarBgView.alpha = 0.6;
    self.bottomBarBgView.backgroundColor = [UIColor blackColor];
    
    self.rightCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.rightCoverButton addTarget:self action:@selector(actionRightArrowButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBannerBgView addSubview:self.rightCoverButton];
    
    self.leftCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftCoverButton addTarget:self action:@selector(actionLeftArrowButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBannerBgView addSubview:self.leftCoverButton];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self.view sendSubviewToBack:self.contentView];
    [self.view sendSubviewToBack:self.backView];
    
    [self.topBannerBgView bringSubviewToFront:self.rightCoverButton];
    [self.topBannerBgView bringSubviewToFront:self.leftCoverButton];
    
    self.rightCoverButton.layout_size = CGSizeMake(80, 80);
    [self.rightCoverButton changeAnchorPoint:0.5 :0.5 toPoint:self.contentRightButton.layout_center_x :self.contentRightButton.layout_center_y];
    
    self.leftCoverButton.layout_size = CGSizeMake(80, 80);
    [self.leftCoverButton changeAnchorPoint:0.5 :0.5 toPoint:self.contentLeftButton.layout_center_x :self.contentLeftButton.layout_center_y];
}

- (void)createPangestur {
    self.leftpangesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(acitonLeftPangesture:)];
    self.leftpangesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftpangesture];
    
    self.rightpangesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(acitonRightPangesture:)];
    self.rightpangesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.rightpangesture];
}

#pragma mark - SpecialMethod

- (NSString *)dateStringFromDate:(NSDate *)date {
    if (!date) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (NSArray *)daysInMonth:(NSInteger)month year:(NSInteger)year{
    NSInteger dayCount = [CalendarAssistant daysInMonth:month ofYear:year];
    NSMutableArray *days = [NSMutableArray array];
    for (int i = 0; i < dayCount; i ++) {
        NSString *dayString = [NSString stringWithFormat:@"%zd",i+1];
        [days addObject:dayString];
    }
    return days;
}



#pragma mark - ActionMethod

- (void)actionNavRightButton:(UIButton *)sender {

    CZZPickerView *pickerView = [CZZPickerView pickerViewWithArray:self.dateDatas];
    pickerView.delegate = self;
    [pickerView changeFormat:@"%@年" inComponent:0];
    [pickerView changeFormat:@"%@月" inComponent:1];
    [pickerView changeFormat:@"%@日" inComponent:2];
    if (self.dateDatas.count >= 3) {
        NSInteger selectRowOne = [self.dateDatas[0] indexOfObject:[NSString stringWithFormat:@"%zd",self.requestDate.components.year]];
        NSInteger selectRowTwo = [self.dateDatas[1] indexOfObject:[NSString stringWithFormat:@"%zd",self.requestDate.components.month]];
        NSInteger selectRowThree = [self.dateDatas[2] indexOfObject:[NSString stringWithFormat:@"%zd",self.requestDate.components.day]];
        [pickerView.pickerView selectRow:selectRowOne != NSNotFound ? selectRowOne : 0 inComponent:0 animated:NO];
        [pickerView.pickerView selectRow:selectRowTwo != NSNotFound ? selectRowTwo : 0 inComponent:1 animated:NO];
        [pickerView.pickerView selectRow:selectRowThree != NSNotFound ? selectRowThree : 0 inComponent:2 animated:NO];
    }
    [pickerView show];
    self.pickerView = pickerView;
    
    DAYCalendarView *calendarView = [[DAYCalendarView alloc] init];
    [calendarView show];
    calendarView.selectedDate = self.requestDate;
    [calendarView addTarget:self action:@selector(actionCalendarViewDateChange:) forControlEvents:UIControlEventValueChanged];
    self.calenarView = calendarView;
}

- (void)acitonLeftPangesture:(UISwipeGestureRecognizer *)sender {
    self.requestDate = [self.requestDate dateByAddingTimeInterval:(60 * 60 * 24)];
    [self httpRequestAlmanac];
}

- (void)acitonRightPangesture:(UISwipeGestureRecognizer *)sender {
    self.requestDate = [self.requestDate dateByAddingTimeInterval:-(60 * 60 * 24)];
    [self httpRequestAlmanac];
}

- (void)actionLeftArrowButton:(UIButton *)sender {
    self.requestDate = [self.requestDate dateByAddingTimeInterval:-(60 * 60 * 24)];
    [self httpRequestAlmanac];
}


- (void)actionRightArrowButton:(UIButton *)sender {
    self.requestDate = [self.requestDate dateByAddingTimeInterval:(60 * 60 * 24)];
    [self httpRequestAlmanac];
}

- (void)actionCalendarViewDateChange:(DAYCalendarView *)sender {
    NSInteger year = self.calenarView.selectedDate.components.year;
    NSInteger month = self.calenarView.selectedDate.components.month;
    NSInteger day = self.calenarView.selectedDate.components.day;
    NSInteger lastYear = [[self.dateDatas[0] lastObject] integerValue];
    NSInteger firstYear = [[self.dateDatas[0] firstObject] integerValue];
    if (year > lastYear) {
        for (int i = 0; i < year - lastYear; i++) {
            [self.dateDatas[0] addObject:[NSString stringWithFormat:@"%zd",lastYear + 1]];
        }
        [self.pickerView reloadPickerViewComponent:0 withData:self.dateDatas[0]];
    }else if (year < firstYear) {
        for (int i = 0; i < firstYear - year; i++) {
            [self.dateDatas[0] insertObject:[NSString stringWithFormat:@"%zd",firstYear - 1] atIndex:0];
        }
        [self.pickerView reloadPickerViewComponent:0 withData:self.dateDatas[0]];
    }
    NSArray *days = [self daysInMonth:self.calenarView.selectedDate.components.month year:self.calenarView.selectedDate.components.year];
    [self.dateDatas replaceObjectAtIndex:2 withObject:days];
    [self.pickerView reloadPickerViewComponent:2 withData:days];
    
    NSInteger selectRowOne = [self.dateDatas[0] indexOfObject:[NSString stringWithFormat:@"%zd",year]];
    NSInteger selectRowTwo = [self.dateDatas[1] indexOfObject:[NSString stringWithFormat:@"%zd",month]];
    NSInteger selectRowThree = [self.dateDatas[2] indexOfObject:[NSString stringWithFormat:@"%zd",day]];
    [self.pickerView.pickerView selectRow:selectRowOne != NSNotFound ? selectRowOne : 0 inComponent:0 animated:YES];
    [self.pickerView.pickerView selectRow:selectRowTwo != NSNotFound ? selectRowTwo : 0 inComponent:1 animated:YES];
    [self.pickerView.pickerView selectRow:selectRowThree != NSNotFound ? selectRowThree : 0 inComponent:2 animated:YES];

    
}

#pragma mark - SetMothod

- (void)setAlmanacModel:(HuangAlmanacModel *)almanacModel {
    _almanacModel = almanacModel;
    if (almanacModel) {
        self.monthChLabel.text = [NSString stringWithFormat:@"%@月",self.almanacModel.month];
        self.monthEnLabel.text = self.almanacModel.emonth;
        self.yearLabel.text = [NSString stringWithFormat:@"%@年",self.almanacModel.year];
        self.weekLabel.text = [NSString stringWithFormat:@"星期%@",self.almanacModel.week];
        self.dateLabel.text = self.almanacModel.day;
        self.zodiacLabel.text = self.almanacModel.suici.count >= 3 ? self.almanacModel.suici[2] : @"";
        NSRange yearRange = [self.almanacModel.nongli rangeOfString:@"年"];
        if (yearRange.location != NSNotFound) {
            self.almanacLabel.text = [self.almanacModel.nongli substringFromIndex:yearRange.location + 1];
        }
        self.goodThingsLabel.text = [self.almanacModel.yi componentsJoinedByString:@","];
        self.badThingsLabel.text = [self.almanacModel.ji componentsJoinedByString:@","];
        self.jsyqLabel.text = self.almanacModel.jishenyiqu;
        self.xsyjLabel.text = self.almanacModel.xiongshen;
        self.pzbjLabel.text = [NSString stringWithFormat:@"%@\n%@",self.almanacModel.zhiri,self.almanacModel.taishen];
        
        self.chongshaLabel.text = [NSString stringWithFormat:@"%@%@",self.almanacModel.chong,self.almanacModel.sha];
        self.wuxingLabel.text = self.almanacModel.wuxing;
    }
}

#pragma mark - CZZPickerViewDelegate

- (void)pickerViewDidDetermineClick:(CZZPickerView *)pickerView identifier:(NSString *)identifier selectData:(NSArray *)datas {
    NSInteger year = [datas[0] integerValue];
    NSInteger month = [datas[1] integerValue];
    NSInteger day = [datas[2] integerValue];
    NSDate *date = [CalendarAssistant dateFormYear:year month:month day:day hour:0 minute:0 second:0];
    if (date) {
        self.requestDate = date;
        [self httpRequestAlmanac];
    }
}

- (void)czzPickerView:(CZZPickerView *)pickerView didSelectedForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSInteger year = [self.dateDatas[0][[pickerView.pickerView selectedRowInComponent:0]] integerValue];
    NSInteger month = [self.dateDatas[1][[pickerView.pickerView selectedRowInComponent:1]] integerValue];
    NSInteger day = [self.dateDatas[2][[pickerView.pickerView selectedRowInComponent:2]] integerValue];
    NSDate *date = [CalendarAssistant dateFormYear:year month:month day:day hour:0 minute:0 second:0];
    self.calenarView.selectedDate = date;
    if (component == 0 || component == 1) {
        NSArray *days = [self daysInMonth:month year:year];
        [self.dateDatas replaceObjectAtIndex:2 withObject:days];
        [pickerView reloadPickerViewComponent:2 withData:days];
    }
}

- (void)czzPickerViewDidDismiss:(CZZPickerView *)pickerView {
    [self.calenarView dismiss];
}


@end
