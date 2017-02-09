#import <Foundation/Foundation.h>
#ifndef _WORDPRESSAPI
#define _WORDPRESSAPI
#import "WPXMLRPCClient.h"
#import "WPXMLRPCRequest.h"
#import "WPXMLRPCRequestOperation.h"
#import "WordPressBaseApi.h"
#import "WordPressRestApi.h"
#import "WordPressXMLRPCApi.h"
#import "WPComOAuthController.h"
#endif /* _WORDPRESSAPI */

@interface WordPressApi : NSObject

+ (void)loginInWithURL:(NSString *)url username:(NSString *)username password:(NSString *)password success:(void (^)(NSURL *xmlrpcURL))success failure:(void (^)(NSError *error))failure;

+ (void)loginInWithXMLRPCURL:(NSURL *)xmlrpcURL username:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure;
+ (id<WordPressBaseApi>)apiWithXMLRPCURL:(NSURL *)xmlrpcURL username:(NSString *)username password:(NSString *)password;

+ (void)loginInWithOauthWithSuccess:(void (^)(NSString *authToken, NSString *siteId))success failure:(void (^)(NSError *error))failure;
+ (id<WordPressBaseApi>)apiWithOauthToken:(NSString *)authToken siteId:(NSString *)siteId;

+ (void)loginInWithJetpackUsername:(NSString *)username password:(NSString *)password success:(void (^)(NSString *authToken))success failure:(void (^)(NSError *error))failure;

+ (void)setWordPressComClient:(NSString *)clientId;
+ (void)setWordPressComSecret:(NSString *)secret;
+ (void)setWordPressComRedirectUrl:(NSString *)redirectUrl;
+ (BOOL)handleOpenURL:(NSURL *)URL;

@end
