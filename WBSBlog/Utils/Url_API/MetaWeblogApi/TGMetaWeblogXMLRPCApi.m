//
//  TGMetaWeblogXMLRPCApi.m
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

#import "TGMetaWeblogXMLRPCApi.h"
#import "TGXMLRPCApiClient.h"

@interface TGMetaWeblogXMLRPCApi ()

@property (readwrite, nonatomic, strong) NSURL *xmlrpc;
@property (readwrite, nonatomic, strong) NSString *username;
@property (readwrite, nonatomic, strong) NSString *password;
@property (readwrite, nonatomic, strong) TGXMLRPCApiClient *client;

@end

@implementation TGMetaWeblogXMLRPCApi

- (id)initWithXMLRPCEndpoint:(NSURL *)xmlrpc username:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.xmlrpc = xmlrpc;
    self.username = username;
    self.password = password;
    
    self.client = [TGXMLRPCApiClient clientWithXMLRPCEndpoint:xmlrpc];
    
    return self;
}

#pragma mark - Helpers
-(void)guessXMLRPCURLForSite:(NSString *)url
                     success:(void (^)(NSURL *xmlrpcURL))success
                     failure:(void (^)(NSError *error))failure {
    __block NSURL *xmlrpcURL;
    __block NSString *xmlrpc;
    
    // ------------------------------------------------
    // 0. Is an empty url? Sorry, no psychic powers yet
    // ------------------------------------------------
    if (url == nil || [url isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:@"com.terwer.api" code:0 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Empty URL", @"") forKey:NSLocalizedDescriptionKey]];
        NSLog(@"%@",[error localizedDescription]);
        return failure ? failure(error) : nil;
    }
    
    // ------------------------------------------------------------------------
    // 1. Assume the given url is the home page and XML-RPC sits at /xmlrpc.php
    // ------------------------------------------------------------------------
    NSLog( @"1. Assume the given url is XML-RPC endpoint" );
    NSURL *baseURL = [NSURL URLWithString:url];
    if (!baseURL.scheme) {
        url = [NSString stringWithFormat:@"http://%@", url];
    } else {
        url = [baseURL absoluteString];
    }
    
    xmlrpcURL = [NSURL URLWithString:url];
    if (xmlrpcURL == nil) {
        // Not a valid URL. Could be a bad protocol (htpp://), syntax error (http//), ...
        // See https://github.com/koke/NSURL-Guess for extra help cleaning user typed URLs
        NSError *error = [NSError errorWithDomain:@"com.terwer.api" code:1 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Invalid URL", @"") forKey:NSLocalizedDescriptionKey]];
        NSLog(@"%@",[error localizedDescription]);
        return failure ? failure(error) : nil;
    }
    NSLog(@"Trying the following URL,like /xmlrpc.php: %@", xmlrpcURL );
    
    [self validateXMLRPCUrl:xmlrpcURL success:^(NSURL *validatedXmlrpcURL){
        if (success) {
            success(validatedXmlrpcURL);
        }
    } failure:^(NSError *error){
        NSLog(@"%@",[error localizedDescription]);
        
        // -------------------------------------------
        // 2. Try the given url as an XML-RPC endpoint
        // -------------------------------------------
        NSLog(@"2. Try the xmlrpc url as an XML-RPC endpoint");
        
        xmlrpc = [NSString stringWithFormat:@"%@/xmlrpc.php", url];
        
        xmlrpcURL = [NSURL URLWithString:url];
        NSLog( @"Trying the following URL: %@", url);
        
        
        [self  validateXMLRPCUrl:xmlrpcURL success:^(NSURL *validatedXmlrpcURL){
            if (success) {
                success(validatedXmlrpcURL);
            }
        } failure:^(NSError *error){
            NSLog(@"%@",[error localizedDescription]);
            if (failure) {
                failure(error);
                return;
            }
            
        }];
        
        
    }];
    
}

-(void)validateXMLRPCUrl:(NSURL *)url success:(void (^)(NSURL *validatedXmlrpURL))success failure:(void (^)(NSError *error))failure {
    NSArray *parameters = [NSArray arrayWithObjects:@"1",self.username, self.password,@(1) , nil];
    [self.client callMethod:@"metaWeblog.getRecentPosts"
                 parameters:parameters
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (success) {
                            //NSLog(@"test metaWeblog.getRecentPosts response:%@",responseObject);
                            NSLog(@"test metaWeblog.getRecentPosts success");
                            success(url);
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
}


#pragma mark - Managing posts

- (void)getRecentPosts:(NSUInteger)count
               success:(void (^)(NSArray *posts))success
               failure:(void (^)(NSError *error))failure {
    NSArray *parameters = [NSArray arrayWithObjects:@"1",self.username, self.password,@(count) , nil];
    [self.client callMethod:@"metaWeblog.getRecentPosts"
                 parameters:parameters
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (success) {
                            success((NSArray *)responseObject);
                        }
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
}

- (void) deletePost:(NSString *)postId success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure{
    NSArray *parameters = [NSArray arrayWithObjects:@"1",postId,self.username, self.password, nil];
    [self.client callMethod:@"metaWeblog.deletePost"
                 parameters:parameters
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (success) {
                            BOOL result = (BOOL)responseObject;
                            success(result);
                        }
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
    
}
@end
