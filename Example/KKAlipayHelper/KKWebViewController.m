//
//  KKWebViewController.m
//  KKAlipayHelper_Example
//
//  Created by Macbook Pro 15.4  on 2019/6/8.
//  Copyright © 2019 BradBin. All rights reserved.
//

#import "KKWebViewController.h"

@interface KKWebViewController ()<WKUIDelegate,WKNavigationDelegate,KKWebApiProtocol>
@property (nonatomic,strong) DWKWebView     *webView;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) NSArray        *webApis;
@property (nonatomic,strong) NSString       *webURLString;

@end

@implementation KKWebViewController

- (instancetype)initWithWebURLString:(NSString *)webURLString webApis:(NSArray *)webApis{
    self = [super init];
    if (self) {
        _webURLString = [webURLString copy];
        _webApis      = [webApis copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webURLString = @"https://gateway.51allin.io/alipayM.html?oid=402019061023043811618&amount=97.95";
    [self kk_setupItem];
    [self kk_setupView];
    [self kk_setupViewModel];
    // Do any additional setup after loading the view.
}

- (void)kk_setupViewModel{
    
}




- (void)kk_setupItem{
    self.navigationItem.title = @"支付宝(web)";
    UIBarButtonItem *item     = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    self.navigationItem.rightBarButtonItem = item;
    @weakify(self);
    item.actionBlock = ^(UIBarButtonItem *eventItem) {
        @strongify(self);
        if (self.isPush) {
            if ([self.webView canGoBack]) {
                [self.webView goBack];
            }else{
                [self.navigationController popViewControllerAnimated:true];
            }
        }else{
            if ([self.webView canGoBack]) {
                [self.webView goBack];
            }else{
                [self dismissViewControllerAnimated:true completion:nil];
            }
        }
    };
}

- (void)kk_setupView{
    self.view.backgroundColor = UIColor.whiteColor;
    self.webView = ({
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.suppressesIncrementalRendering = YES; // 是否支持记忆读取
        DWKWebView *view = [[DWKWebView alloc] initWithFrame:CGRectZero configuration:config];
        view.DSUIDelegate = self;
        view.navigationDelegate = self;
        view.allowsBackForwardNavigationGestures = YES;
        [view addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [view addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.superview.mas_top);
            make.centerX.equalTo(view.superview.mas_centerX);
            make.width.equalTo(view.superview.mas_width);
            make.bottom.equalTo(view.superview.mas_bottom);
        }];
        view;
    });
    
    self.progressView = ({
        UIProgressView *view   = UIProgressView.alloc.init;
        view.backgroundColor = UIColor.orangeColor;
        view.tintColor = [UIColor redColor];
        view.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:view];
        [self.view insertSubview:view aboveSubview:self.webView];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.superview.mas_top).offset(88);
            make.centerX.equalTo(view.superview.mas_centerX);
            make.width.equalTo(view.superview.mas_width);
            make.height.mas_equalTo(CGFloatPixelRound(2.5));
        }];
        view;
    });
    
    
    
    [self.webView setDebugMode:true];
    
    if (self.webApis) {
        for (KKWebApi *webApi in self.webApis) {
            webApi.delegate = self;
            [self.webView addJavascriptObject:webApi namespace:nil];
        }
    }
    
    @weakify(self);
    [self kk_deleteWebCacheWithBlock:^{
        @strongify(self);
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURLString]]];
    }];
    
}





- (void)kk_deleteWebCacheWithBlock:(void(^)(void))block {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        //        NSSet *websiteDataTypes = [NSSet setWithArray:@[
        //                                                        WKWebsiteDataTypeDiskCache,
        //                                                        //WKWebsiteDataTypeOfflineWebApplicationCache,
        //                                                        WKWebsiteDataTypeMemoryCache,
        //                                                        WKWebsiteDataTypeLocalStorage,
        //                                                        //WKWebsiteDataTypeCookies,
        //                                                        //WKWebsiteDataTypeSessionStorage,
        //                                                        //WKWebsiteDataTypeIndexedDBDatabases,
        //                                                        //WKWebsiteDataTypeWebSQLDatabases
        //                                                        ]];
        //// All kinds of data
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            // Done
            if (block) {
                block();
            }
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        if (block) {
            block();
        }
    }
}


#pragma mark -- WebApi Delegate
- (void)kk_errorHaveFonudWithWebApi:(KKWebApi *)webApi errorMsg:(NSString *)errorMsg {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isPush) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:true completion:nil];
        }
    });
}



-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = false;
//    self.title = webView.title;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable ss, NSError * _Nullable error) {
        NSLog(@"----document.title:%@---webView title:%@",ss,webView.title);
    }];
}

-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
     NSLog(@"--- %@",navigation);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
     NSLog(@"--- %@",@"webViewWebContentProcessDidTerminate");
}

//根据URL决定是否跳转导航
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString* reqUrl = navigationAction.request.URL.absoluteString;
    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        BOOL bSucc = [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
        if (!bSucc) {
            // NOTE: 跳转itune下载支付宝App
            NSString* urlStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
            NSLog(@"执行相关操作 :  %@",urlStr);
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//是否允许加载内容
-(void)webView:(WKWebView *)webView decidePolicyForNavigatiionResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{

}

-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{

}

-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{

}




#pragma mark - KVC
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        newprogress = newprogress > 0.2 ? newprogress : 0.2;
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }else if (object == self.webView && [keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = [change objectForKey:NSKeyValueChangeNewKey];
    }
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
