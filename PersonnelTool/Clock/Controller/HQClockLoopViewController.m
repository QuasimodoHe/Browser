//
//  HQClockLoopViewController.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/24.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQClockLoopViewController.h"

@interface HQClockLoopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *tableTitleArr;
@property (nonatomic,strong) NSArray *tableTitleArr1;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,assign)ClockLoopType clockType;

@end

@implementation HQClockLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.title = NSLocalizedString(@"重复",nil);
//    [self.rightButton addTarget:self action:@selector(rightButtonChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setHidden:YES];
    self.clockType = ClockNaverReplace;
    self.tableTitleArr = @[NSLocalizedString(@"永不重复",nil)];
    self.tableTitleArr1 = @[NSLocalizedString(@"每天重复",nil),NSLocalizedString(@"每周重复",nil),NSLocalizedString(@"每月重复",nil)];

    [self.contentView addSubview:self.myTableView];
    self.myTableView.sd_layout.topEqualToView(self.contentView).bottomEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    
}

- (void)rightButtonChoose{
    [_delegate finishChoose:self.clockType];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)myTableView{
    if (!_myTableView){
        _myTableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight-64) style:UITableViewStyleGrouped];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.scrollEnabled = NO;
            tableView.allowsSelection = YES;
            
            tableView;
        });
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return self.tableTitleArr.count;
    }
    return self.tableTitleArr1.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        self.clockType = ClockNaverReplace;
    }else{
        if (indexPath.row == 0){
            self.clockType = ClockLoopEveryDay;
        }else if(indexPath.row == 1){
            self.clockType = ClockLoopEveryWeek;
        }else{
            self.clockType = ClockLoopEveryMonth;
        }
    }
    [_delegate finishChoose:self.clockType];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"HQClockLoopTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    if (indexPath.section == 0){
        cell.textLabel.text = self.tableTitleArr[indexPath.row];
    }else{
        cell.textLabel.text = self.tableTitleArr1[indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}
//表头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 10;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 10)];
    return view;
    
}

@end
