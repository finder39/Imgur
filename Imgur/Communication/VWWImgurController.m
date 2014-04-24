//
//  VWWImgurController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWImgurController.h"
#import "VWWImgurControllerConfig.h"
#import "VWWRESTConfig.h"

#import "VWWRESTEngine.h"
#import "VWWWebViewController.h"

// Type of authentication
typedef enum {
    VWWImgurControllerAuthTypeToken = 0,
    VWWImgurControllerAuthTypePin,
    VWWImgurControllerAuthTypeCode,
} VWWImgurControllerAuthType;

static VWWImgurController *instance;

@interface VWWImgurController () <VWWWebViewControllerDelegate>
@property (nonatomic, strong) VWWBoolBlock authorizeBlock;
@property (nonatomic) VWWImgurControllerAuthType authType;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) VWWWebViewController *webViewController;
@end

@implementation VWWImgurController

+(VWWImgurController*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VWWImgurController alloc]init];
    });
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        _authType = VWWImgurControllerAuthTypeCode;
    }
    return self;
}

-(void)authorizeWithViewController:(UIViewController*)viewController completionBlock:(VWWBoolBlock)completionBlock{
    // Called in webview delegate
    self.authorizeBlock = [completionBlock copy];
    
    // Build query string and present to user in a webview.
    // https://api.imgur.com/oauth2/authorize?client_id=YOUR_CLIENT_ID&response_type=REQUESTED_RESPONSE_TYPE&state=APPLICATION_STATE
    
    NSString *responseType;
    if(self.authType == VWWImgurControllerAuthTypeToken){
        responseType = @"token";
    } else if(self.authType == VWWImgurControllerAuthTypePin){
        responseType = @"pin";
    } else if(self.authType == VWWImgurControllerAuthTypeCode){
        responseType = @"code";
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/"
                           @"%@?"
                           @"client_id=%@&"
                           @"response_type=%@&"
                           @"state=%@",
                           [VWWRESTConfig sharedInstance].serviceURLString,
                           [VWWRESTConfig sharedInstance].authorizeURI,
                           VWWImgurControllerConfigClientID,
                           responseType,
                           @"auth"];

    
    VWW_LOG_DEBUG(@"urlString: %@", urlString);

    self.webViewController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"VWWWebViewController"];
    self.webViewController.delegate = self;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    self.webViewController.urlRequest = urlRequest;
    

    [viewController presentViewController:self.webViewController animated:YES completion:^{
        
    }];
    VWW_LOG_TRACE;
}

- (NSDictionary *)parseQuery:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@"&"];
    NSMutableDictionary *receivedDict = [NSMutableDictionary dictionary];
    for (NSString *component in components) {
        NSArray *parts = [component componentsSeparatedByString:@"="];
        if (parts.count == 2) {
            receivedDict[parts[0]] = parts[1];
        }
    }
    return receivedDict;
}


-(void)authorizationSucceeded:(BOOL)success{
    // Remove web view from view controller
    [self.webView removeFromSuperview];
    _webView = nil;
    
    // Fire completion block
    if(self.authorizeBlock == nil) return;
    self.authorizeBlock(success);
    _authorizeBlock = nil;
}


#pragma mark VWWWebViewControllerDelegate
-(void)webViewController:(VWWWebViewController*)sender didAuthenticateWithRedirectURLString:(NSString*)redirectURLString{
    
    
    NSDictionary *responseDictionary = [self parseQuery:redirectURLString];
    NSString *code = responseDictionary[@"code"];
    VWW_LOG_DEBUG(@"Code: %@", code);

    VWWCodeForm *form = [[VWWCodeForm alloc]init];
    form.code = code;
    form.clientID = VWWImgurControllerConfigClientID;
    form.clientSecret = VWWImgurControllerConfigSecret;
    form.grantType = @"authorization_code";
    [[VWWRESTEngine sharedInstance] getTokensWithForm:form completionBlock:^(VWWToken *token) {
        // Write access token to NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:token.accessToken forKey:VWWTokenAccessTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self authorizationSucceeded:YES];
    } errorBlock:^(NSError *error, NSString *description) {
        [self authorizationSucceeded:NO];
    }];

}
-(void)webViewController:(VWWWebViewController*)sender didFailLoadWithError:(NSError *)error{
    VWW_LOG_ERROR(@"Failed to authenticate with error: %@", error);
    [self authorizationSucceeded:NO];
}
@end
