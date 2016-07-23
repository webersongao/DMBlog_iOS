//
//  TGMetaWeblogXMLRPCApi.h
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

#import <Foundation/Foundation.h>
#import "TGMetaWeblogBaseApi.h"

@interface TGMetaWeblogXMLRPCApi : NSObject<TGMetaWeblogBaseApi>

/**
 Creates and initializes a `MetaWeblogAPI` client using password authentication.
 
 @param xmlrpc The XML-RPC endpoint URL, e.g.: https://en.blog.wordpress.com/xmlrpc.php
 @param username The user name
 @param password The password
 */
- (id)initWithXMLRPCEndpoint:(NSURL *)xmlrpc username:(NSString *)username password:(NSString *)password;


/**
 Given a site URL, tries to guess the URL for the XML-RPC endpoint
 
 When asked for a site URL, sometimes users type the XML-RPC url, or the xmlrpc.php has been moved/renamed. This method would try a few methods to find the proper XML-RPC endpoint:
 
 * Try to load the given URL adding `/xmlrpc.php` at the end. This is the most common use case for proper site URLs
 * If that fails, try a test XML-RPC request given URL, maybe it was the XML-RPC URL already
 * If that fails, fetch the given URL and search for an `EditURI` link pointing to the XML-RPC endpoint
 
 For additional URL typo fixing, see [NSURL-Guess](https://github.com/koke/NSURL-Guess)
 
 @param url what the user entered as the URL, e.g.: myblog.com
 @param success A block object to execute when the method finds a suitable XML-RPC endpoint on the site provided. This block has no return value and takes two arguments: the original site URL, and the found XML-RPC endpoint URL.
 @param failure A block object to execute when the method doesn't find a suitable XML-RPC endpoint on the site. This block has no return value and takes one argument: a NSError object with details on the error.
 */
-(void)guessXMLRPCURLForSite:(NSString *)url
                      success:(void (^)(NSURL *xmlrpcURL))success
                      failure:(void (^)(NSError *error))failure;


@end
