//
//  VWWAlbum.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/28/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAlbum.h"

@implementation VWWAlbum

-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary*)dictionary{
    self = [self init];
    if(self){

        self.accountURL = [VWWUtility stringForKey:@"account_url" fromDictionary:dictionary];
        self.cover = [VWWUtility stringForKey:@"cover" fromDictionary:dictionary];
        self.coverHeight = [VWWUtility integerForKey:@"cover_height" fromDictionary:dictionary];
        self.coverWidth = [VWWUtility integerForKey:@"cover_width" fromDictionary:dictionary];
        NSUInteger dateTime = [VWWUtility integerForKey:@"datetime" fromDictionary:dictionary];
        self.dateTime = [NSDate dateWithTimeIntervalSince1970:dateTime];
        self.deleteHash = [VWWUtility stringForKey:@"deletehash" fromDictionary:dictionary];
        self.albumDescription = [VWWUtility stringForKey:@"album_description" fromDictionary:dictionary];
        self.favorite = [VWWUtility boolForKey:@"favorite" fromDictionary:dictionary];
        self.identifier = [VWWUtility stringForKey:@"id" fromDictionary:dictionary];
        self.layout = [VWWUtility stringForKey:@"layout" fromDictionary:dictionary];
        self.link = [VWWUtility urlForKey:@"link" fromDictionary:dictionary];
        self.order = [VWWUtility integerForKey:@"order" fromDictionary:dictionary];
        self.privacy = [VWWUtility stringForKey:@"privacy" fromDictionary:dictionary];
        self.section = [VWWUtility stringForKey:@"section" fromDictionary:dictionary];
        self.title = [VWWUtility stringForKey:@"title" fromDictionary:dictionary];
        self.views = [VWWUtility integerForKey:@"views" fromDictionary:dictionary];
    }
    return self;
}





@end
