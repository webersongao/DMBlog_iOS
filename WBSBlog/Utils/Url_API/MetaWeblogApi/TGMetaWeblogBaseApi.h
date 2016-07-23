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
//#import "AFNetworking/AFNetworking.h"
#import "AFNetworking.h"


@protocol TGMetaWeblogBaseApi <NSObject>

///---------------------
/// @name Managing posts
///---------------------

/**
 Get a list of the recent posts
 
 @param count Number of recent posts to get
 @param success A block object to execute when the method successfully publishes the post. This block has no return value and takes one argument: an array with the latest posts.
 @param failure A block object to execute when the method can't publish the post. This block has no return value and takes one argument: a NSError object with details on the error.
 */
- (void)getRecentPosts:(NSUInteger)count
               success:(void (^)(NSArray *posts))success
               failure:(void (^)(NSError *error))failure;
/**
 *  delete a post
 *
 *  @param postid  postid
 *  @param success success
 *  @param failure failure
 */
- (void)deletePost:(NSString *)postId
           success:(void(^)(BOOL status))success
           failure:(void(^)(NSError *errror))failure;
;
@end