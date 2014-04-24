//
//  VWWDetailViewController.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VWWDetailViewController : UIViewController <UISplitViewControllerDelegate>
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
