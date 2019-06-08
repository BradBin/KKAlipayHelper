//
//  KKWebApiProtocol.h
//  KKAlipayHelper_Example
//
//  Created by Macbook Pro 15.4  on 2019/6/8.
//  Copyright © 2019 BradBin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKWebApi;


@protocol KKWebApiProtocol <NSObject>

@optional
- (void)kk_errorHaveFonudWithWebApi:(KKWebApi *)webApi errorMsg:(NSString *)errorMsg;


@end
