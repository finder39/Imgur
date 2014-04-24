//
//  VWWWebViewController.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VWWWebViewController;

@protocol VWWWebViewControllerDelegate <NSObject>
-(void)webViewController:(VWWWebViewController*)sender didAuthenticateWithRedirectURLString:(NSString*)redirectURLString;
-(void)webViewController:(VWWWebViewController*)sender didFailLoadWithError:(NSError *)error;
@end

@interface VWWWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *urlRequest;
@property (weak, nonatomic) id <VWWWebViewControllerDelegate> delegate;
@end
