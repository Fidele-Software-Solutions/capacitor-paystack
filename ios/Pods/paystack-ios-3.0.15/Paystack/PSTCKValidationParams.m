//
//  PSTCKCardParams.m
//  Paystack
//

#import "PSTCKValidationParams.h"

@implementation PSTCKValidationParams

@synthesize additionalAPIParameters = _additionalAPIParameters;

- (instancetype)init {
    self = [super init];
    if (self) {
        _additionalAPIParameters = @{};
    }
    return self;
}


#pragma mark -

#pragma mark - PSTCKFormEncodable

+ (NSString *)rootObjectName {
    return @"";
}

+ (NSDictionary *)propertyNamesToFormFieldNamesMapping {
    return @{
             @"trans": @"trans",
             @"token": @"token"
             };
}

@end
