//
//  KKViewController.m
//  KKAlipayHelper
//
//  Created by BradBin on 05/15/2019.
//  Copyright (c) 2019 BradBin. All rights reserved.
//

#import "KKViewController.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import <KKAlipayHelper/KKAlipayHelper.h>

@interface KKViewController ()
@property (nonatomic,strong) UIButton *aliPayBtn;

@end

@implementation KKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self kk_setupView];
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
    
    [KKAlipayManager.shared payOrder:@"" scheme:@"" success:^(KKAlipayResultStatus status, NSDictionary * _Nonnull dict) {
        
    } failure:^(KKAlipayResultStatus status, NSDictionary * _Nonnull dict) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
