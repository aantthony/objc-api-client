# objc-api-client

[![Pod Version](https://img.shields.io/cocoapods/v/APIHTTPClient.svg)](https://cocoapods.org/pods/APIHTTPClient)
[![Build Status](https://img.shields.io/travis/aantthony/objc-api-client/master.svg)](https://travis-ci.org/aantthony/objc-api-client)
 [![License](https://img.shields.io/cocoapods/l/APIHTTPClient.svg)](https://cocoapods.org/pods/APIHTTPClient)

## Installation

`pod install APIHTTPClient`

## Usage

```objective-c

#import "AppDelegate.h"
#import <APIClient/APIClient.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    APIClient *client = [[APIClient alloc] init];
    client.baseURL = [NSURL URLWithString:@"https://api.github.com"];
    // client.accessToken = @"test";
    [client GET:@"/" done:^(NSError *error, id response) {
        NSLog(@"Response: %@ %@", error, response);
    }];
    return YES;
}

@end
```
