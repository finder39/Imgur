//
//  VWWToken.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface VWWToken : NSObject
-(id)initWithDictionary:(NSDictionary*)dictionary;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *accountUsername;
@property (nonatomic) NSUInteger expiresIn;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *tokenType;
@end
