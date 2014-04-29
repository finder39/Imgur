//
//  VWWAssetFullscreenRootViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAssetFullscreenRootViewController.h"
#import "VWWAssetFullscreenDataViewController.h"
#import "VWWShrinkTransition.h"

@interface VWWAssetFullscreenRootViewController () <UIPageViewControllerDataSource, VWWAssetFullscreenDataViewControllerDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) VWWShrinkTransition *shrinkDismissAnimationController;
@end

@implementation VWWAssetFullscreenRootViewController

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shrinkDismissAnimationController = [[VWWShrinkTransition alloc]init];
    self.transitioningDelegate = self;

    VWWAssetFullscreenDataViewController *startingViewController = [self viewControllerAtIndex:self.index storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    self.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma   mark UIPageViewControllerDelegate

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers NS_AVAILABLE_IOS(6_0){
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
}


-(UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    UIViewController *currentViewController = self.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    self.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:(VWWAssetFullscreenDataViewController*)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    VWW_LOG_TRACE;
    NSUInteger index = [self indexOfViewController:(VWWAssetFullscreenDataViewController*)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.images count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (VWWAssetFullscreenDataViewController*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard{
    if ((self.images.count == 0) || (index >= self.images.count)) {
        return nil;
    }
    
    VWW_LOG_INFO(@"%s index: %ld", __func__, (long)index);
    
    VWWAssetFullscreenDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"VWWAssetFullscreenDataViewController"];
    dataViewController.image = self.images[index];
    dataViewController.delegate = self;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(VWWAssetFullscreenDataViewController*)viewController{
    VWW_LOG_TRACE;
    return [self.images indexOfObject:viewController.image];
}


#pragma mark RDAssetFullscreenDataViewControllerDelegate
-(void)assetFullscreenDataViewControllerDismissViewController:(VWWAssetFullscreenDataViewController*)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _shrinkDismissAnimationController;
}

@end
