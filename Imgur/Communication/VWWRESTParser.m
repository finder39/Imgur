//
//  VWWRESTParser.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWRESTParser.h"
#import "VWWToken.h"

@implementation VWWRESTParser

#pragma mark (Tokens)



+(void)parseTokens:(id)json completionBlock:(VWWTokenBlock)completionBlock{
    if(json == nil) return completionBlock(nil);
    VWWToken *token = [[VWWToken alloc]initWithDictionary:json];
    completionBlock(token);
}

@end
