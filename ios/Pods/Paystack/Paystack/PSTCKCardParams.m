//
//  PSTCKCardParams.m
//  Paystack
//

#import "PSTCKCardParams.h"
#import "PSTCKCardValidator.h"
#import "PaystackError.h"
#import "PSTCKRSA.h"

@implementation PSTCKCardParams

@synthesize additionalAPIParameters = _additionalAPIParameters;

- (instancetype)init {
    self = [super init];
    if (self) {
        _additionalAPIParameters = @{};
    }
    return self;
}

- (NSString *)last4 {
    if (self.number && self.number.length >= 4) {
        return [self.number substringFromIndex:(self.number.length - 4)];
    } else {
        return nil;
    }
}

- (NSString *)clientdata{
    NSArray *dataArray = [NSArray arrayWithObjects:self.number, self.cvc, [@(self.expMonth) stringValue], [@(self.expYear) stringValue], nil];
    NSString *concatted = [dataArray componentsJoinedByString:@"*"];
//    NSLog(@"%@",concatted);
    return [PSTCKRSA encryptRSA:concatted];
}



- (BOOL)validateNumber:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        return [self.class handleValidationErrorForParameter:@"number" error:outError];
    }
    NSString *ioValueString = (NSString *)*ioValue;
    
    if ([PSTCKCardValidator validationStateForNumber:ioValueString validatingCardBrand:NO] != PSTCKCardValidationStateValid) {
        return [self.class handleValidationErrorForParameter:@"number" error:outError];
    }
    return YES;
}

- (BOOL)validateCvc:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        return [self.class handleValidationErrorForParameter:@"number" error:outError];
    }
    NSString *ioValueString = (NSString *)*ioValue;
    
    PSTCKCardBrand brand = [PSTCKCardValidator brandForNumber:self.number];
    
    if ([PSTCKCardValidator validationStateForCVC:ioValueString cardBrand:brand] != PSTCKCardValidationStateValid) {
        return [self.class handleValidationErrorForParameter:@"cvc" error:outError];
    }
    return YES;
}

- (BOOL)validateExpMonth:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        return [self.class handleValidationErrorForParameter:@"expMonth" error:outError];
    }
    NSString *ioValueString = [(NSString *)*ioValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([PSTCKCardValidator validationStateForExpirationMonth:ioValueString] != PSTCKCardValidationStateValid) {
        return [self.class handleValidationErrorForParameter:@"expMonth" error:outError];
    }
    return YES;
}

- (BOOL)validateExpYear:(id *)ioValue error:(NSError **)outError {
    if (*ioValue == nil) {
        return [self.class handleValidationErrorForParameter:@"expYear" error:outError];
    }
    NSString *ioValueString = [(NSString *)*ioValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *monthString = [@(self.expMonth) stringValue];
    if ([PSTCKCardValidator validationStateForExpirationYear:ioValueString inMonth:monthString] != PSTCKCardValidationStateValid) {
        return [self.class handleValidationErrorForParameter:@"expYear" error:outError];
    }
    return YES;
}

- (BOOL)validateCardReturningError:(NSError **)outError {
    // Order matters here
    NSString *numberRef = [self number];
    NSString *expMonthRef = [NSString stringWithFormat:@"%02lu", (unsigned long)[self expMonth]];
    NSString *expYearRef = [NSString stringWithFormat:@"%02lu", (unsigned long)[self expYear]];
    NSString *cvcRef = [self cvc];
    
    // Make sure expMonth, expYear, and number are set.  Validate CVC if it is provided
    return [self validateNumber:&numberRef error:outError] && [self validateExpYear:&expYearRef error:outError] &&
    [self validateExpMonth:&expMonthRef error:outError] && (cvcRef == nil || [self validateCvc:&cvcRef error:outError]);
}

#pragma mark Private Helpers
+ (BOOL)handleValidationErrorForParameter:(NSString *)parameter error:(NSError **)outError {
    if (outError != nil) {
        if ([parameter isEqualToString:@"number"]) {
            *outError = [self createErrorWithMessage:PSTCKCardErrorInvalidNumberUserMessage
                                           parameter:parameter
                                       cardErrorCode:PSTCKInvalidNumber
                                     devErrorMessage:@"Card number must be between 10 and 19 digits long and Luhn valid."];
        } else if ([parameter isEqualToString:@"cvc"]) {
            *outError = [self createErrorWithMessage:PSTCKCardErrorInvalidCVCUserMessage
                                           parameter:parameter
                                       cardErrorCode:PSTCKInvalidCVC
                                     devErrorMessage:@"Card CVC must be numeric, 3 digits for Visa, Discover, MasterCard, JCB, and Discover cards, and 3 or 4 "
                         @"digits for American Express cards."];
        } else if ([parameter isEqualToString:@"expMonth"]) {
            *outError = [self createErrorWithMessage:PSTCKCardErrorInvalidExpMonthUserMessage
                                           parameter:parameter
                                       cardErrorCode:PSTCKInvalidExpMonth
                                     devErrorMessage:@"expMonth must be less than 13"];
        } else if ([parameter isEqualToString:@"expYear"]) {
            *outError = [self createErrorWithMessage:PSTCKCardErrorInvalidExpYearUserMessage
                                           parameter:parameter
                                       cardErrorCode:PSTCKInvalidExpYear
                                     devErrorMessage:@"expYear must be this year or a year in the future"];
        } else {
            // This should not be possible since this is a private method so we
            // know exactly how it is called.  We use PSTCKAPIError for all errors
            // that are unexpected within the bindings as well.
            *outError = [[NSError alloc] initWithDomain:PaystackDomain
                                                   code:PSTCKAPIError
                                               userInfo:@{
                                                          NSLocalizedDescriptionKey: @"There was an error within the Paystack client library when trying to generate the "
                                                          @"proper validation error.",
                                                          PSTCKErrorMessageKey: @"There was an error within the Paystack client library when trying to generate the "
                                                          @"proper validation error. Contact support@paystack.com if you see this."
                                                          }];
        }
    }
    return NO;
}

+ (NSError *)createErrorWithMessage:(NSString *)userMessage
                          parameter:(NSString *)parameter
                      cardErrorCode:(NSString *)cardErrorCode
                    devErrorMessage:(NSString *)devMessage {
    return [[NSError alloc] initWithDomain:PaystackDomain
                                      code:PSTCKCardError
                                  userInfo:@{
                                             NSLocalizedDescriptionKey: userMessage,
                                             PSTCKErrorParameterKey: parameter,
                                             PSTCKCardErrorCodeKey: cardErrorCode,
                                             PSTCKErrorMessageKey: devMessage
                                             }];
}

#pragma mark - 

#pragma mark - PSTCKFormEncodable

+ (NSString *)rootObjectName {
    return @"";
}

+ (NSDictionary *)propertyNamesToFormFieldNamesMapping {
    return @{
             @"last4": @"last4",
             @"clientdata": @"clientdata",
             };
}

@end
