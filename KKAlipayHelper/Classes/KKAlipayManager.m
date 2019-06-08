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

- (NSString *)createRandomTradeNumber{
    NSUInteger count = 15;
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultString = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (NSUInteger i = 0; i < count; i++){
        NSUInteger index = rand() % [sourceString length];
        NSString *string = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [resultString appendString:string];
    }
    return resultString;
}


-(void)payOrderRequest:(KKAlipayRequest *)orderRequest scheme:(NSString *)scheme success:(KKAlipayBlock)success failure:(KKAlipayBlock)failure{
    if (orderRequest == nil) {
#ifdef DEBUG
        NSLog(@"支付宝请求信息类型为空");
#endif
        return;
    }
    if ([self kk_isNotBlank:scheme] == false) {
#ifdef DEBUG
        NSLog(@"支付宝scheme为空");
#endif
        return;
    }
    //拼接商品信息
    NSString *orderString       = [orderRequest kk_orderRequestWihtEncoded:false];
    NSString *encodeOrderString = [orderRequest kk_orderRequestWihtEncoded:true];
    
    if ([self kk_isNotBlank:encodeOrderString] == false) {
#ifdef DEBUG
        NSLog(@"支付宝请求信息类型为空");
#endif
        return;
    }
#ifdef DEBUG
    NSLog(@"orderString:%@  \n  encodeOrderString:%@",orderString,encodeOrderString);
#endif
    NSString *signedString = nil;
    self.success = success;
    self.failure = failure;
  
    //进行验签名
    if ([self kk_isNotBlank:signedString]) {
        [AlipaySDK.defaultService payOrder:orderString fromScheme:scheme callback:^(NSDictionary *resultDic) {
            
            
        }];
    }else{
        //验证签名失败
        if (self.failure) {
            NSMutableDictionary *dict = NSMutableDictionary.dictionary;
            self.failure(KKAlipayResultStatusFailure, dict);
        }
    }
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




#pragma mark -
- (NSString *) kk_URLEncodedString:(NSString *)urlString{
   urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    return urlString;
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
