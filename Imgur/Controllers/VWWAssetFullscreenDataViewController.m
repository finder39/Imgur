//
//  VWWAssetFullscreenDataViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAssetFullscreenDataViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "NSTimer+Blocks.h"
#import "MBProgressHUD.h"
#import "VWWImage.h"

@interface VWWAssetFullscreenDataViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *assetImageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation VWWAssetFullscreenDataViewController

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupScrollViewAndImageView];
}

#pragma mark Private methods

-(void)addGestureRecognizers{
    // Gesture recognizer
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureHandler:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureHandler:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.scrollView addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *twoFingerSingleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerSingleTapGestureHandler:)];
    twoFingerSingleTapGestureRecognizer.numberOfTapsRequired = 1;
    twoFingerSingleTapGestureRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerSingleTapGestureRecognizer];
    
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
}

-(void)singleTapGestureHandler:(UIGestureRecognizer*)gestureRecognizer{
    [self.delegate assetFullscreenDataViewControllerDismissViewController:self];
}

-(void)doubleTapGestureHandler:(UIGestureRecognizer*)gestureRecognizer{
    // Zoom in on point that was double tapped
    CGPoint pointInView = [gestureRecognizer locationInView:self.assetImageView];
    CGSize scrollViewSize = self.scrollView.bounds.size;
    CGFloat w = scrollViewSize.width / self.scrollView.maximumZoomScale;
    CGFloat h = scrollViewSize.height / self.scrollView.maximumZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}


-(void)twoFingerSingleTapGestureHandler:(UIGestureRecognizer*)gestureRecognizer{
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
}

-(void)setupScrollViewAndImageView{
    NSURL *thumbnailURL = self.image.link;
    if(thumbnailURL){
        // scrollview
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.scrollView];
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        
        // imageview
        __weak VWWAssetFullscreenDataViewController *weakSelf = self;
        self.assetImageView = [[UIImageView alloc]init];
        [self.assetImageView setImageWithURL:thumbnailURL placeholderImage:[UIImage imageNamed:@"radius_256"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            CGRect imageViewFrame = CGRectMake(0, 0,
                                               image.size.width,
                                               image.size.height);
            weakSelf.assetImageView.frame = imageViewFrame;
            [weakSelf.scrollView addSubview:weakSelf.assetImageView];
            
            // zoom stuff
            weakSelf.scrollView.contentSize = weakSelf.assetImageView.frame.size;
            CGRect scrollViewFrame = weakSelf.scrollView.frame;
            // calculate zoom scales based on width or height
            CGFloat scaleWidth = scrollViewFrame.size.width / weakSelf.scrollView.contentSize.width;
            CGFloat scaleHeight = scrollViewFrame.size.height / weakSelf.scrollView.contentSize.height;
            CGFloat minScale = MIN(scaleWidth, scaleHeight);
            weakSelf.scrollView.minimumZoomScale = minScale;
            weakSelf.scrollView.maximumZoomScale = 1.0f;
            weakSelf.scrollView.zoomScale = MIN(scaleWidth, scaleHeight);
            
            [weakSelf addGestureRecognizers];
        }];
    } else {
        [self.assetImageView setImage:[UIImage imageNamed:@"radius_256"]];
    }
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}

//-(void)shareAsset{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"Caching image";
//    
//    void (^shareImage)(UIImage *image) = ^(UIImage *image){
//        NSMutableArray *items = [@[image]mutableCopy];
//        NSMutableArray *activities = [@[]mutableCopy];
//        UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:items
//                                                                                            applicationActivities:activities];
//        
//        activityViewController.completionHandler = ^(NSString *activityType, BOOL completed){
//            if(completed){
//                [self dismissViewControllerAnimated:YES completion:^{
//                }];
//            }
//        };
//        
//        [self presentViewController:activityViewController animated:YES completion:nil];
//    };
//    
//    [[SDWebImageManager sharedManager] downloadWithURL:self.image.link
//                                               options:SDWebImageRetryFailed
//                                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//                                              } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
//                                                  if(image && finished){
//                                                      shareImage(image);
//                                                  }
//                                                  else if(error){
//                                                      // TODO handle error;
//                                                  }
//                                              }];
//}



#pragma mark UIScrollViewDelegate
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.assetImageView.frame = [self centeredFrameForScrollView:self.scrollView andUIView:self.assetImageView];
}
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    self.assetImageView.frame = [self centeredFrameForScrollView:self.scrollView andUIView:self.assetImageView];
    return self.assetImageView;
}
@end
