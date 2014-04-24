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
        [self readUserDefaults];
        [self formatServer];
        

        _serviceDomain = _server;
        _serviceEndpoint = [NSString stringWithFormat:@"%@/oauth2", _server];
        
        _authorizeURI = @"authorize";
        _tokenURI = @"token";
    }
    return self;
}

-(void)readUserDefaults{
    _server =  @"api.imgur.com";
    _serviceSecure = NO;
}

-(void)formatServer{
    _server = [_server stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    _server = [_server stringByReplacingOccurrencesOfString:@"HTTP://" withString:@""];
    _server = [_server stringByReplacingOccurrencesOfString:@"ftp://" withString:@""];
    _server = [_server stringByReplacingOccurrencesOfString:@"FTP://" withString:@""];
}

-(void)refreshServerFromUserDefaults{
    [self readUserDefaults];
}
-(NSString*)serviceURLString{
    return [NSString stringWithFormat:@"%@%@",
            _serviceSecure ? @"https://" : @"http://",
            _serviceEndpoint];
    
}

@end
