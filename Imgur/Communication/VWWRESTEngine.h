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

// Models
#import "VWWAlbum.h"
#import "VWWImage.h"
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

// https://api.imgur.com/oauth2
// https://api.imgur.com/oauth2/token
-(MKNetworkOperation*)getTokensWithForm:(VWWCodeForm*)form
                        completionBlock:(VWWTokenBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock;

// https://api.imgur.com/endpoints/account
// https://api.imgur.com/3/account/{username}
-(MKNetworkOperation*)getAccountWithCompletionBlock:(VWWDictionaryBlock)completionBlock
                                         errorBlock:(VWWErrorStringBlock)errorBlock;




// https://api.imgur.com/endpoints/account#images
// https://api.imgur.com/3/account/{username}/images/{page}
-(MKNetworkOperation*)getImagesWithForm:(VWWPaginationForm*)form
                        completionBlock:(VWWArrayBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock;

// https://api.imgur.com/endpoints/account#albums
// https://api.imgur.com/3/account/{username}/albums/{page}
-(MKNetworkOperation*)getAlbumsWithForm:(VWWPaginationForm*)form
                        completionBlock:(VWWArrayBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock;

// https://api.imgur.com/endpoints/album#album-images
// https://api.imgur.com/3/album/{id}/images
-(MKNetworkOperation*)getAlbumImagesWithUUID:(NSString*)uuid
                             completionBlock:(VWWArrayBlock)completionBlock
                                  errorBlock:(VWWErrorStringBlock)errorBlock;



//
//
// https://api.imgur.com/endpoints/account#comments
// https://api.imgur.com/3/account/{username}/comments
//-(MKNetworkOperation*)getCommentsWithForm:(VWWPaginationForm*)form
//                        completionBlock:(VWWArrayBlock)completionBlock
//                             errorBlock:(VWWErrorStringBlock)errorBlock;
//
//
// https://api.imgur.com/endpoints/account#replies
// https://api.imgur.com/3/account/{username}/notifications/replies
//-(MKNetworkOperation*)getRepliesWithForm:(VWWPaginationForm*)form
//                          completionBlock:(VWWArrayBlock)completionBlock
//                               errorBlock:(VWWErrorStringBlock)errorBlock;
//
//
// https://api.imgur.com/endpoints/account#account-profile
//-(MKNetworkOperation*)getGalleryProfileWithForm:(VWWPaginationForm*)form
//                         completionBlock:(VWWArrayBlock)completionBlock
//                              errorBlock:(VWWErrorStringBlock)errorBlock;
//
// https://api.imgur.com/endpoints/account#account-settings
// https://api.imgur.com/3/account/{username}/settings
//-(MKNetworkOperation*)getAccountSettingsWithForm:(VWWPaginationForm*)form
//                                 completionBlock:(VWWArrayBlock)completionBlock
//                                      errorBlock:(VWWErrorStringBlock)errorBlock;
//
//
// https://api.imgur.com/endpoints/account#update-settings
// https://api.imgur.com/3/account/{username}/settings
//-(MKNetworkOperation*)postAccountSettingsWithForm:(VWWHTTPForm*)form
//                                  completionBlock:(VWWArrayBlock)completionBlock
//                                       errorBlock:(VWWErrorStringBlock)errorBlock;


@end
