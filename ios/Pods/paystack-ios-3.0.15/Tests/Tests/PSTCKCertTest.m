//
//  PSTCKCertTest.m
//  Paystack
//

@import XCTest;

#import "PSTCKAPIClient.h"
#import "PSTCKAPIClient+Private.h"
#import "Paystack.h"

NSString *const PSTCKExamplePublicKey = @"bad_key";

@interface PSTCKAPIClient (Failure)
@property (nonatomic, readwrite) NSURL *apiURL;
@end

@interface PSTCKCertTest : XCTestCase
@end

@implementation PSTCKCertTest

- (void)testNoError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Token creation"];
    PSTCKAPIClient *client = [[PSTCKAPIClient alloc] initWithPublicKey:PSTCKExamplePublicKey];
    [client createTokenWithData:[NSData new]
                     completion:^(PSTCKToken *token, NSError *error) {
                         [expectation fulfill];
                         // Note that this API request *will* fail, but it will return error
                         // messages from the server and not be blocked by local cert checks
                         XCTAssertNil(token, @"Expected no token");
                         XCTAssertNotNil(error, @"Expected error");
                     }];
    [self waitForExpectationsWithTimeout:60.0f handler:nil];
}

- (void)testExpired {
    [self createTokenWithBaseURL:[NSURL URLWithString:@"https://testssl-expire.disig.sk/index.en.html"]
                      completion:^(PSTCKToken *token, NSError *error) {
                          XCTAssertNil(token, @"Token should be nil.");
                          XCTAssertEqualObjects(error.domain, @"NSURLErrorDomain", @"Error should be NSURLErrorDomain");
                          XCTAssertNotNil(error.userInfo[@"NSURLErrorFailingURLPeerTrustErrorKey"],
                                          @"There should be a secTustRef for Foundation HTTPS errors");
                      }];
}

- (void)testMismatched {
    [self createTokenWithBaseURL:[NSURL URLWithString:@"https://mismatched.paystack.com"]
                      completion:^(PSTCKToken *token, NSError *error) {
                          XCTAssertNil(token, @"Token should be nil.");
                          XCTAssertEqualObjects(error.domain, @"NSURLErrorDomain", @"Error should be NSURLErrorDomain");
                      }];
}

// helper method
- (void)createTokenWithBaseURL:(NSURL *)baseURL completion:(PSTCKTokenCompletionBlock)completion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Token creation"];
    PSTCKAPIClient *client = [[PSTCKAPIClient alloc] initWithPublicKey:PSTCKExamplePublicKey];
    client.apiURL = baseURL;
    [client createTokenWithData:[NSData new]
                     completion:^(PSTCKToken *token, NSError *error) {
                         [expectation fulfill];
                         completion(token, error);
                     }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

@end

@implementation PSTCKAPIClient (Failure)
@dynamic apiURL;
@end
