//
//  PSTCKAPIPostRequest.h
//  Paystack
//

#import <Foundation/Foundation.h>
#import "PSTCKAPIResponseDecodable.h"
@class PSTCKAPIClient;

@interface PSTCKAPIPostRequest<__covariant ResponseType:id<PSTCKAPIResponseDecodable>> : NSObject

+ (void)startWithAPIClient:(PSTCKAPIClient *)apiClient
                  endpoint:(NSString *)endpoint
                    method:(NSString *)httpMethod
                  postData:(NSData *)postData
                serializer:(ResponseType)serializer
                completion:(void (^)(ResponseType object, NSError *error))completion;

@end
