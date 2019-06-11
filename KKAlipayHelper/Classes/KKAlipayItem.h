//
//  KKAlipayItem.h
//  KKAlipayHelper
//
//  Created by 尤彬 on 2019/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 商户签名算法类型

 - KKSignTypeRSA2: RSA2 密钥长度2048
 - KKSignTypeRSA:  RSA  密钥长度1024
 */
typedef NS_ENUM(NSUInteger,KKSignType) {
    KKSignTypeRSA2 = 0,
    KKSignTypeRSA
};


/**
 参数编码格式

 - KKCharsetTypeUTF_8: utf-8
 */
typedef NS_ENUM(NSUInteger,KKCharsetType) {
    KKCharsetTypeUTF_8 = 0,
};

/**
 授权类型

 - KKAuthTypeLOGIN: 登录
 - KKAuthTypeAUTHACCOUNT: 授权
 */
typedef NS_ENUM(NSInteger,KKAuthType) {
    KKAuthTypeLOGIN = 0,
    KKAuthTypeAUTHACCOUNT
};

/**
 业务参数类
 */
@interface KKAlipayOrder : NSObject

/**
 Optional 商品描述
 */
@property (nonatomic,  copy) NSString *productDesc;

/**
 Required 商品销售码
 备注:商品和支付宝签约的产品妈
 */
@property (nonatomic,  copy) NSString *productCode;

/**
 Required 商品标题/交易标题/订单标题/订单关键字等
 */
@property (nonatomic,  copy) NSString *tradeName;
/**
 Required 商品订单编号(唯一性)
 */
@property (nonatomic,  copy) NSString *tradeNum;

/**
 Required 商品提交订单后,订单的有效期限,逾期将关闭交易
 备注: 1m~15d  m:分钟 h:小时 d:天 1c:当天有效
 */
@property (nonatomic,  copy) NSString *timeoutExpress;

/**
 Required 订单总金额 单位:人民币¥
 备注:精确小数点后两位 取值范围[0.01,100 000 000]
 */
@property (nonatomic,  copy) NSString *totalAmount;

/**
 Required 收款支付宝用户ID
 备注:该字段为空时,默认为商户签约账号对应的支付宝Id
 */
@property (nonatomic,  copy) NSString *sellerId;

@end






#pragma mark -
#pragma mark - 订单信息类型

/**
 订单信息类型模型
 备注:支付款信息的详情
 */
@interface KKAlipayRequest : NSObject

/**
 Required 支付宝分配至应用的ID
 */
@property (nonatomic,  copy) NSString *appId;

/**
 Required 支付宝接口名称
 */
@property (nonatomic,  copy) NSString *method;

/**
 Optional 仅支持JSON
 */
@property (nonatomic,  copy) NSString *format;

/**
 Optional 授权回调地址
 */
@property (nonatomic,  copy) NSString *returnURLString;

/**
 Required 参数编码格式
 备注:utf-8,gbk,gb2312等
 */
@property (nonatomic,  copy) NSString *charset;

/**
 Required 请求订单时间
 备注L:yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic,  copy) NSString *timestamp;

/**
 Optional 请求调用接口版本
 备注:固定为1.0
 */
@property (nonatomic,  copy) NSString *version;

/**
 Required 支付宝服务器主动通知商户服务器里指定的页面
 备注: http/https路径,推荐商户使用 https
 */
@property (nonatomic,  copy) NSString *notifyURLString;

/**
 Optional 商户授权令牌
 */
@property (nonatomic,  copy) NSString *app_auth_token;

/**
 Required 业务请求数据
 */
@property (nonatomic,strong) KKAlipayOrder *biz_content;

/**
 Required 商户签名算法类型
 备注: RSA2/RSA
 */
@property (nonatomic,assign) KKSignType signType;


- (NSString *)kk_orderRequestWihtEncoded:(BOOL)encoded;

@end



#pragma mark -
#pragma mark - 支付宝授权类

/**
 支付宝授权类
 */
@interface  KKAlipayAuthorRequest : NSObject

/**
 Required 服务接口名称
 */
@property (nonatomic, copy) NSString *apiname;

/**
 Required 调用方App标识
 备注:mc代表外部商户
 */
@property (nonatomic, copy) NSString *appName;

/**
 Required 调用业务类型
 备注:openservice代表开放基础服务
 */
@property (nonatomic, copy) NSString *bizType;

/**
 Required 产品码
 备注:目前只有WAP_FAST_LOGIN
 */
@property (nonatomic, copy) NSString *productID;

/**
 Required 支付宝分配至应用的ID
 备注: 签约平台内的appid
 */
@property (nonatomic, copy) NSString *appID;

/**
 Required 商户签约id
 */
@property (nonatomic, copy) NSString *pid;

/**
 Required 授权类型
 备注:默认是 登录
 */
@property (nonatomic,assign) KKAuthType authType;

/**
  Required 商户请求id需要为unique,回调使用
 */
@property (nonatomic, copy) NSString *targetID;

/**
  Optional oauth里的授权范围，PD配置,默认为kuaijie
 */
@property (nonatomic, copy) NSString *scope;

/**
 Optional 固定值，alipay.open.auth.sdk.code.get
 */
@property (nonatomic, copy) NSString *method;

@end




NS_ASSUME_NONNULL_END
