//
//
// Copyright (c) 2015 TGMetaWeblogApi (http://www.terwer.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "TGXMLRPCApiClient.h"
#import "WPXMLRPCEncoder.h"
#import "WPXMLRPCDecoder.h"

NSString *const WPXMLRPCClientErrorDomain = @"XMLRPC";
static NSUInteger const WPXMLRPCClientDefaultMaxConcurrentOperationCount = 4;

@interface TGXMLRPCApiClient ()
@property(readwrite, nonatomic, strong) NSURL *xmlrpcEndpoint;
@property(readwrite, nonatomic, strong) NSMutableDictionary *defaultHeaders;
@property(readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation TGXMLRPCApiClient


#pragma mark - Creating and Initializing XML-RPC Clients

+ (TGXMLRPCApiClient *)clientWithXMLRPCEndpoint:(NSURL *)xmlrpcEndpoint {
    return [[self alloc] initWithXMLRPCEndpoint:xmlrpcEndpoint];
}

- (id)initWithXMLRPCEndpoint:(NSURL *)xmlrpcEndpoint {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.xmlrpcEndpoint = xmlrpcEndpoint;
    
    self.defaultHeaders = [NSMutableDictionary dictionary];
    
    // Accept-Encoding HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3
    if (([[[UIDevice currentDevice] systemVersion] compare:@"7.1" options:NSNumericSearch] != NSOrderedAscending)) {
        // if iOS 7.1 or later
        [self setDefaultHeader:@"Accept-Encoding" value:@"gzip, deflate"];
    } else {
        // Disable compression by default, since it causes connection problems with some hosts
        // Fixed in iOS SDK 7.1 see: https://developer.apple.com/library/ios/releasenotes/General/RN-iOSSDK-7.1/
        [self setDefaultHeader:@"Accept-Encoding" value:@"identity"];
    }
    [self setDefaultHeader:@"Content-Type" value:@"text/xml"];
    
    NSString *applicationUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    if (applicationUserAgent) {
        [self setDefaultHeader:@"User-Agent" value:applicationUserAgent];
    } else {
        [self setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"%@/%@ (%@, %@ %@, %@, Scale/%f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey], @"unknown", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] model], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0)]];
    }
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue setMaxConcurrentOperationCount:WPXMLRPCClientDefaultMaxConcurrentOperationCount];
    
    return self;
}



#pragma mark - Creating Request Objects

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                parameters:(NSArray *)parameters {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.xmlrpcEndpoint];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:self.defaultHeaders];
    
    WPXMLRPCEncoder *encoder = [[WPXMLRPCEncoder alloc] initWithMethod:method andParameters:parameters];
    [request setHTTPBody:[encoder dataEncodedWithError:nil]];
    
    return request;
}

#pragma mark - Managing HTTP Header Values

- (NSString *)defaultValueForHeader:(NSString *)header {
    return [self.defaultHeaders valueForKey:header];
}

- (void)setDefaultHeader:(NSString *)header value:(NSString *)value {
    [self.defaultHeaders setValue:value forKey:header];
}

- (void)setAuthorizationHeaderWithToken:(NSString *)token {
    [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", token]];
}

- (void)clearAuthorizationHeader {
    [self.defaultHeaders removeObjectForKey:@"Authorization"];
}

#pragma mark - Creating HTTP Operations

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    BOOL extra_debug_on = getenv("MWDebugXMLRPC") ? YES : NO;
#ifndef DEBUG
    NSNumber *extra_debug = [[NSUserDefaults standardUserDefaults] objectForKey:@"extra_debug"];
    if ([extra_debug boolValue]) extra_debug_on = YES;
#endif

    void (^xmlrpcSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            WPXMLRPCDecoder *decoder = [[WPXMLRPCDecoder alloc] initWithData:responseObject];
            NSError *err = nil;
            if (extra_debug_on == YES) {
                NSLog(@"[XML-RPC] < %@", operation.responseString);
            }

            if ([decoder isFault] || [decoder object] == nil) {
                err = [decoder error];
            }

            if ([decoder object] == nil && extra_debug_on) {
                NSLog(@"Blog returned invalid data (URL: %@)\n%@", request.URL.absoluteString, operation.responseString);
            }

            id object = [[decoder object] copy];

            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (err) {
                    if (failure) {
                        failure(operation, err);
                    }
                } else {
                    if (success) {
                        success(operation, object);
                    }
                }
            });
        });
    };
    void (^xmlrpcFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (extra_debug_on == YES) {
            NSLog(@"[XML-RPC] ! %@", [error localizedDescription]);
        }

        if (failure) {
            failure(operation, error);
        }
    };
    [operation setCompletionBlockWithSuccess:xmlrpcSuccess failure:xmlrpcFailure];

    if (extra_debug_on == YES) {
        NSString *requestString = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
        if (getenv("WPDebugXMLRPC")) {
            NSLog(@"[XML-RPC] > %@", requestString);
        } else {
            NSError *error = NULL;
            NSRegularExpression *method = [NSRegularExpression regularExpressionWithPattern:@"<methodName>(.*)</methodName>" options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *matches = [method matchesInString:requestString options:0 range:NSMakeRange(0, [requestString length])];
            NSString *methodName = nil;
            if (matches.count > 0) {
                NSRange methodRange = [[matches objectAtIndex:0] rangeAtIndex:1];
                if (methodRange.location != NSNotFound)
                    methodName = [requestString substringWithRange:methodRange];
            } else if ([request HTTPBodyStream] != nil) {
                methodName = @"streaming request, unknown method";
            }
            NSLog(@"[XML-RPC] > %@", methodName);
        }
    }

    return operation;
}

#pragma mark - Managing Enqueued HTTP Operations

- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation {
    [self.operationQueue addOperation:operation];
}

- (void)cancelAllHTTPOperations {
    for (AFHTTPRequestOperation *operation in [self.operationQueue operations]) {
        [operation cancel];
    }
}

#pragma mark - Making XML-RPC Requests

- (void)callMethod:(NSString *)method
        parameters:(NSArray *)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSURLRequest *request = [self requestWithMethod:method parameters:parameters];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    [self enqueueHTTPRequestOperation:operation];


}


@end