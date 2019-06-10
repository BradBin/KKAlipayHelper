//
//  KKCryptoHelper.h
//  KKUnionPayHelper_Example
//
//  Created by 尤彬 on 2019/6/6.
//  Copyright © 2019 BradBin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKCryptoHelper : NSObject

/**
 获取3DESKey 默认24个0
 */
@property (nonatomic,copy,readonly) NSString *threeDesKey;

/**
 是RSA2还是RSA类型 默认是false is RSA
 */
@property (nonatomic,assign,readonly) BOOL isRSA2;

/**
 单例管理对象

 @return 对象实例
 */
+ (instancetype)shared;


/***************3DES加密/解密相关部分*****************/

/**
 设置默认3DESKey秘钥

 @param key key
 */
- (void)kk_setDefault3DESKey:(nonnull NSString *)key;

/**
 对字符串进行3DES加密

 @param string 待加密字符串
 @return 3DES加密后的字符串
 */
- (nonnull NSString *)kk_3DES_EncryptWithString:(nonnull NSString *)string;

/**
 对字符串进行3DES解密

 @param string 3DES加密字符串
 @return 解密后字符串
 */
- (nonnull NSString *)kk_3DES_DecryptWithCryptoString:(nonnull NSString *)string ;

/**
 对字符串进行3DES加密
 
 @param string 待加密字符串
 @param key key秘钥
 @return 3DES加密后的字符串
 */
- (nonnull NSString *)kk_3DES_EncryptWithString:(nonnull NSString *)string key:(nonnull NSString *)key;

/**
 对字符串进行3DES解密
 
 @param string 3DES加密字符串
 @param key key秘钥
 @return 解密后字符串
 */
- (nonnull NSString *)kk_3DES_DecryptWithCryptoString:(nonnull NSString *)string key:(nonnull NSString *)key;




/***************RSA加密/解密相关部分*****************/


/**
 设置是RSA2还是RSA类型

 @param rsa2 默认:false is RSA ,Otherwise true is RSA2
 */
- (void)kk_setRSA2:(BOOL)rsa2;

/**
 对字符串进行RSA公钥加密(公钥:.der)

 @param str 需要加密的字符串
 @param path .der格式的公钥文件路径
 @return 加密后的字符串
 */
- (NSString *)kk_RSA_EncryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path;

/**
 对字符串进行RSA公钥加密(公钥:.p12文件)

 @param str 需要加密的字符串
 @param path .p12格式的私钥文件路径
 @param password 私钥文件密码
 @return 加密后的字符串
 */
- (NSString *)kk_RSA_DecryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

/**
 对字符串进行RSA公钥加密

 @param str 需要加密的字符串
 @param pubKey 公钥字符串
 @return 加密后的字符串
 */
- (NSString *)kk_RSA_EncryptString:(NSString *)str publicKey:(NSString *)pubKey;

/**
 对待解密的字符串进行私钥解密

 @param str 待解密的字符串
 @param privKey 私钥
 @return 解密后的字符串
 */
- (NSString *)kk_RSA_DecryptString:(NSString *)str privateKey:(NSString *)privKey;



@end

NS_ASSUME_NONNULL_END
