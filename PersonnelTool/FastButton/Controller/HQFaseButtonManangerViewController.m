//
//  HQFaseButtonManangerViewController.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/26.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQFaseButtonManangerViewController.h"
#import "HQAddUrlView.h"

@interface HQFaseButtonManangerViewController ()<UITableViewDelegate,UITableViewDataSource,HQAddUrlViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (strong, nonatomic) HQAddUrlView *addView;
@property (strong, nonatomic) UIView *blackView;


@end

@implementation HQFaseButtonManangerViewController

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



- (UIView *)blackView{
    if (!_blackView){
        _blackView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0;
            view.hidden = NO;
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
            [view addGestureRecognizer:tap];
            view;
        });
    }
    return  _blackView;
    
}

- (HQAddUrlView *)addView{
    if (!_addView){
        _addView = ({
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HQAddUrlView" owner:nil options:nil];
            HQAddUrlView *view = [array firstObject];
            view.isChange = YES;
            view.delegate = self;
            view;
        });
    }
    return _addView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"快捷键管理",nil);
    self.rightButton.hidden = YES;
    [self.leftButton setTitle:NSLocalizedString(@"返回",nil) forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.myTableView];
    self.myTableView.sd_layout.topEqualToView(self.contentView).bottomEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
}

- (void)addTheUrlView{
    [self addTheBlackView];
    //添加按钮被点击
    [self.contentView addSubview:self.addView];
    self.addView.sd_layout.topSpaceToView(self.contentView, 0).leftSpaceToView(self.contentView, 0).widthIs(KWidth).heightIs(170);
    [self.addView showKeyBoard];
}

- (void)hideKeyboard{
    [self removeTheBlackView];
    [self.addView removeFromSuperview];
    [self.addView hideAction];
}

- (void)removeTheBlackView{
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0;
    } completion:^(BOOL finished) {
        self.blackView.alpha = 0;
        self.blackView.hidden = YES;
        [self.blackView removeFromSuperview];
    }];
}

- (void)addTheBlackView{
    self.blackView.alpha = 0;
    self.blackView.hidden = NO;
    [self.contentView addSubview:self.blackView];
    self.blackView.sd_layout.topSpaceToView(self.contentView, 0).widthIs(KWidth).bottomSpaceToView(self.contentView, 0).leftSpaceToView(self.contentView, 0);
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.4;
    } completion:^(BOOL finished) {
        self.blackView.alpha = 0.4;
    }];
}

- (NSMutableArray *)dataArr{
    NSMutableArray *collectionArr = [[NSMutableArray alloc]initWithArray:[HQCacheData shareInstance].homeModelArr];
    [collectionArr removeLastObject];
    return collectionArr;
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
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.addView.index = indexPath.section;
    HomeCollectionModel *model = (HomeCollectionModel *)self.dataArr[indexPath.section];
    self.addView.model = model;
    [self addTheUrlView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"HQAddClockTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HomeCollectionModel *model = (HomeCollectionModel *)self.dataArr[indexPath.section];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KWidth - 35, 0, 35, 35)];
    imageView.image = [UIImage imageNamed:@"zhuye"];
    [cell.contentView addSubview:imageView];
    if (!model.isHomeUrl){
        for (id ff in [cell.contentView subviews]){
            if ([ff isKindOfClass:[UIImageView class]]){
                [(UIImageView *)ff removeFromSuperview];
            }
        }
    }
    NSLog(@"%@",[cell subviews]);

    cell.textLabel.font = [UIFont systemFontOfSize:22];
    cell.textLabel.text = model.titleString;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"目标网址",nil),model.targetUrl];
    return cell;
    
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
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


/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.dataArr removeObjectAtIndex:indexPath.section];

        [HQDataManager deleteTheHomeDataWithIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (void)addUrlViewCancelAction{
    [self hideKeyboard];
}
- (void)addUrlViewSureAction{
    //添加数据
    [self hideKeyboard];
    [self.myTableView reloadData];
}
@end
