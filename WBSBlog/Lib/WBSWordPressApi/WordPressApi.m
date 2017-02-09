#import "WordPressApi.h"
#import "WordPressXMLRPCApi.h"
#import "WordPressRestApi.h"

@implementation WordPressApi

+ (void)loginInWithURL:(NSString *)url username:(NSString *)username password:(NSString *)password success:(void (^)(NSURL *xmlrpcURL))success failure:(void (^)(NSError *error))failure {
    [WordPressXMLRPCApi guessXMLRPCURLForSite:url success:^(NSURL *xmlrpcURL) {
        [self loginInWithXMLRPCURL:xmlrpcURL username:username password:password success:^{
            if (success) {
                success(xmlrpcURL);
            }
        } failure:failure];
    } failure:failure];
}

+ (void)loginInWithXMLRPCURL:(NSURL *)xmlrpcURL username:(NSString *)username password:(NSString *)password success:(void (^)())success failure:(void (^)(NSError *error))failure {
    WordPressXMLRPCApi *api = [self apiWithXMLRPCURL:xmlrpcURL username:username password:password];
    [api authenticateWithSuccess:success failure:failure];
}

+ (id<WordPressBaseApi>)apiWithXMLRPCURL:(NSURL *)xmlrpcURL username:(NSString *)username password:(NSString *)password {
    return [WordPressXMLRPCApi apiWithXMLRPCEndpoint:xmlrpcURL username:username password:password];
}

+ (void)loginInWithOauthWithSuccess:(void (^)(NSString *authToken, NSString *siteId))success failure:(void (^)(NSError *error))failure {
    [WordPressRestApi loginInWithOauthWithSuccess:success failure:failure];
}

+ (id<WordPressBaseApi>)apiWithOauthToken:(NSString *)authToken siteId:(NSString *)siteId {
    return [[WordPressRestApi alloc] initWithOauthToken:authToken siteId:siteId];
}

+ (void)loginInWithJetpackUsername:(NSString *)username password:(NSString *)password success:(void (^)(NSString *authToken))success failure:(void (^)(NSError *error))failure {
    [WordPressRestApi loginInWithJetpackUsername:username password:password success:success failure:failure];
}

+ (void)setWordPressComClient:(NSString *)clientId {
    [WordPressRestApi setWordPressComClient:clientId];
}

+ (void)setWordPressComSecret:(NSString *)secret {
    [WordPressRestApi setWordPressComSecret:secret];
}

+ (void)setWordPressComRedirectUrl:(NSString *)redirectUrl {
    [WordPressRestApi setWordPressComRedirectUrl:redirectUrl];
}

+ (BOOL)handleOpenURL:(NSURL *)URL {
    return [WordPressRestApi handleOpenURL:URL];
}

@end
