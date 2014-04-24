//
//  VWWImgurController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWImgurController.h"
#import "VWWImgurControllerConfig.h"

static VWWImgurController *instance;

@implementation VWWImgurController
+(VWWImgurController*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VWWImgurController alloc]init];
    });
//    if(instance == nil){
//        instance = [[VWWImgurController alloc]init];
//    }
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void)authoize{
//    https://api.imgur.com/oauth2/authorize?client_id=YOUR_CLIENT_ID&response_type=REQUESTED_RESPONSE_TYPE&state=APPLICATION_STATE
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.imgur.com/oauth2/authorize?client_id=%@"
                           @"&response_type=%@"
                           @"&state=%@",
                           VWWImgurControllerConfigClientID,
                           @"token",
                           @"auth"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url: %@", url);
    
    NSLog(@"");
}


@end
