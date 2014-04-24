//
//  VWWImgurController.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWImgurController : NSObject
+(VWWImgurController*)sharedInstance;
-(void)authorizeWithViewController:(UIViewController*)viewController completionBlock:(VWWBoolBlock)completionBlock;
@end
