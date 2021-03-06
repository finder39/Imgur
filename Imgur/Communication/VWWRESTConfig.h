//
//  VWWRESTConfig.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWRESTConfig : NSObject
+(VWWRESTConfig*)sharedInstance;
-(NSString*)serviceURLString;
@property (nonatomic) BOOL serviceSecure;
@property (nonatomic, strong) NSString *server;
//@property (nonatomic, strong) NSString *serviceDomain;
@property (nonatomic, strong) NSString *serviceAuthorize;
@property (nonatomic, strong) NSString *serviceQuery;
@property (nonatomic, strong) NSString *serviceEndpoint;

@property (nonatomic, strong) NSString *accountURI;
@property (nonatomic, strong) NSString *accountMeURI;
@property (nonatomic, strong) NSString *authorizeURI;
@property (nonatomic, strong) NSString *albumURI;
@property (nonatomic, strong) NSString *albumsURI;
@property (nonatomic, strong) NSString *imagesURI;
@property (nonatomic, strong) NSString *tokenURI;
@end
