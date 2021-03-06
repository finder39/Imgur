//
//  VWWShrinkTransition.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//


#import "VWWShrinkTransition.h"

@implementation VWWShrinkTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    UIView *containerView = [transitionContext containerView];
    
    // 1
    toViewController.view.frame = finalFrame;
    toViewController.view.alpha = 0.5;
    
    
    // 2
    [containerView addSubview:toViewController.view];
    [containerView sendSubviewToBack:toViewController.view];
    
    // 1. Determine the intermediate and final frame for the from view
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect shrunkenFrame = CGRectInset(fromViewController.view.frame,
                                       fromViewController.view.frame.size.width/4.0,
                                       fromViewController.view.frame.size.height/4.0);
    CGRect fromFinalFrame = CGRectOffset(shrunkenFrame, 0, screenBounds.size.height);
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    

    
    // Replace the above code with this which uses snapshots
    // create a snapshot
    UIView *intermediateView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    intermediateView.frame = fromViewController.view.frame;
    [containerView addSubview:intermediateView];
    
    // remove the real view
    [fromViewController.view removeFromSuperview];
    
    [UIView animateKeyframesWithDuration:duration delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
                                     [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0
                                                                   animations:^{
                                                                       intermediateView.frame = shrunkenFrame;
                                                                       toViewController.view.alpha = 0.5;
                                                                   }];
                                     [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:1.0
                                                                   animations:^{
                                                                       intermediateView.frame = fromFinalFrame;
                                                                       toViewController.view.alpha = 1.0;
                                                                   }];
                                 }
                              completion:^(BOOL finished) {
                                  // remove the intermediate view
                                  [intermediateView removeFromSuperview];
                                  [transitionContext completeTransition:YES];
                              }];
    
}


@end
