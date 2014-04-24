//
//  VWWCodeForm.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWCodeForm.h"

@implementation VWWCodeForm
-(NSDictionary*)httpParametersDictionary{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if(self.code) dictionary[@"code"] = self.code;
    if(self.clientID) dictionary[@"client_id"] = self.clientID;
    if(self.clientSecret) dictionary[@"client_secret"] = self.clientSecret;
    if(self.grantType) dictionary[@"grant_type"] = self.grantType;
    return dictionary;

}
-(NSString*)JSONString{
    return @"";
}

@end
