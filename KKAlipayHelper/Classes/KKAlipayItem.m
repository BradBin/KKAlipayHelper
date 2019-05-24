//
//  KKAlipayItem.m
//  KKAlipayHelper
//
//  Created by 尤彬 on 2019/5/24.
//

#import "KKAlipayItem.h"

@implementation KKAlipayOrder

-(NSString *)description{
    NSMutableDictionary *mDict = NSMutableDictionary.dictionary;
    [mDict addEntriesFromDictionary:@{
                                      @"subject"     :_tradeName?  :@"",
                                      @"out_trade_no":_tradeNum?   :@"",
                                      @"total_amount":_totalAmount?:@"",
                                      @"seller_id"   :_sellerId?   :@"",
                                      @"product_code":_productCode? :@"QUICK_MSECURITY_PAY"
                                      }];
    
    if (_productDesc.length > 0) {
        [mDict setObject:_productDesc forKey:@"body"];
    }
    if (_timeoutExpress.length > 0) {
        [mDict setObject:_timeoutExpress forKey:@"timeout_express"];
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@" An exception occurred in the description of KKAlipayItem. error: %@",error.localizedDescription);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end




#pragma mark -
#pragma mark - 订单信息类型
@implementation KKAlipayRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _version   = @(1.0).stringValue;
        _signType  = KKSignTypeRSA2;
        _timestamp = [self kk_createTimestamp];
    }
    return self;
}

- (NSString *)kk_orderRequestWihtEncoded:(BOOL)encoded{
    if (_appId.length <= 0) {
        NSLog(@"支付宝分配给应用的ID为空");
        return nil;
    }
    
    NSMutableDictionary *mDict = NSMutableDictionary.dictionary;
    [mDict addEntriesFromDictionary:@{
                                      @"app_id"     :_appId,
                                      @"method"     :_method?   :@"alipay.trade.app.pay",
                                      @"charset"    :_charset?  :@"utf-8",
                                      @"timestamp"  :_timestamp?:@"",
                                      @"version"    :_version?  :@"1.0",
                                      @"biz_content":_biz_content.description? :@"",
                                      @"sign_type"  :_signType == KKSignTypeRSA2? @"RSA2" : @"RSA"
                                      }];
    if (_format.length > 0) {
        [mDict setObject:_format forKey:@"format"];
    }
    if (_returnURLString.length > 0) {
        [mDict setObject:_returnURLString forKey:@"return_url"];
    }
    if (_notifyURLString.length > 0) {
        [mDict setObject:_notifyURLString forKey:@"notify_url"];
    }
    if (_app_auth_token.length > 0) {
        [mDict setObject:_app_auth_token forKey:@"app_auth_token"];
    }
    
    // NOTE: 排序，得出最终请求字串
    NSArray* sortedArray = [[mDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *array = NSMutableArray.array;
    for (NSString* key in sortedArray) {
        NSString* orderItem = [self kk_orderItemWithKey:key value:[mDict objectForKey:key] encoded:encoded];
        if (orderItem.length > 0) {
            [array addObject:orderItem];
        }
    }
    return [array componentsJoinedByString:@"&"];
}

/**
 生成订单发起时间字符串

 @return 订单时间字符串
 */
- (NSString *)kk_createTimestamp{
    NSDate *date = NSDate.date;
    NSDateFormatter *formatter = NSDateFormatter.alloc.init;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

/**
 编码处理后Key=value

 @param key key
 @param value value
 @param encoded encoded
 @return 编码后字符串
 */
- (NSString *)kk_orderItemWithKey:(NSString *)key value:(NSString *)value encoded:(BOOL)encoded{
    if (key.length > 0 && value.length > 0) {
        if (encoded) {
            value = [self kk_encodeValue:value];
        }
        return [NSString stringWithFormat:@"%@=%@",key,value];
    }
    return nil;
}

/**
 编码字符串

 @param value value
 @return encodeValue
 */
- (NSString *)kk_encodeValue:(NSString *)value{
    NSString *enValue = value;
    if (value.length > 0) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"].invertedSet;
        enValue = [value stringByAddingPercentEncodingWithAllowedCharacters:set];
    }
    return enValue;
}

@end




#pragma mark -
#pragma mark -  支付宝授权类
@implementation KKAlipayAuthorRequest



@end
