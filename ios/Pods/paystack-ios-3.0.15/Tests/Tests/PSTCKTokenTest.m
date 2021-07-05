//
//  PSTCKTokenTest.m
//  Paystack
//

@import XCTest;

#import "PSTCKToken.h"
#import "PSTCKCard.h"

@interface PSTCKTokenTest : XCTestCase
@end

@implementation PSTCKTokenTest

- (NSDictionary *)buildTestTokenResponse {
    NSDictionary *tokenDict = @{ @"token": @"pstk_3uohiu3", @"message": @"Success", @"status": @1, @"created": @1353025450.0, @"last4": @"1234" };
    return tokenDict;
}

- (void)testCreatingTokenWithAttributeDictionarySetsAttributes {
    PSTCKToken *token = [PSTCKToken decodedObjectFromAPIResponse:[self buildTestTokenResponse]];
    XCTAssertEqualObjects([token tokenId], @"pstk_3uohiu3", @"Generated token has the correct id");
//    XCTAssertEqual([token livemode], NO, @"Generated token has the correct livemode");

//    XCTAssertEqualWithAccuracy([[token created] timeIntervalSince1970], 1353025450.0, 1.0, @"Generated token has the correct created time");
}

- (void)testCreatingTokenSetsAdditionalResponseFields {
    NSMutableDictionary *tokenResponse = [[self buildTestTokenResponse] mutableCopy];
    tokenResponse[@"foo"] = @"bar";
    PSTCKToken *token = [PSTCKToken decodedObjectFromAPIResponse:tokenResponse];
    NSDictionary *allResponseFields = token.allResponseFields;
    XCTAssertEqualObjects(allResponseFields[@"foo"], @"bar");
    XCTAssertEqualObjects(allResponseFields[@"last4"], @"1234");
    XCTAssertNil(allResponseFields[@"baz"]);
}

@end
