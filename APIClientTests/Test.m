//
//  Test.m
//  APIClient
//
//  Created by Anthony Foster on 17/06/2015.
//  Copyright (c) 2015 Anthony Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "APIClient.h"

@interface Test : XCTestCase
@property APIClient *client;
@end

@implementation Test

- (void)setUp {
    [super setUp];
    self.client = [[APIClient alloc] init];
    self.client.baseURL = [NSURL URLWithString:@"http://graph.facebook.com"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *e = [self expectationWithDescription:@"request"];
    [self.client GET:@"cocacola" query:@{@"fields": @"about"} done:^(NSError *error, id response) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(response[@"about"]);
        [e fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
