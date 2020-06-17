//
//  PaystackError.m
//  Paystack
//

#import "PaystackError.h"
#import "PSTCKFormEncoder.h"

NSString *const PaystackDomain = @"com.paystack.lib";
NSString *const PSTCKCardErrorCodeKey = @"com.paystack.lib:CardErrorCodeKey";
NSString *const PSTCKErrorMessageKey = @"com.paystack.lib:ErrorMessageKey";
NSString *const PSTCKErrorParameterKey = @"com.paystack.lib:ErrorParameterKey";
NSString *const PSTCKInvalidNumber = @"com.paystack.lib:InvalidNumber";
NSString *const PSTCKInvalidExpMonth = @"com.paystack.lib:InvalidExpiryMonth";
NSString *const PSTCKInvalidExpYear = @"com.paystack.lib:InvalidExpiryYear";
NSString *const PSTCKInvalidCVC = @"com.paystack.lib:InvalidCVC";
NSString *const PSTCKIncorrectNumber = @"com.paystack.lib:IncorrectNumber";
NSString *const PSTCKExpiredCard = @"com.paystack.lib:ExpiredCard";
NSString *const PSTCKCardDeclined = @"com.paystack.lib:CardDeclined";
NSString *const PSTCKProcessingError = @"com.paystack.lib:ProcessingError";
NSString *const PSTCKIncorrectCVC = @"com.paystack.lib:IncorrectCVC";

@implementation NSError(Paystack)

+ (NSError *)pstck_errorFromPaystackResponse:(NSDictionary *)jsonDictionary {
    NSString *status = [jsonDictionary[@"status"] description];
    if (![status isEqual: @"0"]) {
        return nil;
    }
    
    NSString *devMessage = jsonDictionary[@"message"];
    
    // There should always be a message for the error
    if (devMessage == nil) {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: @"Could not interpret the error response that was returned from Paystack.",
                                   PSTCKErrorMessageKey: @"Could not interpret the error response that was returned from Paystack."
                                   };
        return [[NSError alloc] initWithDomain:PaystackDomain code:PSTCKAPIError userInfo:userInfo];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[PSTCKErrorMessageKey] = devMessage;
    
    
    
    return [[NSError alloc] initWithDomain:PaystackDomain code:0 userInfo:userInfo];
}

- (NSError *)pstck_errorFromPaystackResponseOld:(NSDictionary *)jsonDictionary {
    NSDictionary *errorDictionary = jsonDictionary[@"error"];
    if (!errorDictionary) {
        return nil;
    }
    NSString *type = errorDictionary[@"type"];
    NSString *devMessage = errorDictionary[@"message"];
    NSString *parameter = errorDictionary[@"param"];
    NSInteger code = 0;
    
    // There should always be a message and type for the error
    if (devMessage == nil || type == nil) {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: @"Could not interpret the error response that was returned from Paystack.",
                                   PSTCKErrorMessageKey: @"Could not interpret the error response that was returned from Paystack."
                                   };
        return [[NSError alloc] initWithDomain:PaystackDomain code:PSTCKAPIError userInfo:userInfo];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[PSTCKErrorMessageKey] = devMessage;
    
    if (parameter) {
        userInfo[PSTCKErrorParameterKey] = [PSTCKFormEncoder stringByReplacingSnakeCaseWithCamelCase:parameter];
    }
    
    if ([type isEqualToString:@"api_error"]) {
        code = PSTCKAPIError;
        userInfo[NSLocalizedDescriptionKey] = PSTCKUnexpectedError;
    } else if ([type isEqualToString:@"invalid_request_error"]) {
        code = PSTCKInvalidRequestError;
        userInfo[NSLocalizedDescriptionKey] = devMessage;
    } else if ([type isEqualToString:@"card_error"]) {
        code = PSTCKCardError;
        NSDictionary *errorCodes = @{
                                     @"incorrect_number": @{@"code": PSTCKIncorrectNumber, @"message": PSTCKCardErrorInvalidNumberUserMessage},
                                     @"invalid_number": @{@"code": PSTCKInvalidNumber, @"message": PSTCKCardErrorInvalidNumberUserMessage},
                                     @"invalid_expiry_month": @{@"code": PSTCKInvalidExpMonth, @"message": PSTCKCardErrorInvalidExpMonthUserMessage},
                                     @"invalid_expiry_year": @{@"code": PSTCKInvalidExpYear, @"message": PSTCKCardErrorInvalidExpYearUserMessage},
                                     @"invalid_cvc": @{@"code": PSTCKInvalidCVC, @"message": PSTCKCardErrorInvalidCVCUserMessage},
                                     @"expired_card": @{@"code": PSTCKExpiredCard, @"message": PSTCKCardErrorExpiredCardUserMessage},
                                     @"incorrect_cvc": @{@"code": PSTCKIncorrectCVC, @"message": PSTCKCardErrorInvalidCVCUserMessage},
                                     @"card_declined": @{@"code": PSTCKCardDeclined, @"message": PSTCKCardErrorDeclinedUserMessage},
                                     @"processing_error": @{@"code": PSTCKProcessingError, @"message": PSTCKCardErrorProcessingErrorUserMessage},
                                     };
        NSDictionary *codeMapEntry = errorCodes[errorDictionary[@"code"]];
        
        if (codeMapEntry) {
            userInfo[PSTCKCardErrorCodeKey] = codeMapEntry[@"code"];
            userInfo[NSLocalizedDescriptionKey] = codeMapEntry[@"message"];
        } else {
            userInfo[PSTCKCardErrorCodeKey] = errorDictionary[@"code"];
            userInfo[NSLocalizedDescriptionKey] = devMessage;
        }
    }
    
    return [[NSError alloc] initWithDomain:PaystackDomain code:code userInfo:userInfo];
}

@end
