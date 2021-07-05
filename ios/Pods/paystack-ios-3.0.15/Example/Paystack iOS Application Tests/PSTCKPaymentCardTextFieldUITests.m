//
//  PSTCKPaymentCardTextFieldUITests.m
//  Paystack iOS Example
//
//

#import <XCTest/XCTest.h>
#import <Paystack/Paystack.h>

@interface PSTCKPaymentCardTextField (Testing)
@property(nonatomic, readwrite, weak)UIImageView *brandImageView;
@property(nonatomic, readwrite, weak)UITextField *numberField;
@property(nonatomic, readwrite, weak)UITextField *expirationField;
@property(nonatomic, readwrite, weak)UITextField *cvcField;
@property(nonatomic, assign)BOOL numberFieldShrunk;
+ (UIImage *)cvcImageForCardBrand:(PSTCKCardBrand)cardBrand;
+ (UIImage *)brandImageForCardBrand:(PSTCKCardBrand)cardBrand;
@end

@interface PSTCKPaymentCardTextFieldUITests : XCTestCase
@property (nonatomic, strong) PSTCKPaymentCardTextField *sut;
@property (nonatomic, strong) UIViewController *viewController;
@end

@implementation PSTCKPaymentCardTextFieldUITests

- (void)setUp {
    [super setUp];
    self.viewController = [UIViewController new];
    self.sut = [PSTCKPaymentCardTextField new];
    [self.viewController.view addSubview:self.sut];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.rootViewController = self.viewController;
}

- (void)testSetCard_allFields_whileEditingNumber {
    XCTAssertTrue([self.sut.numberField becomeFirstResponder]);
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *number = @"4123450131001381";
    NSString *cvc = @"883";
    card.number = number;
    card.expMonth = 10;
    card.expYear = 99;
    card.cvc = cvc;
    [self.sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(self.sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField cvcImageForCardBrand:PSTCKCardBrandVisa]);

    XCTAssertTrue(self.sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqualObjects(self.sut.numberField.text, number);
    XCTAssertEqualObjects(self.sut.expirationField.text, @"10/99");
    XCTAssertEqualObjects(self.sut.cvcField.text, cvc);
    XCTAssertTrue([self.sut.cvcField isFirstResponder]);
    XCTAssertTrue(self.sut.isValid);
}

- (void)testSetCard_partialNumberAndExpiration_whileEditingExpiration {
    XCTAssertTrue([self.sut.expirationField becomeFirstResponder]);
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *number = @"41";
    card.number = number;
    card.expMonth = 10;
    card.expYear = 99;
    [self.sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(self.sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandVisa]);

    XCTAssertFalse(self.sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqualObjects(self.sut.numberField.text, number);
    XCTAssertEqualObjects(self.sut.expirationField.text, @"10/99");
    XCTAssertEqual(self.sut.cvcField.text.length, (NSUInteger)0);
    XCTAssertTrue([self.sut.expirationField isFirstResponder]);
    XCTAssertFalse(self.sut.isValid);
}

- (void)testSetCard_number_whileEditingCVC {
    XCTAssertTrue([self.sut.cvcField becomeFirstResponder]);
    PSTCKCardParams *card = [PSTCKCardParams new];
    NSString *number = @"4123450131001381";
    card.number = number;
    [self.sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(self.sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandVisa]);

    XCTAssertTrue(self.sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqualObjects(self.sut.numberField.text, number);
    XCTAssertEqual(self.sut.expirationField.text.length, (NSUInteger)0);
    XCTAssertEqual(self.sut.cvcField.text.length, (NSUInteger)0);
    XCTAssertTrue([self.sut.expirationField isFirstResponder]);
    XCTAssertFalse(self.sut.isValid);
}

- (void)testSetCard_empty_whileEditingNumber {
    XCTAssertTrue([self.sut.numberField becomeFirstResponder]);
    self.sut.numberField.text = @"4123450131001381";
    self.sut.cvcField.text = @"883";
    self.sut.expirationField.text = @"10/99";
    PSTCKCardParams *card = [PSTCKCardParams new];
    [self.sut setCardParams:card];
    NSData *imgData = UIImagePNGRepresentation(self.sut.brandImageView.image);
    NSData *expectedImgData = UIImagePNGRepresentation([PSTCKPaymentCardTextField brandImageForCardBrand:PSTCKCardBrandUnknown]);

    XCTAssertFalse(self.sut.numberFieldShrunk);
    XCTAssertTrue([expectedImgData isEqualToData:imgData]);
    XCTAssertEqual(self.sut.numberField.text.length, (NSUInteger)0);
    XCTAssertEqual(self.sut.expirationField.text.length, (NSUInteger)0);
    XCTAssertEqual(self.sut.cvcField.text.length, (NSUInteger)0);
    XCTAssertTrue([self.sut.numberField isFirstResponder]);
    XCTAssertFalse(self.sut.isValid);
}

@end
