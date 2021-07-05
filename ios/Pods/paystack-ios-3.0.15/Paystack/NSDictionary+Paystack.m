//
//  NSDictionary+Paystack.m
//  Paystack
//

#import "NSDictionary+Paystack.h"

@implementation NSDictionary (Paystack)

- (nullable NSDictionary *)pstck_dictionaryByRemovingNullsValidatingRequiredFields:(nonnull NSArray *)requiredFields {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, __unused BOOL *stop) {
        if (obj != [NSNull null]) {
            dict[key] = obj;
        }
    }];
    for (NSString *key in requiredFields) {
        if (![[dict allKeys] containsObject:key]) {
            return nil;
        }
    }
    return [dict copy];
}

@end

void linkDictionaryCategory(void){}
