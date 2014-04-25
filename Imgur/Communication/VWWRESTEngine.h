//
//  VWWRESTEngine.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//


#import "MKNetworkEngine.h"
#import "VWWRESTConfig.h"
#import "VWWCodeForm.h"
#import "VWWToken.h"

@interface VWWRESTEngine : MKNetworkEngine
+(VWWRESTEngine*)sharedInstance;
@property (nonatomic, strong) VWWRESTConfig* service;
@property (nonatomic, strong) NSString *accessToken;

-(MKNetworkOperation*)getTokensWithForm:(VWWCodeForm*)form
                        completionBlock:(VWWTokenBlock)completionBlock
                             errorBlock:(VWWErrorStringBlock)errorBlock;


-(MKNetworkOperation*)getAccountImagesWithCompletionBlock:(VWWArrayBlock)completionBlock
                                               errorBlock:(VWWErrorStringBlock)errorBlock;



//-(MKNetworkOperation*)getImagesWithForm:(VWWHTTPForm*)form
//                        completionBlock:(VWWArrayBlock)completionBlock
//                             errorBlock:(VWWErrorStringBlock)errorBlock;


@end
