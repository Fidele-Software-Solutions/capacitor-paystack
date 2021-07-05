//
//  PSTCKPaymentCardTextFieldTest.m
//  Paystack
//

@import UIKit;
@import XCTest;

#import "Paystack.h"
#import "PSTCKFormTextField.h"
#import "PSTCKPaymentCardTextFieldViewModel.h"

@interface PSTCKPaymentCardTextField (Testing)
@property(nonatomic, readwrite, weak)UIImageView *brandImageView;
@property(nonatomic, readwrite, weak)PSTCKFormTextField *numberField;
@property(nonatomic, readwrite, weak)PSTCKFormTextField *expirationField;
@property(nonatomic, readwrite, weak)PSTCKFormTextField *cvcField;
@property(nonatomic, readwrite, weak)UITextField *selectedField;
@property(nonatomic, assign)BOOL numberFieldShrunk;
+ (UIImage *)cvcImageForCardBrand:(PSTCKCardBrand)cardBrand;
+ (UIImage *)brandImageForCardBrand:(PSTCKCardBrand)cardBrand;
@end

@interface PSTCKPaymentCardTextFieldTest : XCTestCase
@end

@implementation PSTCKPaymentCardTextFieldTest

- (void)testIntrinsicContentSize {
    PSTCKPaymentCardTextField *textField = [PSTCKPaymentCardTextField new];
    
    UIFont *iOS8SystemFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
    textField.font = iOS8SystemFont;
    XCTAssertEqualWithAccuracy(textField.intrinsicContentSize.height, 44, 0.1);
    XCTAssertEqualWithAccuracy(textField.intrinsicContentSize.width, 257, 0.1);
    
    UIFont *iOS9SystemFont = [UIFont fontWithName:@".SFUIText-Regular" size:18];
    if (iOS9SystemFont) {
        textField.font = iOS9SystemFont;
        XCTAssertEqualWithAccuracy(textField.intrinsicContentSize.height, 44, 0.1);
        XCTAssertEqualWithAccuracy(textField.intrinsicContentSize.width, 270, 0.1);
    }
    
    textField.font = [UIFont fontWithName:@"Avenir" size:44];
    XCTAssertEqualWithAccuracy(textField.intrinsicContentSize.height, 60, 0.1);
    XCTAssertEqualWithAccuracy(textField.intrinsicContentSize.width, 488, 0.1);
}

- (void)testSetCard_numberUnknown {
    PSTCKPaymentCardTextField *sut = [PSTCKPaymentCardTextField new];
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *number = @"1";
    card.number = number;
    [sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandUnknown]);

    XCTAssertFalse(sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqualObjects(sut.numberField.text, number);
    XCTAssertEqual(sut.expirationField.text.length, (NSUInteger)0);
    XCTAssertEqual(sut.cvcField.text.length, (NSUInteger)0);
    XCTAssertNil(sut.selectedField);
}

- (void)testSetCard_expiration {
    PSTCKPaymentCardTextField *sut = [PSTCKPaymentCardTextField new];
    PSTCKCardParams *card = [PSTCKCardParams new];
    card.expMonth = 10;
    card.expYear = 99;
    [sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandUnknown]);

    XCTAssertFalse(sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqual(sut.numberField.text.length, (NSUInteger)0);
    XCTAssertEqualObjects(sut.expirationField.text, @"10/99");
    XCTAssertEqual(sut.cvcField.text.length, (NSUInteger)0);
    XCTAssertNil(sut.selectedField);
    XCTAssertFalse(sut.isValid);
}

- (void)testSetCard_CVC {
    PSTCKPaymentCardTextField *sut = [PSTCKPaymentCardTextField new];
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *cvc = @"123";
    card.cvc = cvc;
    [sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandUnknown]);

    XCTAssertFalse(sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqual(sut.numberField.text.length, (NSUInteger)0);
    XCTAssertEqual(sut.expirationField.text.length, (NSUInteger)0);
    XCTAssertEqualObjects(sut.cvcField.text, cvc);
    XCTAssertNil(sut.selectedField);
    XCTAssertFalse(sut.isValid);
}

- (void)testSetCard_numberVisa {
    PSTCKPaymentCardTextField *sut = [PSTCKPaymentCardTextField new];
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *number = @"4242";
    card.number = number;
    [sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandVisa]);

    XCTAssertFalse(sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqualObjects(sut.numberField.text, number);
    XCTAssertEqual(sut.expirationField.text.length, (NSUInteger)0);
    XCTAssertEqual(sut.cvcField.text.length, (NSUInteger)0);
    XCTAssertNil(sut.selectedField);
    XCTAssertFalse(sut.isValid);
}

- (void)testSetCard_numberAndExpiration {
    PSTCKPaymentCardTextField *sut = [PSTCKPaymentCardTextField new];
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *number = @"4242424242424242";
    card.number = number;
    card.expMonth = 10;
    card.expYear = 99;
    [sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandVisa]);

    XCTAssertTrue(sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqualObjects(sut.numberField.text, number);
    XCTAssertEqualObjects(sut.expirationField.text, @"10/99");
    XCTAssertEqual(sut.cvcField.text.length, (NSUInteger)0);
    XCTAssertNil(sut.selectedField);
    XCTAssertFalse(sut.isValid);
}

- (void)testSetCard_partialNumberAndExpiration {
    PSTCKPaymentCardTextField *sut = [PSTCKPaymentCardTextField new];
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *number = @"42";
    card.number = number;
    card.expMonth = 10;
    card.expYear = 99;
    [sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandVisa]);

    XCTAssertFalse(sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqualObjects(sut.numberField.text, number);
    XCTAssertEqualObjects(sut.expirationField.text, @"10/99");
    XCTAssertEqual(sut.cvcField.text.length, (NSUInteger)0);
    XCTAssertNil(sut.selectedField);
    XCTAssertFalse(sut.isValid);
}

- (void)testSetCard_numberAndCVC {
    PSTCKPaymentCardTextField *sut = [PSTCKPaymentCardTextField new];
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *number = @"378282246310005";
    NSString *cvc = @"123";
    card.number = number;
    card.cvc = cvc;
    [sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandAmex]);

    XCTAssertTrue(sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqualObjects(sut.numberField.text, number);
    XCTAssertEqual(sut.expirationField.text.length, (NSUInteger)0);
    XCTAssertEqualObjects(sut.cvcField.text, cvc);
    XCTAssertNil(sut.selectedField);
    XCTAssertFalse(sut.isValid);
}

- (void)testSetCard_expirationAndCVC {
    PSTCKPaymentCardTextField *sut = [PSTCKPaymentCardTextField new];
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *cvc = @"123";
    card.expMonth = 10;
    card.expYear = 99;
    card.cvc = cvc;
    [sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandUnknown]);

    XCTAssertFalse(sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqual(sut.numberField.text.length, (NSUInteger)0);
    XCTAssertEqualObjects(sut.expirationField.text, @"10/99");
    XCTAssertEqualObjects(sut.cvcField.text, cvc);
    XCTAssertNil(sut.selectedField);
    XCTAssertFalse(sut.isValid);
}

- (void)testSetCard_completeCard {
    PSTCKPaymentCardTextField *sut = [PSTCKPaymentCardTextField new];
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *number = @"4242424242424242";
    NSString *cvc = @"123";
    card.number = number;
    card.expMonth = 10;
    card.expYear = 99;
    card.cvc = cvc;
    [sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandVisa]);

    XCTAssertTrue(sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqualObjects(sut.numberField.text, number);
    XCTAssertEqualObjects(sut.expirationField.text, @"10/99");
    XCTAssertEqualObjects(sut.cvcField.text, cvc);
    XCTAssertNil(sut.selectedField);
    XCTAssertTrue(sut.isValid);
}

- (void)testSetCard_empty {
    PSTCKPaymentCardTextField *sut = [PSTCKPaymentCardTextField new];
    sut.numberField.text = @"4242424242424242";
    sut.cvcField.text = @"123";
    sut.expirationField.text = @"10/99";
    PSTCKCardParams *card = [PSTCKCardParams new];
    [sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandUnknown]);

    XCTAssertFalse(sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqual(sut.numberField.text.length, (NSUInteger)0);
    XCTAssertEqual(sut.expirationField.text.length, (NSUInteger)0);
    XCTAssertEqual(sut.cvcField.text.length, (NSUInteger)0);
    XCTAssertNil(sut.selectedField);
    XCTAssertFalse(sut.isValid);
}

@end
