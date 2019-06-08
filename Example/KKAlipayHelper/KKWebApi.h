//
//  KKWebApi.h
//  KKAlipayHelper_Example
//
//  Created by Macbook Pro 15.4  on 2019/6/8.
//  Copyright © 2019 BradBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKWebApiProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKWebApi : NSObject

@property (nonatomic, weak) id<KKWebApiProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
