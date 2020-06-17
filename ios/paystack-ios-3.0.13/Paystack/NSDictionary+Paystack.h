//
//  NSDictionary+Paystack.h
//  Paystack
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Paystack)

- (nullable NSDictionary *)pstck_dictionaryByRemovingNullsValidatingRequiredFields:(nonnull NSArray *)requiredFields;

@end

void linkDictionaryCategory(void);
