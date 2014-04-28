//
//  VWWExpandIntoFrameTransition.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface VWWExpandIntoFrameTransition : NSObject <UIViewControllerAnimatedTransitioning>
-(void)setFromFrame:(CGRect)frame;
//-(void)setToFrame:(CGRect)frame;
-(void)setIntermediateView:(UIView*)intermediateView;
@end
