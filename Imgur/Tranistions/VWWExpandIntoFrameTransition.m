//
//  VWWExpandIntoFrameTransition.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//
//  This transition is only good for iPhone Portrait.


#import "VWWExpandIntoFrameTransition.h"



@implementation VWWExpandIntoFrameTransition{
    CGRect _fromFrame;
    CGRect _toFrame;
    UIView *_intermediateView;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

  
    // 1. obtain state from the context
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    CGFloat x = 0;
    CGFloat y = (finalFrame.size.height - 320) / 2.0;
    CGFloat w = 320;
    CGFloat h = 320;
    
    finalFrame = CGRectMake(x, y, w, h);

    
    // 2. obtain the container view
    UIView *containerView = [transitionContext containerView];
    
    // 3. set initial state
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    toViewController.view.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    
    
    
    // 4. add the view
    toViewController.view.alpha = 0.0;
    [containerView addSubview:toViewController.view];
    
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // Replace the above code with this which uses snapshots
    // create a snapshot
    [containerView addSubview:_intermediateView];

    
    
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.alpha = 0.0;
        _intermediateView.frame = finalFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            // 6. inform the context of completion
            [fromViewController.view removeFromSuperview];
            [_intermediateView removeFromSuperview];
            [transitionContext completeTransition:YES];
            
        }];
    }];

}


#pragma mark Public methods
-(void)setFromFrame:(CGRect)frame{
    _fromFrame = frame;

}
-(void)setToFrame:(CGRect)frame{
    _toFrame = frame;
}
-(void)setIntermediateView:(UIView*)intermediateView{
    _intermediateView = intermediateView;
}
@end
