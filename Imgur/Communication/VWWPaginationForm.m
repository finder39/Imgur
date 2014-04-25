//
//  VWWPaginationForm.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWPaginationForm.h"

static NSString *VWWPaginationFormPageKey = @"page";

@implementation VWWPaginationForm
-(id)init{
    self = [super init];
    if(self){
        _page = @(0);
    }
    return self;
}
- (NSDictionary *)httpParametersDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[VWWPaginationFormPageKey] = self.page;
    return dictionary;
}

@end
