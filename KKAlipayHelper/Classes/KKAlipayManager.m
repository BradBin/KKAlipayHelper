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

@interface KKAlipayManager ()
/**
 默认:fasle正式环境
 */
@property (nonatomic,assign) BOOL isDebug;
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
    if (order == nil) {
        return;
    }
    if (scheme == nil) {
        return;
    }
    if ([self isAlipayAppInstalled]) {
        return;
    }
  
    self.success = success;
    self.failure = failure;
 
    NSDictionary *pama = @{
                           @"fromAppUrlScheme":scheme,
                           @"requestType"     :kkSafepay,
                           @"dataString"      :order
                           };
    
    NSError *error          = nil;
    NSData *data            = [NSJSONSerialization dataWithJSONObject:pama options:NSJSONWritingPrettyPrinted error:&error];
    NSString *dataString    = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *encodeString  = [self kk_URLEncodedString:dataString];
    
    NSString *openURLString =  [NSString stringWithFormat:@"%@%@",kkAlipayClient,encodeString];
    NSURL *openURL          = [NSURL URLWithString:openURLString];
    
    
    [AlipaySDK.defaultService payOrder:@"" fromScheme:scheme callback:^(NSDictionary *resultDic) {
        
        
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

#pragma mark -
- (NSString *) kk_URLEncodedString:(NSString *)urlString{
   urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    return urlString;
}


@end
