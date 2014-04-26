//
//  VWWRESTEngine.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//


#import "MKNetworkEngine.h"
#import "VWWRESTConfig.h"

// Forms
#import "VWWCodeForm.h"
#import "VWWPaginationForm.h"
#import "VWWToken.h"

typedef enum {
    VWWRESTEngineModeAuthentication = 0,
    VWWRESTEngineModeQuery,
} VWWRESTEngineMode;


@interface VWWRESTEngine : MKNetworkEngine
+(VWWRESTEngine*)sharedInstance;
@property (nonatomic, strong) VWWRESTConfig* service;
@property (nonatomic, strong) NSString *accessToken;

-(void)setMode:(VWWRESTEngineMode)mode;

-(MKNetworkOperation*)getTokensWithForm:(VWWCodeForm*)form
                        completionBlock:(VWWTokenBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock;


-(MKNetworkOperation*)getAccountWithCompletionBlock:(VWWDictionaryBlock)completionBlock
                                         errorBlock:(VWWErrorStringBlock)errorBlock;




// https://api.imgur.com/endpoints/account#images
-(MKNetworkOperation*)getImagesWithForm:(VWWPaginationForm*)form
                        completionBlock:(VWWArrayBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock;

//
//
//// https://api.imgur.com/endpoints/account#albums
//-(MKNetworkOperation*)getAlbumsWithForm:(VWWPaginationForm*)form
//                        completionBlock:(VWWArrayBlock)completionBlock
//                             errorBlock:(VWWErrorStringBlock)errorBlock;
//
//
//// https://api.imgur.com/endpoints/account#comments
//-(MKNetworkOperation*)getCommentsWithForm:(VWWPaginationForm*)form
//                        completionBlock:(VWWArrayBlock)completionBlock
//                             errorBlock:(VWWErrorStringBlock)errorBlock;
//
//
//// https://api.imgur.com/endpoints/account#replies
//-(MKNetworkOperation*)getRepliesWithForm:(VWWPaginationForm*)form
//                          completionBlock:(VWWArrayBlock)completionBlock
//                               errorBlock:(VWWErrorStringBlock)errorBlock;
//
//
//// https://api.imgur.com/endpoints/account#account-profile
//-(MKNetworkOperation*)getGalleryProfileWithForm:(VWWPaginationForm*)form
//                         completionBlock:(VWWArrayBlock)completionBlock
//                              errorBlock:(VWWErrorStringBlock)errorBlock;
//
//// https://api.imgur.com/endpoints/account#account-settings
//-(MKNetworkOperation*)getAccountSettingsWithForm:(VWWPaginationForm*)form
//                                 completionBlock:(VWWArrayBlock)completionBlock
//                                      errorBlock:(VWWErrorStringBlock)errorBlock;
//
//
//// https://api.imgur.com/endpoints/account#update-settings
//-(MKNetworkOperation*)postAccountSettingsWithForm:(VWWHTTPForm*)form
//                                  completionBlock:(VWWArrayBlock)completionBlock
//                                       errorBlock:(VWWErrorStringBlock)errorBlock;


@end
