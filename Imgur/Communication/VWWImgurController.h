//
//  VWWImgurController.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//
//  Oauth manual
//  https://api.imgur.com/oauth2
//
//  Account settings (app ids, etc...)
//  https://imgur.com/account/settings/apps
//
//  Here is a link to the APIs:
//  https://api.imgur.com/models/image
//


#import <Foundation/Foundation.h>

@interface VWWImgurController : NSObject
+(VWWImgurController*)sharedInstance;
-(void)authorizeWithViewController:(UIViewController*)viewController completionBlock:(VWWBoolBlock)completionBlock;
@end
