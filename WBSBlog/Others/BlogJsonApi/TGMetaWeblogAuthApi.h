//
//  TGMetaWeblogAuthApi.h
//
// Copyright (c) 2016 WBSMetaWeblogApi (http://www.terwer.com/)
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
#import <Foundation/Foundation.h>
#import "TGMetaWeblogBaseApi.h"

@interface TGMetaWeblogAuthApi : NSObject

#pragma mark auth api
/**
 *  Sign in blog by the blog root url,author's username and password,in this case the xmlrpc url will be auto guessed,commonly,like wordpress,its url is xmlrpc.php
 *
 *  @param url      the blog root url
 *  @param username username of the blog author
 *  @param password password of the blog author
 *  @param success  do sth. when success
 *  @param failure  do sth. when failed
 */
+ (void)signInWithURL:(NSString *)url username:(NSString *)username password:(NSString *)password success:(void (^)(NSURL *xmlrpcURL))success failure:(void (^)(NSError *error))failure;


/**
 *  Init the metaweblog api with username and password
 *
 *  @param xmlrpcURL xmlrpcURL description
 *  @param username  username of the blog author
 *  @param password  password of the blog author
 *
 *  @return metaweblog api instance
 */
+ (id<TGMetaWeblogBaseApi>)apiWithXMLRPCURL:(NSURL *)xmlrpcURL username:(NSString *)username password:(NSString *)password;

@end
