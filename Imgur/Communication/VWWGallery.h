//
//  VWWGallery.h
//  Imgur
//
//  Created by Zakk Hoyt on 5/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWGallery : NSObject
-(id)initWithDictionary:(NSDictionary*)dictionary;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) BOOL animated;
@property (nonatomic) BOOL favorite;
@property (nonatomic) NSUInteger width;
@property (nonatomic) NSUInteger height;
@property (nonatomic) NSUInteger size;
@property (nonatomic) NSUInteger views;
@property (nonatomic) NSUInteger bandwidth;
@property (nonatomic, strong) NSString *deleteHash;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSString *vote;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSURL *accountURL;
@property (nonatomic) NSUInteger ups;
@property (nonatomic) NSUInteger downs;
@property (nonatomic) NSUInteger score;
@property (nonatomic) BOOL isAlbum;
@property (nonatomic, strong) NSString *cover;

-(NSURL*)squareThumbnailURIForSize:(CGSize)size;
-(NSURL*)proportionalThumbnailURIForSize:(CGSize)size;

@end
