//
//  PSTCKCardValidator.m
//  Paystack
//

#import "PSTCKCardValidator.h"

@implementation PSTCKCardValidator

+ (NSString *)sanitizedNumericStringForString:(NSString *)string {
    NSCharacterSet *set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:set];
    return [components componentsJoinedByString:@""] ?: @"";
}

+ (NSString *)stringByRemovingSpacesFromString:(NSString *)string {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:set];
    return [components componentsJoinedByString:@""];
}

+ (BOOL)stringIsNumeric:(NSString *)string {
    return [[self sanitizedNumericStringForString:string] isEqualToString:string];
}

+ (PSTCKCardValidationState)validationStateForExpirationMonth:(NSString *)expirationMonth {

    NSString *sanitizedExpiration = [self stringByRemovingSpacesFromString:expirationMonth];
    
    if (![self stringIsNumeric:sanitizedExpiration]) {
        return PSTCKCardValidationStateInvalid;
    }
    
    switch (sanitizedExpiration.length) {
        case 0:
            return PSTCKCardValidationStateIncomplete;
        case 1:
            return ([sanitizedExpiration isEqualToString:@"0"] || [sanitizedExpiration isEqualToString:@"1"]) ? PSTCKCardValidationStateIncomplete : PSTCKCardValidationStateValid;
        case 2:
            return (0 < sanitizedExpiration.integerValue && sanitizedExpiration.integerValue <= 12) ? PSTCKCardValidationStateValid : PSTCKCardValidationStateInvalid;
        default:
            return PSTCKCardValidationStateInvalid;
    }
}

+ (PSTCKCardValidationState)validationStateForExpirationYear:(NSString *)expirationYear inMonth:(NSString *)expirationMonth inCurrentYear:(NSInteger)currentYear currentMonth:(NSInteger)currentMonth {
    
    NSInteger moddedYear = currentYear % 100;
    
    if (![self stringIsNumeric:expirationMonth] || ![self stringIsNumeric:expirationYear]) {
        return PSTCKCardValidationStateInvalid;
    }
    
    NSString *sanitizedMonth = [self sanitizedNumericStringForString:expirationMonth];
    NSString *sanitizedYear = [self sanitizedNumericStringForString:expirationYear];
    
    switch (sanitizedYear.length) {
        case 0:
        case 1:
            return PSTCKCardValidationStateIncomplete;
        case 2: {
            if (sanitizedYear.integerValue == moddedYear) {
                return sanitizedMonth.integerValue >= currentMonth ? PSTCKCardValidationStateValid : PSTCKCardValidationStateInvalid;
            } else {
                return sanitizedYear.integerValue > moddedYear ? PSTCKCardValidationStateValid : PSTCKCardValidationStateInvalid;
            }
        }
        default:
            return PSTCKCardValidationStateInvalid;
    }
}


+ (PSTCKCardValidationState)validationStateForExpirationYear:(NSString *)expirationYear
                                                   inMonth:(NSString *)expirationMonth {
    return [self validationStateForExpirationYear:expirationYear
                                          inMonth:expirationMonth
                                    inCurrentYear:[self currentYear]
                                     currentMonth:[self currentMonth]];
}


+ (PSTCKCardValidationState)validationStateForCVC:(NSString *)cvc cardBrand:(PSTCKCardBrand)brand {
    
    if (![self stringIsNumeric:cvc]) {
        return PSTCKCardValidationStateInvalid;
    }
    
    NSString *sanitizedCvc = [self sanitizedNumericStringForString:cvc];
    
    NSUInteger minLength = [self minCVCLength];
    NSUInteger maxLength = [self maxCVCLengthForCardBrand:brand];
    if (sanitizedCvc.length < minLength) {
        return PSTCKCardValidationStateIncomplete;
    }
    else if (sanitizedCvc.length > maxLength) {
        return PSTCKCardValidationStateInvalid;
    }
    else {
        return PSTCKCardValidationStateValid;
    }
}

+ (PSTCKCardValidationState)validationStateForNumber:(nonnull NSString *)cardNumber
                               validatingCardBrand:(BOOL)validatingCardBrand {
    
    NSString *sanitizedNumber = [self stringByRemovingSpacesFromString:cardNumber];
    if (![self stringIsNumeric:sanitizedNumber]) {
        return PSTCKCardValidationStateInvalid;
    }
    
    NSArray *brands = [self possibleBrandsForNumber:sanitizedNumber];
    if (brands.count == 0 && validatingCardBrand) {
        return PSTCKCardValidationStateInvalid;
    } else if (brands.count >= 2) {
        return PSTCKCardValidationStateIncomplete;
    } else {
        PSTCKCardBrand brand = (PSTCKCardBrand)[brands.firstObject integerValue];
        NSUInteger desiredLength = [self lengthForCardBrand:brand];
        if (sanitizedNumber.length > desiredLength) {
            return PSTCKCardValidationStateInvalid;
        } else if (sanitizedNumber.length == desiredLength) {
            return [self stringIsValidLuhn:sanitizedNumber] ? PSTCKCardValidationStateValid : PSTCKCardValidationStateInvalid;
        } else if ((brand == PSTCKCardBrandVerve) && (sanitizedNumber.length <= 19) && (sanitizedNumber.length >= 16)) {
            // A verve card is valid as long as it has 16-19 digits (no luhn check)
            return PSTCKCardValidationStateValid;
        } else {
            return PSTCKCardValidationStateIncomplete;
        }
    }
}

+ (PSTCKCardValidationState)validationStateForCard:(nonnull PSTCKCardParams *)card inCurrentYear:(NSInteger)currentYear currentMonth:(NSInteger)currentMonth {
    PSTCKCardValidationState numberValidation = [self validationStateForNumber:card.number validatingCardBrand:YES];
    NSString *expMonthString = [NSString stringWithFormat:@"%02lu", (unsigned long)card.expMonth];
    PSTCKCardValidationState expMonthValidation = [self validationStateForExpirationMonth:expMonthString];
    NSString *expYearString = [NSString stringWithFormat:@"%02lu", (unsigned long)card.expYear%100];
    PSTCKCardValidationState expYearValidation = [self validationStateForExpirationYear:expYearString
                                                                              inMonth:expMonthString
                                                                        inCurrentYear:currentYear
                                                                         currentMonth:currentMonth];
    PSTCKCardBrand brand = [self brandForNumber:card.number];
    PSTCKCardValidationState cvcValidation = [self validationStateForCVC:card.cvc cardBrand:brand];

    NSArray<NSNumber *> *states = @[@(numberValidation),
                                    @(expMonthValidation),
                                    @(expYearValidation),
                                    @(cvcValidation)];
    BOOL incomplete = NO;
    for (NSNumber *boxedState in states) {
        PSTCKCardValidationState state = [boxedState integerValue];
        if (state == PSTCKCardValidationStateInvalid) {
            return state;
        }
        else if (state == PSTCKCardValidationStateIncomplete) {
            incomplete = YES;
        }
    }
    return incomplete ? PSTCKCardValidationStateIncomplete : PSTCKCardValidationStateValid;
}

+ (PSTCKCardValidationState)validationStateForCard:(PSTCKCardParams *)card {
    return [self validationStateForCard:card
                          inCurrentYear:[self currentYear]
                           currentMonth:[self currentMonth]];
}

+ (NSUInteger)minCVCLength {
    return 3;
}

+ (NSUInteger)maxCVCLengthForCardBrand:(PSTCKCardBrand)brand {
    switch (brand) {
        case PSTCKCardBrandAmex:
        case PSTCKCardBrandUnknown:
            return 4;
        default:
            return 3;
    }
}

+ (PSTCKCardBrand)brandForNumber:(NSString *)cardNumber {
    NSString *sanitizedNumber = [self sanitizedNumericStringForString:cardNumber];
    NSArray *brands = [self possibleBrandsForNumber:sanitizedNumber];
    if (brands.count == 1) {
        return (PSTCKCardBrand)[brands.firstObject integerValue];
    }
    return PSTCKCardBrandUnknown;
}

+ (NSArray *)possibleBrandsForNumber:(NSString *)cardNumber {
    NSMutableArray *possibleBrands = [@[] mutableCopy];
    for (NSNumber *brandNumber in [self allValidBrands]) {
        PSTCKCardBrand brand = (PSTCKCardBrand)brandNumber.integerValue;
        if ([self prefixMatches:brand digits:cardNumber]) {
            [possibleBrands addObject:@(brand)];
        }
    }
    return [possibleBrands copy];
}

+ (NSArray *)allValidBrands {
    return @[
//             @(PSTCKCardBrandAmex),
//             @(PSTCKCardBrandDinersClub),
//             @(PSTCKCardBrandDiscover),
//             @(PSTCKCardBrandJCB),
             @(PSTCKCardBrandMasterCard),
             @(PSTCKCardBrandVisa),
             @(PSTCKCardBrandVerve),
         ];
}

+ (NSUInteger)lengthForCardBrand:(PSTCKCardBrand)brand {
    switch (brand) {
        case PSTCKCardBrandAmex:
            return 15;
        case PSTCKCardBrandVerve:
        case PSTCKCardBrandUnknown:
            return 20;
        case PSTCKCardBrandDinersClub:
            return 14;
        default:
            return 16;
    }
}

+ (NSInteger)fragmentLengthForCardBrand:(PSTCKCardBrand)brand {
    switch (brand) {
        case PSTCKCardBrandAmex:
            return 5;
        case PSTCKCardBrandDinersClub:
            return 2;
        default:
            return 4;
    }
}

+ (BOOL)prefixMatches:(PSTCKCardBrand)brand digits:(NSString *)digits {
    if (digits.length == 0) {
        return YES;
    }
    NSArray *digitPrefixes = [self validBeginningDigits:brand];
    for (NSString *digitPrefix in digitPrefixes) {
        if ((digitPrefix.length >= digits.length && [digitPrefix hasPrefix:digits]) ||
            (digits.length >= digitPrefix.length && [digits hasPrefix:digitPrefix])) {
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)validBeginningDigits:(PSTCKCardBrand)brand {
    switch (brand) {
        case PSTCKCardBrandVerve:
            return @[@"5060", @"5061", @"5078", @"5079", @"6500"];
        case PSTCKCardBrandAmex:
            return @[@"34", @"37"];
        case PSTCKCardBrandDinersClub:
            return @[@"30", @"36", @"38", @"39"];
        case PSTCKCardBrandDiscover:
            return @[@"6011", @"622", @"64", @"65"];
        case PSTCKCardBrandJCB:
            return @[@"35"];
        case PSTCKCardBrandMasterCard:
            return @[@"501", @"502", @"503", @"504", @"505",
                     @"5062", @"5063", @"5064", @"5065", @"5066", @"5067", @"5068", @"5069",
                     @"5070", @"5071", @"5072", @"5073", @"5074", @"5075", @"5076", @"5077",
                     @"508", @"509", @"500", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59"];
        case PSTCKCardBrandVisa:
            return @[@"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49"];
        case PSTCKCardBrandUnknown:
            return @[];
    }
}

+ (BOOL)stringIsValidLuhn:(NSString *)number {
    BOOL odd = true;
    int sum = 0;
    NSMutableArray *digits = [NSMutableArray arrayWithCapacity:number.length];
    
    for (int i = 0; i < (NSInteger)number.length; i++) {
        [digits addObject:[number substringWithRange:NSMakeRange(i, 1)]];
    }
    
    for (NSString *digitStr in [digits reverseObjectEnumerator]) {
        int digit = [digitStr intValue];
        if ((odd = !odd)) digit *= 2;
        if (digit > 9) digit -= 9;
        sum += digit;
    }
    
    return sum % 10 == 0;
}

+ (NSInteger)currentYear {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateComponents.year % 100;
}

+ (NSInteger)currentMonth {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth fromDate:[NSDate date]];
    return dateComponents.month;
}

@end
