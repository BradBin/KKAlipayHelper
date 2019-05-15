//
//  KKAlipayManager.m
//  KKAlipayHelper
//
//  Created by 尤彬 on 2019/5/15.
//

#import "KKAlipayManager.h"

@interface KKAlipayManager ()
/**
 默认:fasle正式环境
 */
@property (nonatomic,assign) BOOL isDebug;
/**
 支付成功回调block
 */
@property (nonatomic, copy) KKAlipayBlock successBlock;
/**
 支付失败回调block
 */
@property (nonatomic, copy) KKAlipayBlock failureBlock;

@end

@implementation KKAlipayManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isDebug = false;
    }
    return self;
}

+(instancetype)shared{
    static KKAlipayManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

-(void)setDebugEnabled:(BOOL)enable{
    _isDebug = enable;
}

-(BOOL)handleOpenURL:(NSURL *)url{
    return true;
}


-(BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication{
    return true;
}

@end
