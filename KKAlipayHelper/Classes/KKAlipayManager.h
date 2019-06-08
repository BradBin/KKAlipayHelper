//
//  KKAlipayManager.h
//  KKAlipayHelper
//
//  Created by 尤彬 on 2019/5/15.
//

#import <Foundation/Foundation.h>
#import "KKAlipayItem.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,KKAlipayResultStatus) {
    KKAlipayResultStatusSuccess,        //支付成功
    KKAlipayResultStatusFailure,        //支付失败
    KKAlipayResultStatusCancel,         //支付取消
    KKAlipayResultStatusUnknownCancel   //支付取消，交易已发起，状态不确定，商户需查询商户后台确认支付状态
};

/**
 支付回调block
 
 @param status 支付结果状态
 @param dict dict
 */
typedef void(^ _Nullable KKAlipayBlock)(KKAlipayResultStatus status,NSDictionary *dict);

@interface KKAlipayManager : NSObject

/**
 单例对象
 
 @return 单例对象
 */
+ (instancetype)shared;

/**
 是否安装支付宝App,默认是false:没有安装

 @return 是否安装支付宝
 */
- (BOOL)isAlipayAppInstalled;

/**
 是否是开发环境,默认:false正式环境,反之开发环境
 
 @param enable 运行环境标识
 */
- (void)setDebugEnabled:(BOOL)enable;

/**
 生成15位随机订单编号

 @return 随机订单编号
 */
- (NSString *)createRandomTradeNumber;

/**
 拉起支付宝支付
 备注:支付成功则去后台查询支付结果,再去展示给用户实际支付结果页面,一定
 不能以客户端返回作为用户支付结果

 @param orderRequest 支付签名请求,此签名由服务器签名订单后生成
 @param scheme url scheme
 @param success 成功h回调block
 @param failure 失败回调block
 */
- (void)payOrderRequest:(nonnull KKAlipayRequest *)orderRequest scheme:(NSString *)scheme success:(KKAlipayBlock)success failure:(KKAlipayBlock)failure;


/**
 处理客户端回调
 - (BOOL)application(UIApplication *)application openURL:(NSURL *)url
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 @param url url
 @return 回调结果
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 处理客户端回调
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 @param url url
 @return 回调结果
 */
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

/**
 处理客户端回调
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
 @param url url
 @return 回调结果
 */
- (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

@end

NS_ASSUME_NONNULL_END
