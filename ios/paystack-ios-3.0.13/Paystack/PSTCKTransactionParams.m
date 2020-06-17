//
//  PSTCKCardParams.m
//  Paystack
//

#import "PSTCKTransactionParams.h"
#import "PSTCKCardValidator.h"
#import "PaystackError.h"
#import "PSTCKRSA.h"

@interface PSTCKTransactionParams (Private)
@property (nonatomic, retain) NSMutableDictionary* metadataDict;
@property (nonatomic, retain) NSMutableArray* customfieldArray;
@end

@implementation PSTCKTransactionParams{
    NSMutableDictionary* _metadataDict;
    NSMutableArray* _customfieldArray;
}

@synthesize additionalAPIParameters = _additionalAPIParameters;



- (instancetype)init {
    self = [super init];
    if (self) {
        _additionalAPIParameters = @{};
        _transaction_charge = -1;
        _amount = -1;
        _metadataDict = [[NSMutableDictionary alloc] init];
        _customfieldArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (PSTCKTransactionParams *) setMetadataValue:(NSString*)value
                                       forKey:(NSString*)key
                                        error:(NSError**) error {
    if([@"custom_fields" isEqualToString:key]){
        *error = [[NSError alloc] initWithDomain:PaystackDomain
                                           code:PSTCKTransactionError
                                       userInfo:@{
                                                  NSLocalizedDescriptionKey: PSTCKTransactionErrorDontSetCustomFieldDirectlyMessage,
                                                  PSTCKErrorMessageKey: PSTCKTransactionErrorDontSetCustomFieldDirectlyMessage
                                                  }];
        return nil;
    }
    return [self _setMetadataValue:value forKey:key error:error];
}

- (PSTCKTransactionParams *) setMetadataValueDict:(NSMutableDictionary*)dict
                                       forKey:(NSString*)key
                                        error:(NSError**) error {
    if([@"custom_fields" isEqualToString:key]){
        *error = [[NSError alloc] initWithDomain:PaystackDomain
                                           code:PSTCKTransactionError
                                       userInfo:@{
                                                  NSLocalizedDescriptionKey: PSTCKTransactionErrorDontSetCustomFieldDirectlyMessage,
                                                  PSTCKErrorMessageKey: PSTCKTransactionErrorDontSetCustomFieldDirectlyMessage
                                                  }];
        return nil;
    }
    return [self _setMetadataValue:dict forKey:key error:error];
}

- (PSTCKTransactionParams *) setMetadataValueArray:(NSMutableArray*)arr
                                       forKey:(NSString*)key
                                        error:(NSError**) error {
    if([@"custom_fields" isEqualToString:key]){
        *error = [[NSError alloc] initWithDomain:PaystackDomain
                                           code:PSTCKTransactionError
                                       userInfo:@{
                                                  NSLocalizedDescriptionKey: PSTCKTransactionErrorDontSetCustomFieldDirectlyMessage,
                                                  PSTCKErrorMessageKey: PSTCKTransactionErrorDontSetCustomFieldDirectlyMessage
                                                  }];
        return nil;
    }
    return [self _setMetadataValue:arr forKey:key error:error];
}

- (PSTCKTransactionParams *) _setMetadataValue:(NSObject*) value
                                        forKey:(NSString*)key
                                         error:(NSError**) error {
    [_metadataDict setValue:value forKey:key];
    _metadata = [[NSString alloc] initWithData:[NSJSONSerialization
                                                dataWithJSONObject:_metadataDict
                                                options:0
                                                error:error ]
                                      encoding:NSUTF8StringEncoding];
    return self;
}

- (PSTCKTransactionParams *) setCustomFieldValue:(NSString*)value
                                     displayedAs:(NSString*)display_name
                                           error:(NSError**) error{
    // generate a variable name
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^A-Za-z0-9]" options:0 error:error];
    NSString *variable_name = [display_name lowercaseString];
    variable_name = [regex stringByReplacingMatchesInString:variable_name options:0 range:NSMakeRange(0, [variable_name length]) withTemplate:@"_"];

    // only continue if no error
    if(*error!=nil)
        return nil;
    [_customfieldArray addObject:@{
                                   @"value": value,
                                   @"display_name": display_name,
                                   @"variable_name": variable_name,
                                   }];
    return [self _setMetadataValue:_customfieldArray forKey:@"custom_fields" error:error];
}


#pragma mark -

#pragma mark - PSTCKFormEncodable

+ (NSString *)rootObjectName {
    return @"";
}

+ (NSDictionary *)propertyNamesToFormFieldNamesMapping {
    return @{
             @"access_code": @"access_code",
             @"email": @"email",
             @"amount": @"amount",
             @"reference": @"reference",
             @"subaccount": @"subaccount",
             @"transaction_charge": @"transaction_charge",
             @"bearer": @"bearer",
             @"metadata": @"metadata",
             @"plan": @"plan",
             @"currency": @"currency",
             };
}

@end
