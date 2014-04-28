//
//  VWWUserDefaults.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/25/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWUserDefaults : NSObject

@end

@interface VWWUserDefaults (Account)

+(void)setUsername:(NSString*)userName;
+(NSString*)userName;

+(void)setAccount:(NSDictionary*)account;
+(NSDictionary*)account;

+(void)setToken:(NSString*)token;
+(NSString*)token;

+(void)setCode:(NSString*)code;
+(NSString*)code;

+(void)logOut;
@end
