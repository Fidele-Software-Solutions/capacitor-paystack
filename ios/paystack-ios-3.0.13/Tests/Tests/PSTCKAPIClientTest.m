//
//  PSTCKAPIClientTest.m
//  Paystack
//

@import XCTest;

#import "PSTCKAPIClient.h"

@interface PSTCKAPIClientTest : XCTestCase
@end

@implementation PSTCKAPIClientTest

- (void)testSharedClient {
    XCTAssertEqualObjects([PSTCKAPIClient sharedClient], [PSTCKAPIClient sharedClient]);
}

- (void)testPublicKey {
    [Paystack setDefaultPublicKey:@"test"];
    PSTCKAPIClient *client = [PSTCKAPIClient sharedClient];
    XCTAssertEqualObjects(client.publicKey, @"test");
}

@end
