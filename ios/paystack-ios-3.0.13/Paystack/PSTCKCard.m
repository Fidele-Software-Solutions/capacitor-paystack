//
//  PSTCKCard.m
//  Paystack
//

#import "PSTCKCard.h"
#import "PaystackError.h"
#import "PSTCKCardValidator.h"
#import "NSDictionary+Paystack.h"

@interface PSTCKCard ()

@property (nonatomic, readwrite) NSString *cardId;
@property (nonatomic, readwrite) NSString *last4;
@property (nonatomic, readwrite) NSString *dynamicLast4;
@property (nonatomic, readwrite) PSTCKCardBrand brand;
@property (nonatomic, readwrite) PSTCKCardFundingType funding;
@property (nonatomic, readwrite) NSString *fingerprint;
@property (nonatomic, readwrite) NSString *country;
@property (nonatomic, readwrite, nonnull, copy) NSDictionary *allResponseFields;

@end

@implementation PSTCKCard

@dynamic number, cvc, expMonth, expYear, currency, name, addressLine1, addressLine2, addressCity, addressState, addressZip, addressCountry;

- (instancetype)init {
    self = [super init];
    if (self) {
        _brand = PSTCKCardBrandUnknown;
        _funding = PSTCKCardFundingTypeOther;
    }

    return self;
}

- (NSString *)last4 {
    return _last4 ?: [super last4];
}

- (NSString *)type {
    switch (self.brand) {
    case PSTCKCardBrandAmex:
        return @"American Express";
    case PSTCKCardBrandDinersClub:
        return @"Diners Club";
    case PSTCKCardBrandDiscover:
        return @"Discover";
    case PSTCKCardBrandJCB:
        return @"JCB";
    case PSTCKCardBrandMasterCard:
        return @"MasterCard";
    case PSTCKCardBrandVerve:
        return @"Verve";
    case PSTCKCardBrandVisa:
        return @"Visa";
    case PSTCKCardBrandUnknown:
        return @"Unknown";
    }
}

- (BOOL)isEqual:(id)other {
    return [self isEqualToCard:other];
}

- (NSUInteger)hash {
    return [self.cardId hash];
}

- (BOOL)isEqualToCard:(PSTCKCard *)other {
    if (self == other) {
        return YES;
    }

    if (!other || ![other isKindOfClass:self.class]) {
        return NO;
    }
    
    return [self.cardId isEqualToString:other.cardId];
}

#pragma mark PSTCKAPIResponseDecodable
+ (NSArray *)requiredFields {
    return @[@"id", @"last4", @"brand", @"exp_month", @"exp_year"];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    NSDictionary *dict = [response pstck_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
    if (!dict) {
        return nil;
    }
    
    PSTCKCard *card = [self new];
    card.cardId = dict[@"id"];
    card.name = dict[@"name"];
    card.last4 = dict[@"last4"];
    card.dynamicLast4 = dict[@"dynamic_last4"];
    NSString *brand = dict[@"brand"];
    if ([brand isEqualToString:@"Visa"]) {
        card.brand = PSTCKCardBrandVisa;
    } else if ([brand isEqualToString:@"American Express"]) {
        card.brand = PSTCKCardBrandAmex;
    } else if ([brand isEqualToString:@"MasterCard"]) {
        card.brand = PSTCKCardBrandMasterCard;
    } else if ([brand isEqualToString:@"Discover"]) {
        card.brand = PSTCKCardBrandDiscover;
    } else if ([brand isEqualToString:@"JCB"]) {
        card.brand = PSTCKCardBrandJCB;
    } else if ([brand isEqualToString:@"Diners Club"]) {
        card.brand = PSTCKCardBrandDinersClub;
    } else {
        card.brand = PSTCKCardBrandUnknown;
    }
    NSString *funding = dict[@"funding"];
    if ([funding.lowercaseString isEqualToString:@"credit"]) {
        card.funding = PSTCKCardFundingTypeCredit;
    } else if ([funding.lowercaseString isEqualToString:@"debit"]) {
        card.funding = PSTCKCardFundingTypeDebit;
    } else if ([funding.lowercaseString isEqualToString:@"prepaid"]) {
        card.funding = PSTCKCardFundingTypePrepaid;
    } else {
        card.funding = PSTCKCardFundingTypeOther;
    }
    card.fingerprint = dict[@"fingerprint"];
    card.country = dict[@"country"];
    card.currency = dict[@"currency"];
    card.expMonth = [dict[@"exp_month"] intValue];
    card.expYear = [dict[@"exp_year"] intValue];
    card.addressLine1 = dict[@"address_line1"];
    card.addressLine2 = dict[@"address_line2"];
    card.addressCity = dict[@"address_city"];
    card.addressState = dict[@"address_state"];
    card.addressZip = dict[@"address_zip"];
    card.addressCountry = dict[@"address_country"];
    
    card.allResponseFields = dict;
    return card;
}
#pragma clang diagnostic pop

@end
