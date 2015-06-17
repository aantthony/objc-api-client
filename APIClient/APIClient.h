//
//  APIClient.h
//  APIClient
//
//  Created by Anthony Foster on 17/06/2015.
//  Copyright (c) 2015 Anthony Foster. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Callback)(NSError *error, id response);

//! Error domain for APIClient
extern __attribute__((visibility ("default"))) NSString *const APIErrorDomain;

typedef NS_ENUM(NSInteger, APIClientErrorCode) {
    APIClientReservedErrorCode = 0,
    APIClient4xxErrorCode      = 4,
    APIClient5xxErrorCode      = 5,
    APIClientInvalidJSONErrorCode = 98,
    APIClientCannotConnectErrorCode = kCFURLErrorCannotConnectToHost
};

/*!
 @class APIClient
 
 @abstract
 Generic API Client
 
 @discussion
 The Authorization header is set to 'Bearer {{accessToken}}' if it is not nil.
 All requests are relative to baseUrl.
*/
@interface APIClient : NSObject


/*! 
 @method accessToken:
 @abstract Sets the token used in the HTTP request 'Authorization' header.
 @param method the new access token.
 */
@property (nonatomic) NSString *accessToken;


/*! 
 @method baseURL:
 @abstract Sets the URL that requests are relative to. This value is required.
 @param base URL for all HTTP requests
 */
@property (nonatomic) NSURL *baseURL;


/* Send a GET request to a path. */
- (void) GET    : (NSString *) path                              done:(Callback) done;

/* Send a GET request to a path with query string parameters. */
- (void) GET    : (NSString *) path query:(NSDictionary *)query  done:(Callback) done;

/* Send JSON data in a PUT request. */
- (void) PUT    : (NSString *) path  body:(NSDictionary *)body   done:(Callback) done;

/* Send JSON data in a POST request. */
- (void) POST   : (NSString *) path  body:(NSDictionary *)body   done:(Callback) done;

/* Send JSON data in a PATCH request. */
- (void) PATCH  : (NSString *) path  body:(NSDictionary *)body   done:(Callback) done;

/* Send a DELETE request to a path. */
- (void) DELETE : (NSString *) path                              done:(Callback) done;

@end
