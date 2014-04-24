//
//  VWWCodeForm.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWHTTPForm.h"

@interface VWWCodeForm : VWWHTTPForm
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *grantType;
@end
