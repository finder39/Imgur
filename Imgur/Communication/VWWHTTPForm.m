//
//  VWWHTTPForm.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWHTTPForm.h"





@implementation VWWHTTPForm
-(NSDictionary*)httpParametersDictionary{
    NSString *failString = [NSString stringWithFormat:@"%s:%d Child class must implement", __PRETTY_FUNCTION__, __LINE__];
    NSAssert(NO, failString);
    return nil;
}
-(NSString*)JSONString{
    NSString *failString = [NSString stringWithFormat:@"%s:%d Child class must implement", __PRETTY_FUNCTION__, __LINE__];
    NSAssert(NO, failString);
    return nil;
}

@end
