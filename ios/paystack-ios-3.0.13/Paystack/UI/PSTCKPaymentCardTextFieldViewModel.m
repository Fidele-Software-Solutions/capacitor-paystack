//
//  PSTCKPaymentCardTextFieldViewModel.m
//  Paystack
//

#import "PSTCKPaymentCardTextFieldViewModel.h"
#import "PSTCKCardValidator.h"

#define FAUXPAS_IGNORED_IN_METHOD(...)

@interface NSString(PaystackSubstring)
- (NSString *)pstck_safeSubstringToIndex:(NSUInteger)index;
- (NSString *)pstck_safeSubstringFromIndex:(NSUInteger)index;
@end

@implementation NSString(PaystackSubstring)

- (NSString *)pstck_safeSubstringToIndex:(NSUInteger)index {
    return [self substringToIndex:MIN(self.length, index)];
}

- (NSString *)pstck_safeSubstringFromIndex:(NSUInteger)index {
    return (index > self.length) ? @"" : [self substringFromIndex:index];
}

@end

@implementation PSTCKPaymentCardTextFieldViewModel

- (void)setCardNumber:(NSString *)cardNumber {
    NSString *sanitizedNumber = [PSTCKCardValidator sanitizedNumericStringForString:cardNumber];
    PSTCKCardBrand brand = [PSTCKCardValidator brandForNumber:sanitizedNumber];
    NSInteger maxLength = [PSTCKCardValidator lengthForCardBrand:brand];
    _cardNumber = [sanitizedNumber pstck_safeSubstringToIndex:maxLength];
}

// This might contain slashes.
- (void)setRawExpiration:(NSString *)expiration {
    NSString *sanitizedExpiration = [PSTCKCardValidator sanitizedNumericStringForString:expiration];
    self.expirationMonth = [sanitizedExpiration pstck_safeSubstringToIndex:2];
    self.expirationYear = [[sanitizedExpiration pstck_safeSubstringFromIndex:2] pstck_safeSubstringToIndex:2];
}

- (NSString *)rawExpiration {
    NSMutableArray *array = [@[] mutableCopy];
    if (self.expirationMonth && ![self.expirationMonth isEqualToString:@""]) {
        [array addObject:self.expirationMonth];
    }
    
    if ([PSTCKCardValidator validationStateForExpirationMonth:self.expirationMonth] == PSTCKCardValidationStateValid) {
        [array addObject:self.expirationYear];
    }
    return [array componentsJoinedByString:@"/"];
}

- (void)setExpirationMonth:(NSString *)expirationMonth {
    NSString *sanitizedExpiration = [PSTCKCardValidator sanitizedNumericStringForString:expirationMonth];
    if (sanitizedExpiration.length == 1 && ![sanitizedExpiration isEqualToString:@"0"] && ![sanitizedExpiration isEqualToString:@"1"]) {
        sanitizedExpiration = [@"0" stringByAppendingString:sanitizedExpiration];
    }
    _expirationMonth = [sanitizedExpiration pstck_safeSubstringToIndex:2];
}

- (void)setExpirationYear:(NSString *)expirationYear {
    _expirationYear = [[PSTCKCardValidator sanitizedNumericStringForString:expirationYear] pstck_safeSubstringToIndex:2];
}

- (void)setCvc:(NSString *)cvc {
    NSInteger maxLength = [PSTCKCardValidator maxCVCLengthForCardBrand:self.brand];
    _cvc = [[PSTCKCardValidator sanitizedNumericStringForString:cvc] pstck_safeSubstringToIndex:maxLength];
}

- (PSTCKCardBrand)brand {
    return [PSTCKCardValidator brandForNumber:self.cardNumber];
}

- (PSTCKCardValidationState)validationStateForField:(PSTCKCardFieldType)fieldType {
    switch (fieldType) {
        case PSTCKCardFieldTypeNumber:
            return [PSTCKCardValidator validationStateForNumber:self.cardNumber validatingCardBrand:YES];
            break;
        case PSTCKCardFieldTypeExpiration: {
            PSTCKCardValidationState monthState = [PSTCKCardValidator validationStateForExpirationMonth:self.expirationMonth];
            PSTCKCardValidationState yearState = [PSTCKCardValidator validationStateForExpirationYear:self.expirationYear inMonth:self.expirationMonth];
            if (monthState == PSTCKCardValidationStateValid && yearState == PSTCKCardValidationStateValid) {
                return PSTCKCardValidationStateValid;
            } else if (monthState == PSTCKCardValidationStateInvalid || yearState == PSTCKCardValidationStateInvalid) {
                return PSTCKCardValidationStateInvalid;
            } else {
                return PSTCKCardValidationStateIncomplete;
            }
            break;
        }
        case PSTCKCardFieldTypeCVC:
            return [PSTCKCardValidator validationStateForCVC:self.cvc cardBrand:self.brand];
    }
}

- (BOOL)isValid {
    return ([self validationStateForField:PSTCKCardFieldTypeNumber] == PSTCKCardValidationStateValid &&
            [self validationStateForField:PSTCKCardFieldTypeExpiration] == PSTCKCardValidationStateValid &&
            [self validationStateForField:PSTCKCardFieldTypeCVC] == PSTCKCardValidationStateValid);
}

- (NSString *)defaultPlaceholder {
    return @"1234 5678 1234 5678 000";
}

- (NSString *)numberWithoutLastDigits {
    NSUInteger length = [PSTCKCardValidator fragmentLengthForCardBrand:[PSTCKCardValidator brandForNumber:self.cardNumber]];
    NSUInteger toIndex = self.cardNumber.length - length;
    
    return (toIndex < self.cardNumber.length) ?
        [self.cardNumber substringToIndex:toIndex] :
        [self.defaultPlaceholder pstck_safeSubstringToIndex:[self defaultPlaceholder].length - length];

}

@end
