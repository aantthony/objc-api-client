# objc-api-client

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
