//
//  VWWImage.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/25/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWImage.h"


@implementation VWWImage
-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary*)dictionary{
    self = [self init];
    if(self){
        self.animated = [VWWUtility boolForKey:@"animated" fromDictionary:dictionary];
        self.bandwidth = [VWWUtility integerForKey:@"bandwidth" fromDictionary:dictionary];
        // TODO: Convert this to a meaningful date
        self.datetime = [VWWUtility integerForKey:@"datetime" fromDictionary:dictionary];
        self.deleteHash = [VWWUtility stringForKey:@"deleteHash" fromDictionary:dictionary];
        self.imageDescription = [VWWUtility stringForKey:@"description" fromDictionary:dictionary];
        self.favorite = [VWWUtility integerForKey:@"favorite" fromDictionary:dictionary];
        self.height = [VWWUtility integerForKey:@"height" fromDictionary:dictionary];
        self.identifier = [VWWUtility stringForKey:@"id" fromDictionary:dictionary];
        self.link = [VWWUtility urlForKey:@"link" fromDictionary:dictionary];
        self.nsfw = [VWWUtility boolForKey:@"nsfw" fromDictionary:dictionary];
        self.section = [VWWUtility stringForKey:@"section" fromDictionary:dictionary];
        self.size = [VWWUtility integerForKey:@"size" fromDictionary:dictionary];
        self.title = [VWWUtility stringForKey:@"title" fromDictionary:dictionary];
        self.type = [VWWUtility stringForKey:@"type" fromDictionary:dictionary];
        self.views = [VWWUtility integerForKey:@"views" fromDictionary:dictionary];
        self.width = [VWWUtility integerForKey:@"width" fromDictionary:dictionary];
    }
    return self;
}

// From documetation at: https://api.imgur.com/models/image
//    Thumbnail Suffix 	Thumbnail Name 	Thumbnail Size 	Keeps Image Proportions
//    s 	Small Square 	90x90 	No
//    b 	Big Square 	160x160 	No
//    t 	Small Thumbnail 	160x160 	Yes
//    m 	Medium Thumbnail 	320x320 	Yes
//    l 	Large Thumbnail 	640x640 	Yes
//    h 	Huge Thumbnail 	1024x1024 	Yes

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
