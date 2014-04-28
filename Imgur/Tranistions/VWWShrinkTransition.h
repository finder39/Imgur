//
//  VWWShrinkTransition.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface VWWShrinkTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) CGPoint vanishingPoint;
@end
