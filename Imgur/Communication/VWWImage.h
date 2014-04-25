//
//  VWWImage.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/25/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VWWImage : NSObject
-(id)initWithDictionary:(NSDictionary*)dictionary;
@property (nonatomic) BOOL animated;
@property (nonatomic) NSUInteger bandwidth;
@property (nonatomic) NSUInteger datetime; // epoch time
@property (nonatomic, strong) NSString *deleteHash;
@property (nonatomic, strong) NSString *imageDescription;
@property (nonatomic) BOOL favorite;
@property (nonatomic) NSUInteger height;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic) BOOL nsfw;
@property (nonatomic, strong) NSString *section;
@property (nonatomic) NSUInteger size;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) NSUInteger views;
@property (nonatomic) NSUInteger width;

-(NSURL*)squareThumbnailURIForSize:(CGSize)size;
-(NSURL*)proportionalThumbnailURIForSize:(CGSize)size;
@end
