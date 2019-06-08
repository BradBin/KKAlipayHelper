//
//  KKWebViewController.h
//  KKAlipayHelper_Example
//
//  Created by Macbook Pro 15.4  on 2019/6/8.
//  Copyright © 2019 BradBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKWebApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKWebViewController : UIViewController

@property (nonatomic,assign) BOOL isPush;
- (instancetype)initWithWebURLString:(NSString *)webURLString webApis:(NSArray *)webApis;

@end

NS_ASSUME_NONNULL_END
