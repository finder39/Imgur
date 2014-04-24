//
//  VWWHTTPForm.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol VWWHTTPFormProtocol <NSObject>
-(NSDictionary *)httpParametersDictionary;
-(NSString *)JSONString;
@end

@interface VWWHTTPForm : NSObject <VWWHTTPFormProtocol>
-(NSDictionary*)httpParametersDictionary;
-(NSString*)JSONString;
@end
