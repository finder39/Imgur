//
//  VWWAlbum.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/28/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWAlbum : NSObject
-(id)initWithDictionary:(NSDictionary*)dictionary;
@property (nonatomic, strong) NSString *accountURL;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic) NSUInteger coverHeight;
@property (nonatomic) NSUInteger coverWidth;
@property (nonatomic, strong) NSDate *dateTime;
@property (nonatomic, strong) NSString *deleteHash;
@property (nonatomic, strong) NSString *albumDescription;
@property (nonatomic) BOOL favorite;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *layout;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic) NSUInteger order;
@property (nonatomic, strong) NSString *privacy;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSUInteger views;

@end
