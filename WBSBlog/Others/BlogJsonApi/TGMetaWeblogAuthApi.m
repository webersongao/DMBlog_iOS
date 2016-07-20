
//
//  TGMetaWeblogAuthApi.m
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
#import "TGMetaWeblogAuthApi.h"
#import "TGMetaWeblogXMLRPCApi.h"

@implementation TGMetaWeblogAuthApi

/**
 *  validate xmlrpc request
 *
 *  @param url      url
 *  @param username username
 *  @param password password
 *  @param success  success
 *  @param failure  failure
 */
+ (void)signInWithURL:(NSString *)url username:(NSString *)username password:(NSString *)password success:(void (^)(NSURL *xmlrpcURL))success failure:(void (^)(NSError *error))failure {
    TGMetaWeblogXMLRPCApi *api = [self apiWithXMLRPCURL:[NSURL URLWithString:url] username:username password:password];
    [api guessXMLRPCURLForSite:url success:^(NSURL *xmlrpcURL) {
        if (success) {
            success(xmlrpcURL);
        }
    } failure:failure];
}

/**
 *  get api instance
 *
 *  @param xmlrpcURL xmlrpcURL
 *  @param username  username
 *  @param password  password
 *
 *  @return <#return value description#>
 */
+ (id<TGMetaWeblogBaseApi>)apiWithXMLRPCURL:(NSURL *)xmlrpcURL username:(NSString *)username password:(NSString *)password {
    return [[TGMetaWeblogXMLRPCApi alloc]initWithXMLRPCEndpoint:xmlrpcURL username:username password:password];
}

@end
