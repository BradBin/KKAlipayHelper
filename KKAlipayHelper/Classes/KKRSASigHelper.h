//
//  KKRSASigHelper.h
//  KKAlipayHelper
//
//  Created by 尤彬 on 2019/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRSASigHelper : NSObject

/**
 私有秘钥
 */
@property (nonatomic,  copy,readonly) NSString *privateKey;

/**
 单例对象
 
 @return 单例对象
 */
+ (instancetype)shared;


- (void)kk_privateKey:(NSString *)privateKey;

- (NSString *)kk_signWithString:(NSString *)string RSA2Enabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
