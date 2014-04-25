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
static NSString *VWWUserDefaultsUsername = @"username";


@implementation VWWUserDefaults

@end

@implementation VWWUserDefaults (Account)

+(void)setUsername:(NSString*)userName{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:VWWUserDefaultsUsername];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)userName{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsUsername];
    return userName;
}

+(void)setAccount:(NSDictionary*)account{
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:VWWUserDefaultsAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDictionary*)account{
    NSDictionary *account = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsAccountKey];
    return account;
}

+(void)setToken:(NSString*)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:VWWUserDefaultsTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)token{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsTokenKey];
    return token;
}

@end
