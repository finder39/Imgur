//
//  VWWToken.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWToken.h"

static NSString *VWWTokenAccessTokenKey = @"access_token";
static NSString *VWWTokenAccountUsernameKey = @"account_username";
static NSString *VWWTokenExpiresInKey = @"expires_in";
static NSString *VWWTokenRefreshTokenKey = @"refresh_token";
static NSString *VWWTokenScopeKey = @"scope";
static NSString *VWWTokenTokenTypeKey = @"token_type";


@implementation VWWToken

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary*)dictionary{
    self = [self init];
    if(self){
        self.accessToken = dictionary[VWWTokenAccessTokenKey];
        self.accountUsername = dictionary[VWWTokenAccountUsernameKey];
        NSNumber *expiresInNumber = dictionary[VWWTokenExpiresInKey];
        if(expiresInNumber){
            self.expiresIn = expiresInNumber.integerValue;
        }
        self.refreshToken = dictionary[VWWTokenRefreshTokenKey];
        self.scope = dictionary[VWWTokenScopeKey];
        self.tokenType = dictionary[VWWTokenTokenTypeKey];
    }
    return self;
}

@end
