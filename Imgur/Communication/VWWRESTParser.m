//
//  VWWRESTParser.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWRESTParser.h"

// Models
#import "VWWAlbum.h"
#import "VWWImage.h"
#import "VWWToken.h"

@implementation VWWRESTParser

#pragma mark (Albums)
+(void)parseAlbums:(id)json completionBlock:(VWWArrayBlock)completionBlock{
    if(json == nil) return completionBlock(nil);
    
    NSArray *albumDictionaries = json[@"data"];
    if(albumDictionaries == nil) return completionBlock(nil);
    
    NSMutableArray *mAlbums = [[NSMutableArray alloc]initWithCapacity:albumDictionaries.count];
    for(NSDictionary *albumDictionary in albumDictionaries){
        VWWAlbum *album = [[VWWAlbum alloc]initWithDictionary:albumDictionary];
        [mAlbums addObject:album];
    }
    completionBlock([NSArray arrayWithArray:mAlbums]);
}



#pragma mark (Images)
+(void)parseImages:(id)json completionBlock:(VWWArrayBlock)completionBlock{
    if(json == nil) return completionBlock(nil);
    
    NSArray *imageDictionaries = json[@"data"];
    if(imageDictionaries == nil) return completionBlock(nil);
    
    NSMutableArray *mImages = [[NSMutableArray alloc]initWithCapacity:imageDictionaries.count];
    for(NSDictionary *imageDictionary in imageDictionaries){
        VWWImage *image = [[VWWImage alloc]initWithDictionary:imageDictionary];
        [mImages addObject:image];
    }
    
    completionBlock([NSArray arrayWithArray:mImages]);
}

#pragma mark (Tokens)
+(void)parseTokens:(id)json completionBlock:(VWWTokenBlock)completionBlock{
    if(json == nil) return completionBlock(nil);
    VWWToken *token = [[VWWToken alloc]initWithDictionary:json];
    completionBlock(token);
}

@end
