//
//  VWWWebViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWWebViewController.h"
#import "NSString+URLEncoding.h"

@interface VWWWebViewController () <UIWebViewDelegate>

@end

@implementation VWWWebViewController

#pragma mark UIViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.webView.delegate = self;
    [self.webView loadRequest:self.urlRequest];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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


#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    VWW_LOG_DEBUG(@"request: %@", request);
    VWW_LOG_DEBUG(@"navType: %ld", (long)navigationType);
    
    // Once user logs in we will get their goodies in the ridirect URL. Example:
    // https://imgur.com/?state=auth&code=860381d0651a8c24079aa13c8732567d8a3f7bab
    NSString *redirectURLString = [[[request URL] absoluteString] URLDecodedString];// request.URL.absoluteString;
    if ([redirectURLString rangeOfString:@"code="].location != NSNotFound) {
        [self.delegate webViewController:self didAuthenticateWithRedirectURLString:redirectURLString];
        
        [self dismissViewControllerAnimated:YES completion:^{}];

    }
    VWW_LOG_TRACE;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    VWW_LOG_TRACE;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    VWW_LOG_TRACE;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    VWW_LOG_TRACE;
    [self.delegate webViewController:self didFailLoadWithError:error];
}


@end
