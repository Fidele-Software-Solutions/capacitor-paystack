//
//  UIImage+PaystackTest.m
//  Paystack
//

#import <XCTest/XCTest.h>
#import "UIImage+Paystack.h"

@interface UIImage_PaystackTest : XCTestCase
@property NSArray<NSNumber *> *cardBrands;
@end

@implementation UIImage_PaystackTest

- (void)setUp {
    self.cardBrands = @[
                        @(PSTCKCardBrandAmex),
                        @(PSTCKCardBrandDinersClub),
                        @(PSTCKCardBrandDiscover),
                        @(PSTCKCardBrandJCB),
                        @(PSTCKCardBrandMasterCard),
                        @(PSTCKCardBrandUnknown),
                        @(PSTCKCardBrandVisa),
                        ];
}

- (void)testCardIconMethods {
    UIImage *image = nil;
    image = [UIImage pstck_amexCardImage];
    XCTAssertNotNil(image);
    image = [UIImage pstck_dinersClubCardImage];
    XCTAssertNotNil(image);
    image = [UIImage pstck_discoverCardImage];
    XCTAssertNotNil(image);
    image = [UIImage pstck_jcbCardImage];
    XCTAssertNotNil(image);
    image = [UIImage pstck_masterCardCardImage];
    XCTAssertNotNil(image);
    image = [UIImage pstck_visaCardImage];
    XCTAssertNotNil(image);
    image = [UIImage pstck_unknownCardCardImage];
    XCTAssertNotNil(image);
}

- (void)testBrandImageForCardBrand {
    for (NSNumber *brand in self.cardBrands) {
        UIImage *image = [UIImage pstck_brandImageForCardBrand:[brand integerValue]];
        XCTAssertNotNil(image);
    }
}

- (void)testCVCImageForCardBrand {
    for (NSNumber *brand in self.cardBrands) {
        UIImage *image = [UIImage pstck_cvcImageForCardBrand:[brand integerValue]];
        XCTAssertNotNil(image);
    }
}

@end
