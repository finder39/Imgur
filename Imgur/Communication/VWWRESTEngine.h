//
//  VWWRESTEngine.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "VWWRESTConfig.h"

@interface VWWRESTEngine : MKNetworkEngine
+(VWWRESTEngine*)sharedInstance;
@property (nonatomic, strong) VWWRESTConfig* service;
@end
