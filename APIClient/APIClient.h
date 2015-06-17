//
//  APIClient.h
//  APIClient
//
//  Created by Anthony Foster on 17/06/2015.
//  Copyright (c) 2015 Anthony Foster. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Callback)(NSError *error, id response);

extern __attribute__((visibility ("default"))) NSString *const APIErrorDomain;

typedef NS_ENUM(NSInteger, APIClientErrorCode) {
    APIClientReservedErrorCode = 0,
    APIClient4xxErrorCode      = 4,
    APIClient5xxErrorCode      = 5,
    APIClientInvalidJSONErrorCode = 98,
    APIClientCannotConnectErrorCode = kCFURLErrorCannotConnectToHost
};

@interface APIClient : NSObject
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSURL    *baseURL;

- (void) GET    : (NSString *) path                              done:(Callback) done;
- (void) GET    : (NSString *) path query:(NSDictionary *)query  done:(Callback) done;
- (void) PUT    : (NSString *) path  body:(NSDictionary *)body   done:(Callback) done;
- (void) POST   : (NSString *) path  body:(NSDictionary *)body   done:(Callback) done;
- (void) PATCH  : (NSString *) path  body:(NSDictionary *)body   done:(Callback) done;
- (void) DELETE : (NSString *) path                              done:(Callback) done;

@end
