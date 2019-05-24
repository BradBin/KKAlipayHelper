//
//  KKRSASigHelper.m
//  KKAlipayHelper
//
//  Created by 尤彬 on 2019/5/24.
//

#import "KKRSASigHelper.h"


@interface KKRSASigHelper ()
@property (nonatomic,  copy) NSString *privateKey;

@end

@implementation KKRSASigHelper

+(instancetype)shared{
    static KKRSASigHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    _instance;
}

-(void)kk_privateKey:(NSString *)privateKey{
    _privateKey = [privateKey copy];
}



-(NSString *)kk_signWithString:(NSString *)string RSA2Enabled:(BOOL)enabled{
    NSString *signString = nil;
    NSString *path       = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *signPath   = [path stringByAppendingPathComponent:@"AlixPay-RSAPrivateKey"];
    
    
}

#pragma mark -
#pragma mark -
//- (NSString *)kk_formatterPrivateKey:(NSString *)privateKey{
//    const char *pString = [privateKey UTF8String];
//    
//}



@end
