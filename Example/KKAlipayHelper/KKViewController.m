//
//  KKViewController.m
//  KKAlipayHelper
//
//  Created by BradBin on 05/15/2019.
//  Copyright (c) 2019 BradBin. All rights reserved.
//

#import "KKViewController.h"
#import "KKWebViewController.h"

@interface KKViewController ()
@property (nonatomic,strong) UIButton *aliPayBtn;

@end

@implementation KKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self kk_setupItem];
    [self kk_setupView];
}

- (void)kk_setupItem{
    self.navigationItem.title = @"支付宝";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"webAliPay" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = item;
    item.actionBlock = ^(UIBarButtonItem *eventItem) {
        BOOL isPush = false;
        if (isPush) {
            KKWebViewController *vc = [[KKWebViewController alloc] init];
            vc.isPush = isPush;
            [self.navigationController pushViewController:vc animated:true];
        }else{
            KKWebViewController *vc = [[KKWebViewController alloc] init];
            vc.isPush = isPush;
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navVC animated:true completion:nil];
        }
    };
}

- (void)kk_setupView{
    self.aliPayBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.masksToBounds = true;
        button.layer.cornerRadius  = 5.0;
        button.titleLabel.font     = [UIFont systemFontOfSize:16];
        [button setTitle:@"支付宝支付" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1AA1E6"]]
                          forState:UIControlStateNormal];
        [button addTarget:self action:@selector(kk_aliPayEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(button.superview.mas_safeAreaLayoutGuideBottom).offset(-30);
            } else {
                make.bottom.equalTo(button.superview.mas_bottom).offset(-30);
            }
            make.centerX.equalTo(button.superview.mas_centerX);
            make.width.equalTo(button.superview.mas_width).multipliedBy(0.75);
            make.height.mas_equalTo(@50);
        }];
        button;
    });
}

- (void)kk_aliPayEvent:(UIButton *)sender{
    
    [KKAlipayManager.shared payOrder:@"fasdfa" scheme:@"alisdkdemo" success:^(KKAlipayResultStatus status, NSDictionary * _Nonnull dict) {
        NSLog(@"success :  %ld",status);
    } failure:^(KKAlipayResultStatus status, NSDictionary * _Nonnull dict) {
        NSLog(@"failure :  %ld",status);
        [SVProgressHUD showErrorWithStatus:@"支付宝支付失败!"];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
