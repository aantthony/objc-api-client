//
//  APIClient.m
//  APIClient
//
//  Created by Anthony Foster on 17/06/2015.
//  Copyright (c) 2015 Anthony Foster. All rights reserved.
//

#import "APIClient.h"

@interface APIClient()
@property (nonatomic) NSURLSession *session;
@end

NSString *const APIErrorDomain = @"com.apiclient.apiclient";

@implementation APIClient

static void invokeCallback(Callback callback, NSError *err, id response) {
    if (!callback) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        callback(err, response);
    });
}

static NSURL *encodeURLQueryString(NSURL *baseURL, NSString *path, NSDictionary *query) {
    NSURL *url = [baseURL URLByAppendingPathComponent:path];
    if (!query) return url;
    
    __block NSString *search = nil;
    [query enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        NSString *strKey   = search ? [@"&" stringByAppendingString:key] : [@"?" stringByAppendingString:key];
        NSString *strVal   = [value isKindOfClass:[NSNumber class]] ? [(NSNumber *)value stringValue] : value;
        
        NSString *component = [[strKey stringByAppendingString:@"="] stringByAppendingString:strVal];
        search = search ? [search stringByAppendingString:component] : component;
    }];
    if (search) {
        NSString *totalString = [[url absoluteString] stringByAppendingString:search];
        url = [NSURL URLWithString:totalString];
    }
    return url;
}


- (NSURLSession *) session {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:queue];
    });
    return _session;
}

- (void) request:(NSString *) method path:(NSString *) path query:(NSDictionary *)query body:(NSDictionary *) body done:(Callback) done {
    
    NSURL *url = encodeURLQueryString(_baseURL, path, query);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    req.HTTPMethod = method;
    req.timeoutInterval = 20;
    
    if (body) {
        req.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    if (_accessToken) {
        [req setValue:[@"Bearer " stringByAppendingString:_accessToken] forHTTPHeaderField:@"Authorization"];
    }
    
    NSURLSessionTask * task = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            if (error.code == kCFURLErrorCannotConnectToHost) {
                NSDictionary *userInfo = @{
                                           NSUnderlyingErrorKey: error,
                                           NSLocalizedDescriptionKey: @"Could not contact the server.",
                                           NSURLErrorKey: url};
                error = [NSError errorWithDomain:APIErrorDomain code:APIClientCannotConnectErrorCode userInfo:userInfo];
            }
            
            return invokeCallback(done, error, nil);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSError *jsonError;
        APIClientErrorCode code = APIClientReservedErrorCode;
        
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            json = @{@"message": text};
            code = APIClientInvalidJSONErrorCode;
        }
        
        if (httpResponse.statusCode >= 400 || jsonError) {
            if (!jsonError) {
                code = (httpResponse.statusCode >= 500) ? APIClient5xxErrorCode : APIClient4xxErrorCode;
            }
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: json[@"message"] ?: @"Unknown error.",
                                       NSURLErrorKey: url};
            
            
            error = [NSError errorWithDomain:APIErrorDomain code:code userInfo:userInfo];
        }
        
        invokeCallback(done, error, json);
        
    }];
    
    [task resume];
}

- (void) GET:(NSString *)path done:(Callback)done {
    [self request:@"GET" path:path query:nil body:nil done:done];
}
- (void) GET:(NSString *)path query:(NSDictionary *)query done:(Callback)done {
    [self request:@"GET" path:path query:query body:nil done:done];
}
- (void) POST:(NSString *)path body:(NSDictionary *)body done:(Callback)done {
    [self request:@"POST" path:path query:nil body:body done:done];
}
- (void) PUT:(NSString *)path body:(NSDictionary *)body done:(Callback)done {
    [self request:@"PUT" path:path query:nil body:body done:done];
}
- (void) PATCH:(NSString *)path body:(NSDictionary *)body done:(Callback)done {
    [self request:@"PATCH" path:path query:nil body:body done:done];
}
- (void) DELETE:(NSString *)path done:(Callback)done {
    [self request:@"DELETE" path:path query:nil body:nil done:done];
}

@end
