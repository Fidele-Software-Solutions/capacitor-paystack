//
//  PSTCKAPIClient+Private.h
//  Paystack
//
//  Copyright © 2016 Paystack, Inc. 
//

#import <Foundation/Foundation.h>

@interface PSTCKAPIClient ()<NSURLSessionDelegate>

@property (nonatomic, readwrite, nonnull) NSURL *apiURL;
@property (nonatomic, readwrite, nonnull) NSURLSession *urlSession;
@end
