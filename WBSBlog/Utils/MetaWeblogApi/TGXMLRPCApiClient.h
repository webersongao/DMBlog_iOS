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

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface TGXMLRPCApiClient : NSObject

///------------------------------------------------
/// @name Creating and Initializing XML-RPC Clients
///------------------------------------------------

/**
 Creates and initializes an `AFXMLRPCClient` object with the specified base URL.
 
 @param xmlrpcEndpoint The XML-RPC endpoint URL for the XML-RPC client. This argument must not be nil.
 
 @return The newly-initialized XML-RPC client
 */
+ (TGXMLRPCApiClient *)clientWithXMLRPCEndpoint:(NSURL *)xmlrpcEndpoint;

/**
 Initializes an `AFXMLRPCClient` object with the specified base URL.
 
 @param xmlrpcEndpoint The XML-RPC endpoint URL for the XML-RPC client. This argument must not be nil.
 
 @return The newly-initialized XML-RPC client
 */
- (id)initWithXMLRPCEndpoint:(NSURL *)xmlrpcEndpoint;

///-------------------------------
/// @name Creating Request Objects
///-------------------------------

/**
 Creates a `NSMutableURLRequest` object with the specified XML-RPC method and parameters.
 
 @param method The XML-RPC method for the request.
 @param parameters The XML-RPC parameters to be set as the request body.
 
 @return A `NSMutableURLRequest` object
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                parameters:(NSArray *)parameters;


///-------------------------------
/// @name Creating HTTP Operations
///-------------------------------

/**
 Creates an `AFHTTPRequestOperation`
 
 @param request The request object to be loaded asynchronously during execution of the operation.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


///----------------------------------------
/// @name Managing Enqueued HTTP Operations
///----------------------------------------

/**
 Enqueues an `AFHTTPRequestOperation` to the XML-RPC client's operation queue.
 
 @param operation The XML-RPC request operation to be enqueued.
 */
- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation;

/**
Creates an `AFHTTPRequestOperation` with a `XML-RPC` request, and enqueues it to the HTTP client's operation queue.

@param method The XML-RPC method.
@param parameters The XML-RPC parameters to be set as the request body.
@param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
@param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.

@see HTTPRequestOperationWithRequest:success:failure
*/
- (void)callMethod:(NSString *)method
        parameters:(NSArray *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end