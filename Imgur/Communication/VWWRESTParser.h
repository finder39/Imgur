//
//  VWWRESTParser.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWRESTParser : NSObject

#pragma mark (Albums)
+(void)parseAlbums:(id)json completionBlock:(VWWArrayBlock)completionBlock;

#pragma mark (Galleries)
+(void)parseGalleries:(id)json completionBlock:(VWWArrayBlock)completionBlock;



#pragma mark (Images)
+(void)parseImages:(id)json completionBlock:(VWWArrayBlock)completionBlock;

#pragma mark (Tokens)
+(void)parseTokens:(id)json completionBlock:(VWWTokenBlock)completionBlock;



@end
