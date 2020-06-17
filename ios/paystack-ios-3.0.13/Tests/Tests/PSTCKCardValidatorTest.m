//
//  PSTCKCardValidatorTest.m
//  Paystack
//

@import UIKit;
@import XCTest;

#import "PSTCKCardValidationState.h"
#import "PSTCKCardValidator.h"

@interface PSTCKCardValidatorTest : XCTestCase
@end

@implementation PSTCKCardValidatorTest

+ (NSArray *)cardData {
    return @[
             @[@(PSTCKCardBrandVisa), @"4242424242424242", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandVisa), @"4012888888881881", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandVisa), @"4000056655665556", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandMasterCard), @"5555555555554444", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandMasterCard), @"5200828282828210", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandMasterCard), @"5105105105105100", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandAmex), @"378282246310005", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandAmex), @"371449635398431", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandDiscover), @"6011111111111117", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandDiscover), @"6011000990139424", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandDinersClub), @"30569309025904", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandDinersClub), @"38520000023237", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandJCB), @"3530111333300000", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandJCB), @"3566002020360505", @(PSTCKCardValidationStateValid)],
             @[@(PSTCKCardBrandUnknown), @"1234567812345678", @(PSTCKCardValidationStateInvalid)],
             ];
}

- (void)testNumberSanitization {
    NSArray *tests = @[
                       @[@"4242424242424242", @"4242424242424242"],
                       @[@"XXXXXX", @""],
                       @[@"424242424242424X", @"424242424242424"],
                       ];
    for (NSArray *test in tests) {
        XCTAssertEqualObjects([PSTCKCardValidator sanitizedNumericStringForString:test[0]], test[1]);
    }
}

- (void)testNumberValidation {
    NSMutableArray *tests = [@[] mutableCopy];
    
    for (NSArray *card in [self.class cardData]) {
        [tests addObject:@[card[2], card[1]]];
    }
    
    [tests addObject:@[@(PSTCKCardValidationStateValid), @"4242 4242 4242 4242"]];
    
    NSArray *badCardNumbers = @[
                                @"0000000000000000",
                                @"9999999999999995",
                                @"1",
                                @"1234123412341234",
                                @"xxx",
                                @"9999999999999999999999",
                                @"42424242424242424242",
                                @"4242-4242-4242-4242",
                                ];
    
    for (NSString *card in badCardNumbers) {
        [tests addObject:@[@(PSTCKCardValidationStateInvalid), card]];
    }
    
    NSArray *possibleCardNumbers = @[
                                     @"4242",
                                     @"5",
                                     @"3",
                                     @"",
                                     @"    ",
                                     @"6011",
                                     ];
    
    for (NSString *card in possibleCardNumbers) {
        [tests addObject:@[@(PSTCKCardValidationStateIncomplete), card]];
    }
    
    for (NSArray *test in tests) {
        NSString *card = test[1];
        NSNumber *validationState = @([PSTCKCardValidator validationStateForNumber:card validatingCardBrand:YES]);
        NSNumber *expected = test[0];
        if (![validationState isEqual:expected]) {
            XCTFail();
        }
    }
    
    XCTAssertEqual(PSTCKCardValidationStateIncomplete, [PSTCKCardValidator validationStateForNumber:@"1" validatingCardBrand:NO]);
    XCTAssertEqual(PSTCKCardValidationStateValid, [PSTCKCardValidator validationStateForNumber:@"0000000000000000" validatingCardBrand:NO]);
    XCTAssertEqual(PSTCKCardValidationStateValid, [PSTCKCardValidator validationStateForNumber:@"9999999999999995" validatingCardBrand:NO]);
}

- (void)testBrand {
    for (NSArray *test in [self.class cardData]) {
        XCTAssertEqualObjects(@([PSTCKCardValidator brandForNumber:test[1]]), test[0]);
    }
}

- (void)testBrandNumberLength {
    NSArray *tests = @[
                       @[@(PSTCKCardBrandVisa), @16],
                       @[@(PSTCKCardBrandMasterCard), @16],
                       @[@(PSTCKCardBrandAmex), @15],
                       @[@(PSTCKCardBrandDiscover), @16],
                       @[@(PSTCKCardBrandDinersClub), @14],
                       @[@(PSTCKCardBrandJCB), @16],
                       @[@(PSTCKCardBrandUnknown), @16],
                       ];
    for (NSArray *test in tests) {
        XCTAssertEqualObjects(@([PSTCKCardValidator lengthForCardBrand:[test[0] integerValue]]), test[1]);
    }
}

- (void)testFragmentLength {
    NSArray *tests = @[
                       @[@(PSTCKCardBrandVisa), @4],
                       @[@(PSTCKCardBrandMasterCard), @4],
                       @[@(PSTCKCardBrandAmex), @5],
                       @[@(PSTCKCardBrandDiscover), @4],
                       @[@(PSTCKCardBrandDinersClub), @2],
                       @[@(PSTCKCardBrandJCB), @4],
                       @[@(PSTCKCardBrandUnknown), @4],
                       ];
    for (NSArray *test in tests) {
        XCTAssertEqualObjects(@([PSTCKCardValidator fragmentLengthForCardBrand:[test[0] integerValue]]), test[1]);
    }
}

- (void)testMonthValidation {
    NSArray *tests = @[
                       @[@"", @(PSTCKCardValidationStateIncomplete)],
                       @[@"0", @(PSTCKCardValidationStateIncomplete)],
                       @[@"1", @(PSTCKCardValidationStateIncomplete)],
                       @[@"2", @(PSTCKCardValidationStateValid)],
                       @[@"9", @(PSTCKCardValidationStateValid)],
                       @[@"10", @(PSTCKCardValidationStateValid)],
                       @[@"12", @(PSTCKCardValidationStateValid)],
                       @[@"13", @(PSTCKCardValidationStateInvalid)],
                       @[@"11a", @(PSTCKCardValidationStateInvalid)],
                       @[@"x", @(PSTCKCardValidationStateInvalid)],
                       @[@"100", @(PSTCKCardValidationStateInvalid)],
                       @[@"00", @(PSTCKCardValidationStateInvalid)],
                       @[@"13", @(PSTCKCardValidationStateInvalid)],
                       ];
    for (NSArray *test in tests) {
        XCTAssertEqualObjects(@([PSTCKCardValidator validationStateForExpirationMonth:test[0]]), test[1]);
    }
}

- (void)testYearValidation {
    NSArray *tests = @[
                       @[@"12", @"15", @(PSTCKCardValidationStateValid)],
                       @[@"8", @"15", @(PSTCKCardValidationStateValid)],
                       @[@"9", @"15", @(PSTCKCardValidationStateValid)],
                       @[@"11", @"16", @(PSTCKCardValidationStateValid)],
                       @[@"11", @"99", @(PSTCKCardValidationStateValid)],
                       @[@"00", @"99", @(PSTCKCardValidationStateValid)],
                       @[@"12", @"14", @(PSTCKCardValidationStateInvalid)],
                       @[@"7", @"15", @(PSTCKCardValidationStateInvalid)],
                       @[@"12", @"00", @(PSTCKCardValidationStateInvalid)],
                       @[@"12", @"2", @(PSTCKCardValidationStateIncomplete)],
                       @[@"12", @"1", @(PSTCKCardValidationStateIncomplete)],
                       @[@"12", @"0", @(PSTCKCardValidationStateIncomplete)],
                       ];
    
    for (NSArray *test in tests) {
        PSTCKCardValidationState state = [PSTCKCardValidator validationStateForExpirationYear:test[1] inMonth:test[0] inCurrentYear:15 currentMonth:8];
        XCTAssertEqualObjects(@(state), test[2]);
    }
}

- (void)testCVCLength {
    NSArray *tests = @[
                       @[@(PSTCKCardBrandVisa), @3],
                       @[@(PSTCKCardBrandMasterCard), @3],
                       @[@(PSTCKCardBrandAmex), @4],
                       @[@(PSTCKCardBrandDiscover), @3],
                       @[@(PSTCKCardBrandDinersClub), @3],
                       @[@(PSTCKCardBrandJCB), @3],
                       @[@(PSTCKCardBrandUnknown), @4],
                       ];
    for (NSArray *test in tests) {
        XCTAssertEqualObjects(@([PSTCKCardValidator maxCVCLengthForCardBrand:[test[0] integerValue]]), test[1]);
    }
}

- (void)testCVCValidation {
    NSArray *tests = @[
                       @[@"x", @(PSTCKCardBrandVisa), @(PSTCKCardValidationStateInvalid)],
                       @[@"", @(PSTCKCardBrandVisa), @(PSTCKCardValidationStateIncomplete)],
                       @[@"1", @(PSTCKCardBrandVisa), @(PSTCKCardValidationStateIncomplete)],
                       @[@"12", @(PSTCKCardBrandVisa), @(PSTCKCardValidationStateIncomplete)],
                       @[@"1x3", @(PSTCKCardBrandVisa), @(PSTCKCardValidationStateInvalid)],
                       @[@"123", @(PSTCKCardBrandVisa), @(PSTCKCardValidationStateValid)],
                       @[@"123", @(PSTCKCardBrandAmex), @(PSTCKCardValidationStateValid)],
                       @[@"123", @(PSTCKCardBrandUnknown), @(PSTCKCardValidationStateValid)],
                       @[@"1234", @(PSTCKCardBrandVisa), @(PSTCKCardValidationStateInvalid)],
                       @[@"1234", @(PSTCKCardBrandAmex), @(PSTCKCardValidationStateValid)],
                       @[@"12345", @(PSTCKCardBrandAmex), @(PSTCKCardValidationStateInvalid)],
                       ];
    
    for (NSArray *test in tests) {
        PSTCKCardValidationState state = [PSTCKCardValidator validationStateForCVC:test[0] cardBrand:[test[1] integerValue]];
        XCTAssertEqualObjects(@(state), test[2]);
    }
}

- (void)testCardValidation {
    NSArray *tests = @[
                       @[@"4242424242424242", @(12), @(15), @"123", @(PSTCKCardValidationStateValid)],
                       @[@"4242424242424242", @(12), @(15), @"x", @(PSTCKCardValidationStateInvalid)],
                       @[@"4242424242424242", @(12), @(15), @"1", @(PSTCKCardValidationStateIncomplete)],
                       @[@"4242424242424242", @(12), @(14), @"123", @(PSTCKCardValidationStateInvalid)],
                       @[@"4242424242424242", @(21), @(15), @"123", @(PSTCKCardValidationStateInvalid)],
                       @[@"42424242", @(12), @(15), @"123", @(PSTCKCardValidationStateIncomplete)],
                       @[@"378282246310005", @(12), @(15), @"1234", @(PSTCKCardValidationStateValid)],
                       @[@"378282246310005", @(12), @(15), @"123", @(PSTCKCardValidationStateValid)],
                       @[@"378282246310005", @(12), @(15), @"12345", @(PSTCKCardValidationStateInvalid)],
                       @[@"1234567812345678", @(12), @(15), @"12345", @(PSTCKCardValidationStateInvalid)],
                       ];
    for (NSArray *test in tests) {
        PSTCKCardParams *card = [[PSTCKCardParams alloc] init];
        card.number = test[0];
        card.expMonth = [test[1] integerValue];
        card.expYear = [test[2] integerValue];
        card.cvc = test[3];
        PSTCKCardValidationState state = [PSTCKCardValidator validationStateForCard:card
                                        inCurrentYear:15 currentMonth:8];
        XCTAssertEqualObjects(@(state), test[4]);
    }
}


@end
