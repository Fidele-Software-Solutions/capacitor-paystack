//
//  PSTCKFormEncoderTest.m
//  Paystack Tests
//

@import XCTest;
#import "PSTCKFormEncoder.h"
#import "PSTCKFormEncodable.h"

@interface PSTCKTestFormEncodableObject : NSObject<PSTCKFormEncodable>
@property(nonatomic) NSString *testProperty;
@property(nonatomic) NSString *testIgnoredProperty;
@property(nonatomic) NSArray *testArrayProperty;
@property(nonatomic) NSDictionary *testDictionaryProperty;
@property(nonatomic) PSTCKTestFormEncodableObject *testNestedObjectProperty;
@end

@implementation PSTCKTestFormEncodableObject

@synthesize additionalAPIParameters;

+ (NSString *)rootObjectName {
    return @"test_object";
}

+ (NSDictionary *)propertyNamesToFormFieldNamesMapping {
    return @{
             @"testProperty": @"test_property",
             @"testArrayProperty": @"test_array_property",
             @"testDictionaryProperty": @"test_dictionary_property",
             @"testNestedObjectProperty": @"test_nested_property",
             };
}

@end

@interface PSTCKFormEncoderTest : XCTestCase
@end

@implementation PSTCKFormEncoderTest

- (void)testStringByReplacingSnakeCaseWithCamelCase {
    NSString *camelCase = [PSTCKFormEncoder stringByReplacingSnakeCaseWithCamelCase:@"test_1_2_34_test"];
    XCTAssertEqualObjects(@"test1234Test", camelCase);
}

// helper test method
- (NSString *)encodeObject:(PSTCKTestFormEncodableObject *)object {
    NSData *encoded = [PSTCKFormEncoder formEncryptedDataForCard:object];
    return [[[NSString alloc] initWithData:encoded encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
}

- (void)testFormEncoding_emptyObject {
    PSTCKTestFormEncodableObject *testObject = [PSTCKTestFormEncodableObject new];
    XCTAssertEqualObjects([self encodeObject:testObject], @"");
}

- (void)testFormEncoding_normalObject {
    PSTCKTestFormEncodableObject *testObject = [PSTCKTestFormEncodableObject new];
    testObject.testProperty = @"success";
    testObject.testIgnoredProperty = @"ignoreme";
    XCTAssertEqualObjects([self encodeObject:testObject], @"test_object[test_property]=success");
}

- (void)testFormEncoding_additionalAttributes {
    PSTCKTestFormEncodableObject *testObject = [PSTCKTestFormEncodableObject new];
    testObject.testProperty = @"success";
    testObject.additionalAPIParameters = @{@"foo": @"bar", @"nested": @{@"nested_key": @"nested_value"}};
    XCTAssertEqualObjects([self encodeObject:testObject], @"test_object[foo]=bar&test_object[nested][nested_key]=nested_value&test_object[test_property]=success");
}

- (void)testFormEncoding_arrayValue_empty {
    PSTCKTestFormEncodableObject *testObject = [PSTCKTestFormEncodableObject new];
    testObject.testProperty = @"success";
    testObject.testArrayProperty = @[];
    XCTAssertEqualObjects([self encodeObject:testObject], @"test_object[test_property]=success");
}

- (void)testFormEncoding_arrayValue {
    PSTCKTestFormEncodableObject *testObject = [PSTCKTestFormEncodableObject new];
    testObject.testProperty = @"success";
    testObject.testArrayProperty = @[@1, @2, @3];
    XCTAssertEqualObjects([self encodeObject:testObject], @"test_object[test_array_property][]=1&test_object[test_array_property][]=2&test_object[test_array_property][]=3&test_object[test_property]=success");
}

- (void)testFormEncoding_dictionaryValue_empty {
    PSTCKTestFormEncodableObject *testObject = [PSTCKTestFormEncodableObject new];
    testObject.testProperty = @"success";
    testObject.testDictionaryProperty = @{};
    XCTAssertEqualObjects([self encodeObject:testObject], @"test_object[test_property]=success");
}

- (void)testFormEncoding_dictionaryValue {
    PSTCKTestFormEncodableObject *testObject = [PSTCKTestFormEncodableObject new];
    testObject.testProperty = @"success";
    testObject.testDictionaryProperty = @{@"foo": @"bar"};
    XCTAssertEqualObjects([self encodeObject:testObject], @"test_object[test_dictionary_property][foo]=bar&test_object[test_property]=success");
}

- (void)testFormEncoding_nestedValue {
    PSTCKTestFormEncodableObject *testObject1 = [PSTCKTestFormEncodableObject new];
    PSTCKTestFormEncodableObject *testObject2 = [PSTCKTestFormEncodableObject new];
    testObject2.testProperty = @"nested_object";
    testObject1.testProperty = @"success";
    testObject1.testNestedObjectProperty = testObject2;
    XCTAssertEqualObjects([self encodeObject:testObject1], @"test_object[test_nested_property][test_property]=nested_object&test_object[test_property]=success");
}

@end
