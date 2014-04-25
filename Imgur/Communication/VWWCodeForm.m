//
//  VWWCodeForm.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWCodeForm.h"

static NSString *VWWCodeFormCodeKey = @"code";
static NSString *VWWCodeFormClientIDKey = @"client_id";
static NSString *VWWCodeFormClientSecretKey = @"client_secret";
static NSString *VWWCodeFormGrantTypeKey = @"grant_type";

@implementation VWWCodeForm

-(NSDictionary*)httpParametersDictionary{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if(self.code) dictionary[VWWCodeFormCodeKey] = self.code;
    if(self.clientID) dictionary[VWWCodeFormClientIDKey] = self.clientID;
    if(self.clientSecret) dictionary[VWWCodeFormClientSecretKey] = self.clientSecret;
    if(self.grantType) dictionary[VWWCodeFormGrantTypeKey] = self.grantType;
    return dictionary;
}

-(NSString*)JSONString{
    return @"";
}

@end
