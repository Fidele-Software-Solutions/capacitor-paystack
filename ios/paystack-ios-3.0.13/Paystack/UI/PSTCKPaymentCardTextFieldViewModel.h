//
//  PSTCKPaymentCardTextFieldViewModel.h
//  Paystack
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PSTCKCard.h"
#import "PSTCKCardValidator.h"

typedef NS_ENUM(NSInteger, PSTCKCardFieldType) {
    PSTCKCardFieldTypeNumber,
    PSTCKCardFieldTypeExpiration,
    PSTCKCardFieldTypeCVC,
};

@interface PSTCKPaymentCardTextFieldViewModel : NSObject

@property(nonatomic, readwrite, copy, nullable)NSString *cardNumber;
@property(nonatomic, readwrite, copy, nullable)NSString *rawExpiration;
@property(nonatomic, readonly, nullable)NSString *expirationMonth;
@property(nonatomic, readonly, nullable)NSString *expirationYear;
@property(nonatomic, readwrite, copy, nullable)NSString *cvc;
@property(nonatomic, readonly) PSTCKCardBrand brand;

- (nonnull NSString *)defaultPlaceholder;
- (nullable NSString *)numberWithoutLastDigits;

- (BOOL)isValid;

- (PSTCKCardValidationState)validationStateForField:(PSTCKCardFieldType)fieldType;

@end
