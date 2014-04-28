//
//  VWWUserDefaults.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/25/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWUserDefaults.h"

static NSString *VWWUserDefaultsAccountKey = @"account";
static NSString *VWWUserDefaultsTokenKey = @"token";
static NSString *VWWUserDefaultsUsernameKey = @"username";
static NSString *VWWUserDefaultsCodeKey = @"code";

@implementation VWWUserDefaults

@end

@implementation VWWUserDefaults (Account)

// TODO: Obviously we would not store account information unencrypted. Choose and add an encryption
+(void)setUsername:(NSString*)userName{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:VWWUserDefaultsUsernameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)userName{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsUsernameKey];
    return userName;
}

// TODO: Obviously we would not store account information unencrypted. Choose and add an encryption
+(void)setAccount:(NSDictionary*)account{
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:VWWUserDefaultsAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDictionary*)account{
    NSDictionary *account = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsAccountKey];
    return account;
}

// TODO: Obviously we would not store account information unencrypted. Choose and add an encryption
+(void)setToken:(NSString*)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:VWWUserDefaultsTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)token{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsTokenKey];
    return token;
}

// TODO: Obviously we would not store account information unencrypted. Choose and add an encryption
+(void)setCode:(NSString*)code{
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:VWWUserDefaultsCodeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)code{
    NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsCodeKey];
    return code;
}

// Clears all log in keys
+(void)logOut{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VWWUserDefaultsAccountKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VWWUserDefaultsTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VWWUserDefaultsUsernameKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VWWUserDefaultsCodeKey];
}

@end
