//
//  PSTCKCardTest.m
//  Paystack
//

@import XCTest;

#import "PSTCKFormEncoder.h"
#import "PSTCKCard.h"
#import "PaystackError.h"

@interface PSTCKCardTest : XCTestCase
@property (nonatomic) PSTCKCardParams *card;
@end

@implementation PSTCKCardTest

- (void)setUp {
    _card = [[PSTCKCardParams alloc] init];
}

#pragma mark Helpers
- (NSDictionary *)completeAttributeDictionary {
    return @{
        @"id": @"1",
        @"exp_month": @"12",
        @"exp_year": @"2013",
        @"name": @"Smerlock Smolmes",
        @"address_line1": @"221A Baker Street",
        @"address_city": @"New York",
        @"address_state": @"NY",
        @"address_zip": @"12345",
        @"address_country": @"USA",
        @"last4": @"1234",
        @"dynamic_last4": @"5678",
        @"brand": @"MasterCard",
        @"country": @"Japan",
        @"currency": @"usd",
    };
}

- (void)testInitializingCardWithAttributeDictionary {
    NSMutableDictionary *apiResponse = [[self completeAttributeDictionary] mutableCopy];
    apiResponse[@"foo"] = @"bar";
    apiResponse[@"nested"] = @{@"baz": @"bang"};
    
    
    PSTCKCard *cardWithAttributes = [PSTCKCard decodedObjectFromAPIResponse:apiResponse];
    XCTAssertTrue([cardWithAttributes expMonth] == 12, @"expMonth is set correctly");
    XCTAssertTrue([cardWithAttributes expYear] == 2013, @"expYear is set correctly");
    XCTAssertEqualObjects([cardWithAttributes name], @"Smerlock Smolmes", @"name is set correctly");
    XCTAssertEqualObjects([cardWithAttributes addressLine1], @"221A Baker Street", @"addressLine1 is set correctly");
    XCTAssertEqualObjects([cardWithAttributes addressCity], @"New York", @"addressCity is set correctly");
    XCTAssertEqualObjects([cardWithAttributes addressState], @"NY", @"addressState is set correctly");
    XCTAssertEqualObjects([cardWithAttributes addressZip], @"12345", @"addressZip is set correctly");
    XCTAssertEqualObjects([cardWithAttributes addressCountry], @"USA", @"addressCountry is set correctly");
    XCTAssertEqualObjects([cardWithAttributes last4], @"1234", @"last4 is set correctly");
    XCTAssertEqualObjects([cardWithAttributes dynamicLast4], @"5678", @"last4 is set correctly");
    XCTAssertEqual([cardWithAttributes brand], PSTCKCardBrandMasterCard, @"type is set correctly");
    XCTAssertEqualObjects([cardWithAttributes country], @"Japan", @"country is set correctly");
    XCTAssertEqualObjects([cardWithAttributes currency], @"usd", @"currency is set correctly");
    
    NSDictionary *allResponseFields = cardWithAttributes.allResponseFields;
    XCTAssertEqual(allResponseFields[@"foo"], @"bar");
    XCTAssertEqual(allResponseFields[@"last4"], @"1234");
    XCTAssertEqualObjects(allResponseFields[@"nested"], @{@"baz": @"bang"});
    XCTAssertNil(allResponseFields[@"baz"]);
}

#pragma mark - last4 tests
- (void)testLast4ReturnsCardNumberLast4WhenNotSet {
    self.card.number = @"4242424242424242";
    XCTAssertEqualObjects(self.card.last4, @"4242", @"last4 correctly returns the last 4 digits of the card number");
}

- (void)testLast4ReturnsNullWhenNoCardNumberSet {
    XCTAssertEqualObjects(nil, self.card.last4, @"last4 returns nil when nothing is set");
}

- (void)testLast4ReturnsNullWhenCardNumberIsLessThanLength4 {
    self.card.number = @"123";
    XCTAssertEqualObjects(nil, self.card.last4, @"last4 returns nil when number length is < 3");
}

- (void)testCardEquals {
    PSTCKCard *card1 = [PSTCKCard decodedObjectFromAPIResponse:[self completeAttributeDictionary]];
    PSTCKCard *card2 = [PSTCKCard decodedObjectFromAPIResponse:[self completeAttributeDictionary]];

    XCTAssertEqualObjects(card1, card1, @"card should equal itself");
    XCTAssertEqualObjects(card1, card2, @"cards with equal data should be equal");
}

#pragma mark - validation tests
- (void)testValidateCardReturningError_january {
    PSTCKCardParams *params = [[PSTCKCardParams alloc] init];
    params.number = @"4242424242424242";
    params.expMonth = 01;
    params.expYear = 18;
    params.cvc = @"123";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    XCTAssert([params validateCardReturningError:nil]);
#pragma clang diagnostic pop
}

@end
