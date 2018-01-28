//
//  HQClockManageViewController.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/26.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQClockManageViewController.h"
#import "HQClockManageTableViewCell.h"
#import "HQAddClockViewController.h"
@interface HQClockManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation HQClockManageViewController
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"通知管理",nil);
    _dataArr = [[NSMutableArray alloc]init];
    self.rightButton.hidden = YES;
    [self.leftButton setTitle:NSLocalizedString(@"返回",nil) forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.myTableView];
    self.myTableView.sd_layout.topEqualToView(self.contentView).bottomEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HQDataManager reloadTheClockData];
    [self.myTableView reloadData];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"删除",nil);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HQAddClockViewController *addClockVC = [[HQAddClockViewController alloc]init];
    addClockVC.model = (HQClockModel *)self.dataArr[indexPath.row];
    addClockVC.isChange = YES;
    [self presentViewController:addClockVC animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"HQClockManageTableViewCell";
    HQClockManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:cellIdentifer owner:nil options:nil];
        cell = [cellArr firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count){
        HQClockModel *model = (HQClockModel *)self.dataArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:22];
        cell.model = model;
        cell.clockSwitch.tag = 100+indexPath.row;
        [cell.clockSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return cell;

}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.detailTextLabel.frame = CGRectMake(cell.detailTextLabel.frame.origin.x, cell.detailTextLabel.frame.origin.x, KWidth - 100, cell.detailTextLabel.frame.size.height);
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

- (NSMutableArray *)dataArr{
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[HQDataManager readTheClockData]];
    for (NSDictionary *dic in array){
        HQClockModel *model = [[HQClockModel alloc]init];
        model.index = [dic[@"index"] integerValue];
        model.isOpen = [dic[@"isOpen"] boolValue];
        model.repeatType = [dic[@"repeatType"] integerValue];
        model.timeString = dic[@"timeString"];
        model.titleString = dic[@"titleString"];
        model.urlString = dic[@"urlString"];
        [array1 addObject:model];
    }
    return array1;
}

- (void)switchIsChanged:(UISwitch *)sender{
    if (sender.isOn){
        //添加这个通知
        //修改缓存数据
        HQClockModel *model = (HQClockModel *)self.dataArr[sender.tag - 100];
        model.isOpen = sender.isOn;
        [HQClockManagerTool changeTheClock:model];
    }else{
        //移除这个通知并修改缓存数据
        HQClockModel *model = (HQClockModel *)self.dataArr[sender.tag - 100];
        model.isOpen = sender.isOn;
        [HQClockManagerTool removeTheClock:model];
    }
}


/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        HQClockModel *model = (HQClockModel *)self.dataArr[indexPath.row];
        /*此处处理自己的代码，如删除数据*/
        if (model.isOpen){//如果有通知，则删除通知
            [HQClockManagerTool cancelLocalNotificationWithKey:[NSString stringWithFormat:@"%ld",model.index]];
        }
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [HQDataManager deleteTheClockData:model];
        /*删除tableView中的一行*/
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}
@end
