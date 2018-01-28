//
//  HQHomeViewController.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/21.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQHomeViewController.h"
#import "HQHomeCollectionViewCell.h"
#import "HQAddClockViewController.h"
#import "HQAddUrlView.h"
#import <WebKit/WebKit.h>
#import "HQMenuView.h"
#import "HQClockManageViewController.h"
#import "HQFaseButtonManangerViewController.h"
#import "LPHuangAlmanacViewController.h"
@interface HQHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,HQAddUrlViewDelegate,UISearchBarDelegate,WKUIDelegate,WKNavigationDelegate,NSURLConnectionDataDelegate,HQMenuViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *collectionDataArr;


@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UIImageView *goImage;

@property (strong, nonatomic) IBOutlet UIButton *addButton;//顶部左边添加按钮
@property (strong, nonatomic) IBOutlet UITextField *urlTextFiled;
@property (strong, nonatomic) IBOutlet UIImageView *topSearchImage;

@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) UIView *blackView;
@property (strong, nonatomic) HQAddUrlView *addView;
//
//webView
//
@property (strong, nonatomic) WKWebView *wkWebView;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,assign)CGFloat newprogress;
@property (nonatomic,strong) NSString *urlString;
//
//MenuView
//
@property (strong, nonatomic) HQMenuView *menuView;
@property (strong, nonatomic) UIView *menuBackView;

@property (assign, nonatomic) NSInteger imageIndex;
@end

@implementation HQHomeViewController
- (UICollectionView *)collectionView{
    if (!_collectionView){
        _collectionView = ({
            //1.初始化layout
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            //2.初始化collectionView
            UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
            //    _mainCollectionView.scrollEnabled = NO;//设置不能滑动
            collectionView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
            [collectionView registerNib:[UINib nibWithNibName:@"HQHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HQHomeCollectionViewCell"];
            //4.设置代理
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView;
        });
    }
    return _collectionView;
}

- (NSMutableArray *)collectionDataArr{
    NSMutableArray *collectionArr = [HQCacheData shareInstance].homeModelArr.copy;
    return collectionArr;
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
            view.isChange = NO;
            view.delegate = self;
            view;
        });
    }
    return _addView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageIndex = 0;
    self.urlTextFiled.placeholder = NSLocalizedString(@"输入网址", nil);
    self.urlTextFiled.delegate = self;
    self.urlTextFiled.returnKeyType = UIReturnKeySearch;
    
    self.topView.sd_layout.heightIs(TopHeightIs);
    self.navView.sd_layout.topSpaceToView(self.topView, 0).heightIs(44);
    self.bottomView.sd_layout.bottomSpaceToView(self.view, BottomHeightIs).heightIs(44);
    self.backView.sd_layout.topSpaceToView(self.navView, 0).heightIs(KHeight - TopHeightIs - 88 - BottomHeightIs);
    [self.backView addSubview:self.collectionView];
    
    self.collectionView.sd_layout.heightIs(60).bottomSpaceToView(self.backView, 0).leftSpaceToView(self.backView, 0).rightSpaceToView(self.backView, 0);
    
    [self.addButton setUserInteractionEnabled:NO];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUrl:) name:@"showUrl" object:nil];
}

- (void)addTheBlackView{
    self.blackView.alpha = 0;
    self.blackView.hidden = NO;
    [self.backView addSubview:self.blackView];
    self.blackView.sd_layout.topSpaceToView(self.backView, 0).widthIs(KWidth).bottomSpaceToView(self.backView, 0).leftSpaceToView(self.backView, 0);
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.4;
    } completion:^(BOOL finished) {
        self.blackView.alpha = 0.4;
    }];
}

- (void)removeTheBlackView{
    [self.urlTextFiled resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0;
    } completion:^(BOOL finished) {
        self.blackView.alpha = 0;
        self.blackView.hidden = YES;
        [self.blackView removeFromSuperview];
    }];
}
#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"HQHomeCollectionViewCell";
    HQHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.model = (HomeCollectionModel *)self.collectionDataArr[indexPath.row];
    return cell;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (KWidth < 375){
        return CGSizeMake(KWidth/5, 60);
    }
    return CGSizeMake(KWidth/6,60);
    
}
//header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
#pragma mark - collection点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.collectionDataArr.count-1){
        [self addTheBlackView];
        //添加按钮被点击
        [self.backView addSubview:self.addView];
        self.addView.sd_layout.topSpaceToView(self.backView, 0).leftSpaceToView(self.backView, 0).widthIs(KWidth).heightIs(170);
        [self.addView showKeyBoard];
        //改变顶端样式
        [self changeTopViewStyle];
    }else{
        HomeCollectionModel *model = (HomeCollectionModel *)self.collectionDataArr[indexPath.row];
        [self requestTheUrl:model.targetUrl];
        if (self.wkWebView.hidden){
            [self addWkWebView];
        }
    }
}

- (void)changeTopViewStyle{
    [self.urlTextFiled setBackgroundColor:[UIColor clearColor]];
    self.urlTextFiled.text = NSLocalizedString(@"网址添加",nil);
    self.urlTextFiled.borderStyle = UITextBorderStyleNone;
    if ([HQCacheData shareInstance].isFirst){//添加引导页
        UIImageView *image = [self.view viewWithTag:20];
        image.hidden = NO;
        [image setImage:[UIImage imageNamed:[self getImageName:self.imageIndex]]];
        [HQCacheData shareInstance].isFirst = NO;
    }
}

- (void)reviewTopViewStyle{
    self.urlTextFiled.text = self.urlString;
    if (self.wkWebView.hidden){
        self.urlTextFiled.borderStyle = UITextBorderStyleRoundedRect;
        [self.urlTextFiled setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.urlTextFiled setBackgroundColor:[UIColor clearColor]];
        self.urlTextFiled.borderStyle = UITextBorderStyleNone;
    }

}

#pragma mark - TextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self addTheBlackView];
    [self.addView removeFromSuperview];
    [self.addView hideAction];
    [self.urlTextFiled setBackgroundColor:[UIColor whiteColor]];
    self.urlTextFiled.text = self.urlString;
    self.urlTextFiled.borderStyle = UITextBorderStyleRoundedRect;
}

//结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回车，即按下return
    if ([textField.text isEqualToString:@""]){
        [HUDProgress showTheInfo:NSLocalizedString(@"不能输入空的网址哦！",nil) showTime:2];
        return NO;
    }
    self.urlString = self.urlTextFiled.text;
    [self.urlTextFiled endEditing:YES];
    [self removeTheBlackView];
    [self.addView removeFromSuperview];
    [self.addView hideAction];
    if (self.wkWebView.hidden){
        //添加webView
        [self addWkWebView];
    }
    //正则判断，是否加载webView
    if (![self.urlString containsString:@"www."] && ([self.urlString containsString:@".com"] || [self.urlString containsString:@".net"] || [self.urlString containsString:@".cn"]) && (![self.urlString containsString:@"http://"] && ![self.urlString containsString:@"https://"])){
        self.urlString = [NSString stringWithFormat:@"www.%@",self.urlString];
    }
    if ([self validateUrl:self.urlString]){
        [self requestTheUrl:self.urlString];
    }else{//百度搜索
        [self requestTheUrl:[NSString stringWithFormat:@"http://www.bing.com/search?q=%@",self.urlString]];
    }
    return YES;
}
#pragma mark - HQAddUrlViewDelegate
- (void)addUrlViewCancelAction{
    [self hideKeyboard];
}

- (void)addUrlViewSureAction{
    [self hideKeyboard];
    [self.collectionView reloadData];
}
#pragma mark - ButtonAction 底部按钮点击事件
- (IBAction)backAction:(id)sender {
    [self.wkWebView goBack];
    [self performSelector:@selector(changeTheImageStatus) withObject:nil afterDelay:0.1];//延时调用
}

- (IBAction)goAction:(id)sender {
    [self.wkWebView goForward];
    [self changeTheImageStatus];
}

- (IBAction)menuAction:(id)sender {
    [self.urlTextFiled endEditing:YES];
    [self removeTheBlackView];
    [self.addView removeFromSuperview];
    [self.addView hideAction];
    [self reviewTopViewStyle];
    [self addTheMenuView];
}
- (IBAction)refreshButton:(id)sender {
    if (!self.wkWebView.hidden){
        [self.wkWebView reload];
    }
}

- (IBAction)homeAction:(id)sender {
    if(![[HQCacheData shareInstance].homeUrl isEqualToString:@""]){
        if (self.wkWebView.hidden){
            [self addWkWebView];
        }
        [self requestTheUncodeUrl:[HQCacheData shareInstance].homeUrl];
    }else{
        [HUDProgress showTheInfo:NSLocalizedString(@"您暂未设置主页", nil) showTime:1.5];
    }
}
- (IBAction)addAction:(id)sender {
    [self addTheBlackView];
    //添加按钮被点击
    [self.backView addSubview:self.addView];
    self.addView.sd_layout.topSpaceToView(self.backView, 0).leftSpaceToView(self.backView, 0).widthIs(KWidth).heightIs(170);
    [self.addView showKeyBoard];
    //改变顶端样式
    [self changeTopViewStyle];
    self.addView.urlTextFiled.text = self.urlString;
    [self.addView.nameTextField becomeFirstResponder];
}

- (IBAction)clockButton:(id)sender {//添加定时器
    HQAddClockViewController *clockVC = [[HQAddClockViewController alloc]init];
    clockVC.model.urlString = self.urlString;
    clockVC.isChange = NO;
    [self presentViewController:clockVC animated:YES completion:nil];
}
#pragma mark - self Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.urlTextFiled resignFirstResponder];
}
- (void)hideKeyboard{
    [self.urlTextFiled endEditing:YES];
    [self removeTheBlackView];
    [self.addView removeFromSuperview];
    [self.addView hideAction];
    [self reviewTopViewStyle];
}
//
//webView添加
//
#pragma mark - progress
- (UIProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 20)];
        self.progressView.tintColor = [UIColor blueColor];
        self.progressView.trackTintColor = [UIColor grayColor];
    }
    return _progressView;
}
#pragma mark - WebView
- (WKWebView *)wkWebView{
    if (!_wkWebView){
        _wkWebView = ({
            //创建WKWebview配置对象
            WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc] init];
            config.preferences = [[WKPreferences alloc] init];
            config.preferences.minimumFontSize = 10;
            config.preferences.javaScriptEnabled = YES;
            config.preferences.javaScriptCanOpenWindowsAutomatically =NO;
            //允许视频播放
            config.allowsAirPlayForMediaPlayback = YES;
            // 允许在线播放
            config.allowsInlineMediaPlayback = YES;
            // 允许可以与网页交互，选择视图
            config.selectionGranularity = YES;
            
            NSMutableString *javascript = [NSMutableString string];

            WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
            
            //创建webView
            WKWebView *webView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds configuration:config];
            [webView.configuration.userContentController addUserScript:noneSelectScript];
            webView.hidden = YES;
            webView.UIDelegate = self;
            webView.navigationDelegate = self;
            webView.backgroundColor = [UIColor whiteColor];
            webView.scrollView.scrollEnabled = YES;
            [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
            [webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
            [webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            _wkWebView = webView;
        });
    }
    return _wkWebView;
}

- (void)addWkWebView{
    [self.backView addSubview:self.wkWebView];
    self.wkWebView.hidden = NO;
    self.wkWebView.sd_layout.topSpaceToView(self.backView, 0).bottomSpaceToView(self.collectionView, 0).rightSpaceToView(self.backView, 0).leftSpaceToView(self.backView, 0);
    [self.backView addSubview:self.progressView];
}

- (void)requestTheUrl:(NSString *)urlString{
    if (![urlString containsString:@"http"]){
        urlString = [NSString stringWithFormat:@"http://%@",urlString];
    }else if ([urlString containsString:@"http://"]){//如果是http开头的
        [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"http://"];
    }
    NSString *encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",encodedString]];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];//url重定向
    [connection start];
}

//重定向的代理方法
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    NSLog(@"================================================");
    NSLog(@"will send request\n%@", [request URL]);
    NSLog(@"redirect response\n%@", [response URL]);
    [self.wkWebView stopLoading];
    [self.wkWebView loadRequest:request];
    self.urlString = [NSString stringWithFormat:@"%@",[request URL]];
    self.urlTextFiled.text = self.urlString;
    return request;
}

#pragma mark - WKWebView WKNavigationDelegate 相关
/// 是否允许加载网页 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    urlString = [urlString stringByRemovingPercentEncoding];
    //    NSLog(@"urlString=%@",urlString);
    // 用://截取字符串
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if ([urlComps count]) {
        // 获取协议头
        NSString *protocolHead = [urlComps objectAtIndex:0];
        NSLog(@"protocolHead=%@",protocolHead);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"知道返回内容之后，是否允许加载，允许加载");
    decisionHandler(WKNavigationResponsePolicyAllow);
    [self changeTheImageStatus];

}
//新窗口打开监听
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:navigationAction.request delegate:self];//url重定向
    [connection start];    return nil;
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"跳转到其他的服务器");
    
}
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController{

}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [self changeTheImageStatus];

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //改变搜索按钮
//    NSLog(@"%@",webView.URL.absoluteString);
    self.urlString = webView.URL.absoluteString;
    self.urlTextFiled.text = self.urlString;
    [self.urlTextFiled setBackgroundColor:[UIColor clearColor]];
    self.urlTextFiled.borderStyle = UITextBorderStyleNone;
    
    //后退按钮设置
    [self changeTheImageStatus];
}
//后退前进按钮状态设置
- (void)changeTheImageStatus{
    self.urlString = self.wkWebView.URL.absoluteString;
    self.urlTextFiled.text = self.urlString;
    if ([self.wkWebView canGoBack]){
        self.backImage.image = [UIImage imageNamed:@"back"];
        self.backButton.userInteractionEnabled = YES;
    }else{
        self.backImage.image = [UIImage imageNamed:@"back1"];
        self.backButton.userInteractionEnabled = NO;
    }
    if ([self.wkWebView canGoForward]){
        self.goImage.image = [UIImage imageNamed:@"go"];
        self.goButton.userInteractionEnabled = YES;
    }else{
        self.goImage.image = [UIImage imageNamed:@"go1"];
        self.goButton.userInteractionEnabled = NO;
    }
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailLoadWithError:(nonnull NSError *)error{
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败,失败原因:%@",[error description]);
    [HUDProgress showTheInfo:@"网页加载失败，检查网络连接状态或者尝试刷新网页" showTime:1.5];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
//    NSLog(@"网页加载内容进程终止");
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [HUDProgress showTheInfo:@"网页加载失败，检查网络连接状态或者尝试刷新网页" showTime:1.5];
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        self.newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        
        if (self.newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:self.newprogress animated:YES];
        }
    }
    if (object == self.wkWebView && [keyPath isEqualToString:@"URL"]){
        NSLog(@"页面改变");
        [self changeTheImageStatus];
        if ([self.wkWebView.URL.absoluteString isEqualToString:@""]){
            [self.topSearchImage setImage:[UIImage imageNamed:@"search"]];
            self.addButton.userInteractionEnabled = NO;
        }else{
            self.topSearchImage.image = [UIImage imageNamed:@"添加"];
            self.addButton.userInteractionEnabled = YES;
        }
    }
//    if ([keyPath isEqualToString:@"contentOffset"]){
//        CGFloat y = self.wkWebView.scrollView.contentOffset.y;
//        NSLog(@"%lf",y);
//        static float lastContentOffset = 0;
//        if (y > 0){
//            if (y > lastContentOffset){//手指往上滑
//                if (y > 44){
//
//                }
//            }else{
//                if (y > 44){
//                    NSLog(@"大于44，界面往上,监听滑动速度");
//
//                }else{
//                    NSLog(@"界面往上，头部y位置%lf",-y);
////                    self.navView.sd_layout.topSpaceToView(self.view, -y);
////                    self.backView.sd_layout.topSpaceToView(self.navView, 0);
//                }
//            }
//            lastContentOffset = self.wkWebView.scrollView.contentOffset.y;
//        }
//    }
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"URL"];
    [self.wkWebView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showUrl" object:self];
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    
}
//正则判断是否是网址
- (BOOL)validateUrl:(NSString *)textString
{
    // 正则1
    NSError *error;
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    // 正则2
    regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *arrayOfAllMathes = [regex matchesInString:textString options:0 range:NSMakeRange(0, textString.length)];
    for (NSTextCheckingResult *match in arrayOfAllMathes){
        NSLog(@"匹配");
        return YES;
    }
    return NO;
}
//
//菜单添加
//
#pragma mark - Menu
- (HQMenuView *)menuView{
    if (!_menuView){
        _menuView = ({
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HQMenuView" owner:nil options:nil];
            HQMenuView *view = [array firstObject];
            view.delegate = self;
            view;
        });
    }
    return _menuView;
}

- (UIView *)menuBackView{
    if (!_menuBackView){
        _menuBackView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KHeight, KWidth)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0;
            view.hidden = NO;
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMenu)];
            [view addGestureRecognizer:tap];
            view;
        });
    }
    return  _menuBackView;
}

- (void)hideMenu{
    [UIView animateWithDuration:0.3 animations:^{
        self.menuBackView.alpha = 0;
    } completion:^(BOOL finished) {
        self.menuBackView.alpha = 0;
        self.menuBackView.hidden = YES;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.0;
        self.menuView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, -105).heightIs(105);
        [self.menuView updateLayout];
    } completion:^(BOOL finished) {
        self.blackView.hidden = YES;
        self.menuView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, -105).heightIs(105);
        [self.menuView updateLayout];

    }];
    
}
- (void)addTheMenuView{
    self.menuBackView.hidden = NO;
    [self.view addSubview:self.menuBackView];
    self.menuView.frame = CGRectMake(0, 0, KWidth, KHeight);

    self.menuBackView.sd_layout.topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).leftSpaceToView(self.view, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.menuBackView.alpha = 0.4;
    } completion:^(BOOL finished) {
        self.menuBackView.alpha = 0.4;
        self.menuBackView.hidden = NO;
    }];
    
    [self.view addSubview:self.menuView];
    self.menuView.frame = CGRectMake(0, KHeight, KWidth, 105);
    self.menuView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, -105).heightIs(105);
    [UIView animateWithDuration:0.3 animations:^{
        self.menuView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, BottomHeightIs).heightIs(105);
        [self.menuView updateLayout];
    } completion:^(BOOL finished) {
        self.menuView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, BottomHeightIs).heightIs(105);
        [self.menuView updateLayout];
    }];
}

- (void)addKuaiJianVCAction{//快捷键设置
    [self hideMenu];
    HQFaseButtonManangerViewController *faseBtnManagerVC = [[HQFaseButtonManangerViewController alloc]init];
    [self presentViewController:faseBtnManagerVC animated:YES completion:nil];
}
- (void)addClockVCAction{//推送设置
    HQClockManageViewController *clockManagerVC = [[HQClockManageViewController alloc]init];
    [self hideMenu];
    [self presentViewController:clockManagerVC animated:YES completion:nil];

}

- (void)huangliAction{
    [self hideMenu];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LPHuangAlmanacViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LPHuangAlmanacViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clearTheCache{
    [self clearTheWebViewData];
}

- (void)closeMenuView{//关闭菜单
    [self hideMenu];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
//    NSLog(@"homeUrl ： %@",[HQCacheData shareInstance].homeUrl);
    if (self.wkWebView.hidden){
        if(![[HQCacheData shareInstance].homeUrl isEqualToString:@""]){
            [self addWkWebView];
            [self requestTheUncodeUrl:[HQCacheData shareInstance].homeUrl];
        }
    }
}

- (void)showUrl:(NSNotification *)notification{
//    NSLog(@"notification.userInfo : %@",notification.userInfo);
    if (self.wkWebView.hidden){
        [self addWkWebView];
    }
    if([[notification.userInfo allKeys] containsObject:@"urlString"]){
        [self requestTheUncodeUrl:notification.userInfo[@"urlString"]];
    }
}

- (void)requestTheUncodeUrl:(NSString *)urlString{
    if (![urlString containsString:@"http"]){
        urlString = [NSString stringWithFormat:@"http://%@",urlString];
    }else if ([urlString containsString:@"http://"]){//如果是http开头的
        [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"http://"];
    }
   
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];//url重定向
    [connection start];
  
}

//清楚缓存
- (void)clearTheWebViewData{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    HUDProgress *hud = [[HUDProgress alloc]init];
    [hud showTheHUD:NSLocalizedString(@"清除缓存中...", nil)];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        [hud hideTheHUD];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if ([HQCacheData shareInstance].isFirst){
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
        
        image.image = [UIImage imageNamed:[self getImageName:self.imageIndex]];
        image.userInteractionEnabled = YES;
        image.tag = 20;
        [self.view addSubview:image];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextImage:)];
        [image addGestureRecognizer:tap];
    }
}

//引导页
- (void)showNextImage:(id)sender{
    self.imageIndex ++;
    if (self.imageIndex <= 4){
        UIImageView *image = [self.view viewWithTag:20];
        [image setImage:[UIImage imageNamed:[self getImageName:self.imageIndex]]];
    }else{
        UIImageView *image = [self.view viewWithTag:20];
        [image setHidden:YES];
    }
}

- (NSString *)getImageName:(NSInteger)index{
    if (IS_IPHONE_X){
        NSArray *array = @[@"X1yindao",@"X3yindao",@"X4yindao",@"X5yindao",@"X6yindao",@"X2yindao"];
        NSLog(@"%@",NSLocalizedString(array[index], nil));
        return NSLocalizedString(array[index], nil);
    }else{
        NSArray *array = @[@"1yindao",@"3yindao",@"4yindao",@"5yindao",@"6yindao",@"2yindao"];
        return NSLocalizedString(array[index], nil);
    }
}

@end
