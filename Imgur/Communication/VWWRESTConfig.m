//
//  VWWRESTConfig.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWRESTConfig.h"

@implementation VWWRESTConfig
+(VWWRESTConfig*)sharedInstance{
    static VWWRESTConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VWWRESTConfig alloc]init];
    });
    return instance;
}

-(id)init{
    self = [super init];
    if(self){

        
        _server =  @"api.imgur.com";
        _serviceSecure = YES;

        _serviceEndpoint = [NSString stringWithFormat:@"%@", _server];
        _serviceAuthorize = @"oauth2";
        _serviceQuery = @"3";
        
        _accountURI = @"account";
        _accountMeURI = @"account/me";
        _authorizeURI = @"authorize";
        _imagesURI = @"images";
        _tokenURI = @"token";
    }
    return self;
}

-(void)configureAuthorizeMode{
    _server =  @"api.imgur.com";
}

-(void)configureQueryMods{
    _serviceEndpoint = [NSString stringWithFormat:@"%@/oauth2", _server];
}

-(NSString*)serviceURLString{
    return [NSString stringWithFormat:@"%@%@",
            _serviceSecure ? @"https://" : @"http://",
            _serviceEndpoint];
    
}

@end
