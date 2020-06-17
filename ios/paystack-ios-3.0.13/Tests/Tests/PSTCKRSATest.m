//
//  PSTCKRSATest.m
//  Paystack
//
//  Created by Ibrahim Lawal on Feb/27/2016.
//  Copyright © 2016 Paystack, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PSTCKRSA.h"

@interface PSTCKRSATest : XCTestCase

@end

@implementation PSTCKRSATest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEncryptRSA {
    NSString *encrypted = [PSTCKRSA encryptRSA:@"4123450131001381*883*08*18"];
//    NSLog(@"@%@",encrypted);
    // we are fine with getting any value at all
    XCTAssertNotNil(encrypted);
}


- (void)testPerformanceExample {
    // Test the performance of our RSA encryption .
    [self measureBlock:^{
        [self testEncryptRSA];
    }];
}

@end
