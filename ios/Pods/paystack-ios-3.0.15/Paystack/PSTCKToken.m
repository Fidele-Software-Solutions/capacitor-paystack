//
//  PSTCKToken.m
//  Paystack
//

#import "PSTCKToken.h"
#import "PSTCKCard.h"
#import "NSDictionary+Paystack.h"

@interface PSTCKToken()
@property (nonatomic, nonnull) NSString *tokenId;
@property (nonatomic) NSString *last4;
@property (nonatomic) NSString *message;
//@property (nonatomic) BOOL livemode;
@property (nonatomic, nullable) PSTCKCard *card;
@property (nonatomic, nullable) NSDate *created;
@property (nonatomic, readwrite, nonnull, copy) NSDictionary *allResponseFields;
@end

@implementation PSTCKToken

- (NSString *)description {
    return self.tokenId ?: @"Unknown token";
}

- (NSString *)debugDescription {
    NSString *token = self.tokenId ?: @"Unknown token";
    NSString *last4 = self.last4 ?: @"Unknown last 4";
    NSString *message = self.message ?: @"Unknown Message";
    return [NSString stringWithFormat:@"%@ (%@)ending with %@", token, message, last4];
}

- (BOOL)isEqual:(id)object {
    return [self isEqualToToken:object];
}

- (NSUInteger)hash {
    return [self.tokenId hash];
}

- (BOOL)isEqualToToken:(PSTCKToken *)object {
    if (self == object) {
        return YES;
    }

    if (!object || ![object isKindOfClass:self.class]) {
        return NO;
    }

    if ((self.card || object.card) && (![self.card isEqual:object.card])) {
        return NO;
    }

    //    return self.livemode == object.livemode && [self.tokenId isEqualToString:object.tokenId] && [self.created isEqualToDate:object.created] &&
    //           [self.card isEqual:object.card] && [self.tokenId isEqualToString:object.tokenId] && [self.created isEqualToDate:object.created];
    return [self.tokenId isEqualToString:object.tokenId] &&[self.message isEqualToString:object.message] &&
              [self.last4 isEqualToString:object.last4] ;
    
}

#pragma mark PSTCKAPIResponseDecodable

+ (NSArray *)requiredFields {
    //return @[@"id", @"livemode", @"created"];
    return @[@"status", @"message"];
}

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    NSDictionary *dict = [response pstck_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
    if (!dict) {
        return nil;
    }

    // only status 0 is an error
    if ([[dict[@"status"] description] isEqual: @"0"]) {
        return nil;
    }
    
    PSTCKToken *token = [self new];
    token.tokenId = dict[@"token"];
    token.message = dict[@"message"];
    token.last4 = dict[@"last4"];
//    token.livemode = [dict[@"livemode"] boolValue];
//    token.created = [NSDate dateWithTimeIntervalSince1970:[dict[@"created"] doubleValue]];
    
//    NSDictionary *cardDictionary = dict[@"card"];
//    if (cardDictionary) {
//        token.card = [PSTCKCard decodedObjectFromAPIResponse:cardDictionary];
//    }
    
    token.allResponseFields = dict;
    return token;
}

@end
