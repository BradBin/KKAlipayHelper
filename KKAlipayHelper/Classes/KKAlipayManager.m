//
//  KKAlipayManager.m
//  KKAlipayHelper
//
//  Created by 尤彬 on 2019/5/15.
//

#import "KKAlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>

NSString *const kkSafepay      = @"safepay";
NSString *const kkAlipaySign   = @"alipay://";
NSString *const kkAlipayClient = @"alipay://alipayclient/?";


NSString *const kkResultStatus = @"resultStatus";



@interface KKAlipayManager ()
/**
 默认:fasle正式环境
 */
@property (nonatomic,assign) BOOL isDebug;

/**
 私钥
 */
@property(nonatomic, copy) NSString *privateKey;

/**
 默认false:rsa 反之true:rsa2
 */
@property (nonatomic,assign) BOOL rsa2;

/**
 支付成功回调block
 */
@property (nonatomic, copy) KKAlipayBlock success;
/**
 支付失败回调block
 */
@property (nonatomic, copy) KKAlipayBlock failure;

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

- (BOOL)isAlipayAppInstalled{
    return [UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:kkAlipaySign]];
}

-(void)setDebugEnabled:(BOOL)enable{
    _isDebug = enable;
}


-(void)payOrder:(NSString *)order scheme:(NSString *)scheme success:(KKAlipayBlock)success failure:(KKAlipayBlock)failure{
    
    self.success = success;
    self.failure = failure;
    
    if ([self kk_isNotBlank:order] == false) {
        NSMutableDictionary *dict = NSMutableDictionary.dictionary;
        self.failure(KKAlipayResultStatusFailure, dict);
        return;
    }
    
    if ([self kk_isNotBlank:scheme] == false) {
        NSMutableDictionary *dict = NSMutableDictionary.dictionary;
        self.failure(KKAlipayResultStatusFailure, dict);
        return;
    }
    
    
    __weak __typeof(self) weakSelf = self;
    [AlipaySDK.defaultService payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (resultDic) {
            if ([resultDic.allKeys containsObject:kkResultStatus]) {
                NSInteger statusCode = [[resultDic objectForKey:kkResultStatus] integerValue];
                KKAlipayResultStatus result = KKAlipayResultStatusFailure;
                switch (statusCode) {
                    case 9000:{
                        if (strongSelf.success)
                            strongSelf.success(KKAlipayResultStatusSuccess, resultDic);
                    } break;
                        
                        case 8000:
                        result = KKAlipayResultStatusFailure;
                        break;
                        
                    case 4000:{
                        if (strongSelf.failure)
                            strongSelf.failure(KKAlipayResultStatusFailure, resultDic);
                    } break;
                        
                    case 6001:{
                        if (strongSelf.failure)
                            strongSelf.failure(KKAlipayResultStatusCancel, resultDic);
                    } break;
                        
                    case 6002:{
                        if (strongSelf.failure)
                            strongSelf.failure(KKAlipayResultStatusNetworkError, resultDic);
                    } break;
                        
                    case 6004:{
                        if (strongSelf.failure)
                            strongSelf.failure(KKAlipayResultStatusUnknown, resultDic);
                    }break;
                    
                    default:{
                        if (strongSelf.failure)
                            strongSelf.failure(KKAlipayResultStatusOthers, resultDic);
                    } break;
                }
            
            }else{
                if (strongSelf.failure) {
                    strongSelf.failure(KKAlipayResultStatusFailure, resultDic);
                }
            }
        }else{
            if (strongSelf.failure) {
                NSMutableDictionary *dict = NSMutableDictionary.dictionary;
                strongSelf.failure(KKAlipayResultStatusFailure, dict);
            }
        }
    }];
}



-(BOOL)handleOpenURL:(NSURL *)url{
    if ([url.host isEqualToString:kkSafepay]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [AlipaySDK.defaultService processAuthResult:url standbyCallback:^(NSDictionary *result) {
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [AlipaySDK.defaultService processAuth_V2Result:url standbyCallback:^(NSDictionary *result) {
            
        }];
    }
    return true;
}

-(BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication{
    if ([url.host isEqualToString:kkSafepay]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [AlipaySDK.defaultService processAuthResult:url standbyCallback:^(NSDictionary *result) {
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [AlipaySDK.defaultService processAuth_V2Result:url standbyCallback:^(NSDictionary *result) {
            
        }];
    }
    return true;
}


-(BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if ([url.host isEqualToString:kkSafepay]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [AlipaySDK.defaultService processAuthResult:url standbyCallback:^(NSDictionary *result) {
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [AlipaySDK.defaultService processAuth_V2Result:url standbyCallback:^(NSDictionary *result) {
            
        }];
    }
    return true;
}




#pragma mark - private method
#pragma mark - 判断字符串是否为空
/**
 判断字符串是否为空,并返回结果
 
 @param string 字符串
 @return true:字符串不为空 otherwise:false则反之
 */
- (BOOL)kk_isNotBlank:(NSString *)string {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < string.length; ++i) {
        unichar c = [string characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}


@end
