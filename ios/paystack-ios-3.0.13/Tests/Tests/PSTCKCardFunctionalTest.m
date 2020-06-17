//
//  PSTCKCardFunctionalTest.m
//  Paystack
//

@import XCTest;

#import "Paystack.h"

@interface PSTCKCardFunctionalTest : XCTestCase
@end

@implementation PSTCKCardFunctionalTest

- (void)testCreateCardToken {
    PSTCKCardParams *card = [[PSTCKCardParams alloc] init];

    card.number = @"4242424242424242";
    card.cvc = @"222";
    card.expMonth = 11;
    card.expYear = 2018;
    card.currency = @"usd";
    card.addressLine1 = @"123 Fake Street";
    card.addressLine2 = @"Apartment 4";
    card.addressCity = @"New York";
    card.addressState = @"NY";
    card.addressCountry = @"USA";
    card.addressZip = @"10002";

    PSTCKAPIClient *client = [[PSTCKAPIClient alloc] initWithPublicKey:@"pk_test_vOo1umqsYxSrP5UXfOeL3ecm"];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Card creation"];

    [client createTokenWithCard:card
                     completion:^(PSTCKToken *token, NSError *error) {
                         [expectation fulfill];

                         XCTAssertNil(error, @"error should be nil %@", error.localizedDescription);
                         XCTAssertNotNil(token, @"token should not be nil");

                         XCTAssertNotNil(token.tokenId);
//                         XCTAssertEqual(6U, token.card.expMonth);
//                         XCTAssertEqual(2018U, token.card.expYear);
                         XCTAssertEqualObjects(@"4242", token.last4);
//                         XCTAssertEqualObjects(@"usd", token.card.currency);
                     }];
    [self waitForExpectationsWithTimeout:60.0f handler:nil];
}

- (void)testCardTokenCreationWithInvalidParams {
    PSTCKCardParams *card = [[PSTCKCardParams alloc] init];

    card.number = @"4242 4242 4242 4241";
    card.expMonth = 6;
    card.expYear = 2018;

    PSTCKAPIClient *client = [[PSTCKAPIClient alloc] initWithPublicKey:@"pk_test_vOo1umqsYxSrP5UXfOeL3ecm"];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Card creation"];

    [client createTokenWithCard:card
                     completion:^(PSTCKToken *token, NSError *error) {
                         [expectation fulfill];

                         XCTAssertNotNil(error, @"error should not be nil");
                         XCTAssertEqual(error.code, 60);
                         XCTAssertEqualObjects(error.domain, PaystackDomain);
//                         XCTAssertEqualObjects(error.userInfo[PSTCKErrorParameterKey], @"number");
                         XCTAssertNil(token, @"token should be nil: %@", token.description);
                     }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testInvalidKey {
    PSTCKCardParams *card = [[PSTCKCardParams alloc] init];

    card.number = @"4242 4242 4242 4242";
    card.expMonth = 6;
    card.expYear = 2018;

    PSTCKAPIClient *client = [[PSTCKAPIClient alloc] initWithPublicKey:@"not_a_valid_key_asdf"];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Card failure"];
    [client createTokenWithCard:card
                     completion:^(PSTCKToken *token, NSError *error) {
                         [expectation fulfill];
                         XCTAssertNil(token, @"token should be nil");
                         XCTAssertNotNil(error, @"error should not be nil");
                         XCTAssert([error.localizedDescription rangeOfString:@"asdf"].location != NSNotFound, @"error should contain last 4 of key");
                     }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

@end
