//
//  VWWGallery.m
//  Imgur
//
//  Created by Zakk Hoyt on 5/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWGallery.h"

@implementation VWWGallery



-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary*)dictionary{
    self = [self init];
    if(self){
        
        self.identifier = [VWWUtility stringForKey:@"id" fromDictionary:dictionary];
        self.title = [VWWUtility stringForKey:@"title" fromDictionary:dictionary];
        self.description = [VWWUtility stringForKey:@"description" fromDictionary:dictionary];
        self.type = [VWWUtility stringForKey:@"type" fromDictionary:dictionary];
        self.animated = [VWWUtility boolForKey:@"animated" fromDictionary:dictionary];
        self.width = [VWWUtility integerForKey:@"width" fromDictionary:dictionary];
        self.height = [VWWUtility integerForKey:@"height" fromDictionary:dictionary];
        self.size = [VWWUtility integerForKey:@"size" fromDictionary:dictionary];
        self.views = [VWWUtility integerForKey:@"views" fromDictionary:dictionary];
        self.bandwidth = [VWWUtility integerForKey:@"bandwidth" fromDictionary:dictionary];
        self.deleteHash = [VWWUtility stringForKey:@"deleteHash" fromDictionary:dictionary];
        self.link = [VWWUtility urlForKey:@"link" fromDictionary:dictionary];
        self.vote = [VWWUtility stringForKey:@"vote" fromDictionary:dictionary];
        self.section = [VWWUtility stringForKey:@"section" fromDictionary:dictionary];
        self.accountURL = [VWWUtility urlForKey:@"account_url" fromDictionary:dictionary];
        self.ups = [VWWUtility integerForKey:@"ups" fromDictionary:dictionary];
        self.downs = [VWWUtility integerForKey:@"downs" fromDictionary:dictionary];
        self.score = [VWWUtility integerForKey:@"score" fromDictionary:dictionary];
        self.isAlbum = [VWWUtility boolForKey:@"is_album" fromDictionary:dictionary];
        self.favorite = [VWWUtility boolForKey:@"favorite" fromDictionary:dictionary];
        self.cover = [VWWUtility stringForKey:@"cover" fromDictionary:dictionary];
        VWW_LOG_TODO;
    }
    return self;
}


-(NSURL*)squareThumbnailURIForSize:(CGSize)size{
    if(size.width <= 90){
        // s
        return [self appendLetterToLink:@"s"];
    } else if(size.width < 160) {
        // b
        return [self appendLetterToLink:@"b"];
    }
    return self.link;
}


-(NSURL*)proportionalThumbnailURIForSize:(CGSize)size{
    // TODO: we could pay attention to height here as well but this is a good start
    if(size.width <= 160){
        // t
        return [self appendLetterToLink:@"t"];
    } else if(size.width < 320){
        // m
        return [self appendLetterToLink:@"m"];
    } else if(size.width < 640){
        // l
        return [self appendLetterToLink:@"l"];
    } else if(size.width < 1024){
        // h
        return [self appendLetterToLink:@"h"];
    }
    return self.link;
}

#pragma mark Private methods
-(NSURL*)appendLetterToLink:(NSString*)letter{
    NSString *urlString = self.link.absoluteString;
    
    NSString *lastPathCompontent = [urlString lastPathComponent];
    NSString *lastPathCompontentLetter = [lastPathCompontent stringByReplacingOccurrencesOfString:@"." withString:[NSString stringWithFormat:@"%@.", letter]];
    
    
    NSString *urlLetterString = [urlString stringByReplacingOccurrencesOfString:lastPathCompontent withString:lastPathCompontentLetter];
    NSURL *urlLetter = [NSURL URLWithString:urlLetterString];
    return urlLetter;
}
@end
