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

@interface VWWImgurController () <VWWWebViewControllerDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
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
    
    // Change endpoint for authentication
    [[VWWRESTEngine sharedInstance] setMode:VWWRESTEngineModeAuthentication];
    
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/"
                           @"%@?"
                           @"client_id=%@&"
                           @"response_type=%@&"
                           @"state=%@",
                           [VWWRESTConfig sharedInstance].serviceURLString,
                           [VWWRESTConfig sharedInstance].serviceAuthorize,
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


// Veryfity the account using stored credentials. Completion block YES is success, NO is fail.
-(void)verifyStoredAccountWithCompletionBlock:(VWWBoolBlock)completionBlock{

    // Change endpoint for authentication
    [[VWWRESTEngine sharedInstance] setMode:VWWRESTEngineModeAuthentication];
    
    // Called in webview delegate
    self.authorizeBlock = [completionBlock copy];
    NSString *code = [VWWUserDefaults code];
 

    [self getTokensFromCode:code];
}

#pragma mark Private methods


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


-(void)getAccount{
    [[VWWRESTEngine sharedInstance] getAccountWithCompletionBlock:^(NSDictionary *account) {
        if(account){
            VWW_LOG_DEBUG(@"Retrieved account information: %@", account.description);
            // TODO: Need to figure out what's useful to keep aroudn. For now let's just get
            // the user name and stick it in non-volatile memory
            
            // Write to NSUserDefaults
//            [VWWUserDefaults setAccount:account];
            NSDictionary *data = account[@"data"];
            NSString *username;
            if(data){
                username = data[@"url"];
            }
            if(data && username){
                VWW_LOG_DEBUG(@"Found username: %@. Storing in NSUserDefaults", username);
                [VWWUserDefaults setUsername:username];
                [self authorizationSucceeded:YES];
            } else {
                VWW_LOG_ERROR(@"Could not parse username out of account information")
                [self authorizationSucceeded:NO];
            }
            
        } else {
            VWW_LOG_ERROR(@"Retrieved good status code from account, but no information");
            [self authorizationSucceeded:NO];
        }
    } errorBlock:^(NSError *error, NSString *description) {
        VWW_LOG_ERROR(@"Failed to retrieve account information");
        VWW_LOG_TRACE;
        [self authorizationSucceeded:NO];
    }];
}


-(void)getTokensFromCode:(NSString*)code{
    VWWCodeForm *form = [[VWWCodeForm alloc]init];
    form.code = code;
    form.clientID = VWWImgurControllerConfigClientID;
    form.clientSecret = VWWImgurControllerConfigSecret;
    form.grantType = @"authorization_code";
    [[VWWRESTEngine sharedInstance] getTokensWithForm:form completionBlock:^(VWWToken *token) {
        
        // Write to NSUserDefaults
        [VWWUserDefaults setToken:token.accessToken];
        
        // Done authorizing. Change endpoint for queries
        [[VWWRESTEngine sharedInstance] setMode:VWWRESTEngineModeQuery];
        [self getAccount];
    } errorBlock:^(NSError *error, NSString *description) {
        [self authorizationSucceeded:NO];
    }];

}

#pragma mark VWWWebViewControllerDelegate
-(void)webViewController:(VWWWebViewController*)sender didAuthenticateWithRedirectURLString:(NSString*)redirectURLString{
    
    
    NSDictionary *responseDictionary = [self parseQuery:redirectURLString];
    NSString *code = responseDictionary[@"code"];
    [VWWUserDefaults setCode:code];
    VWW_LOG_DEBUG(@"Code: %@", code);
    
    [self getTokensFromCode:code];
}
-(void)webViewController:(VWWWebViewController*)sender didFailLoadWithError:(NSError *)error{
    VWW_LOG_ERROR(@"Failed to authenticate with error: %@", error);
//    [self authorizationSucceeded:NO];
}



@end
