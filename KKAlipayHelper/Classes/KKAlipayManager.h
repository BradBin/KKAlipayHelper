//
//  KKAlipayManager.h
//  KKAlipayHelper
//
//  Created by 尤彬 on 2019/5/15.
//

#import <Foundation/Foundation.h>

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
 是否是开发环境,默认:false正式环境,反之开发环境
 
 @param enable 运行环境标识
 */
- (void)setDebugEnabled:(BOOL)enable;



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

@end

NS_ASSUME_NONNULL_END
