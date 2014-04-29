//
//  VWWAssetFullscreenDataViewController.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//
#import <UIKit/UIKit.h>
@class VWWImage;
@class VWWAssetFullscreenDataViewController;

@protocol VWWAssetFullscreenDataViewControllerDelegate <NSObject>
-(void)assetFullscreenDataViewControllerDismissViewController:(VWWAssetFullscreenDataViewController*)sender;
@end

@interface VWWAssetFullscreenDataViewController : UIViewController
@property (nonatomic, weak) id <VWWAssetFullscreenDataViewControllerDelegate> delegate;
@property (nonatomic, strong) VWWImage *image;
@end
