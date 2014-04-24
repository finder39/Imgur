//
//  VWWMasterViewController.h
//  Imgur
//
//  Created by Zakk Hoyt on 4/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VWWDetailViewController;

@interface VWWMasterViewController : UITableViewController

@property (strong, nonatomic) VWWDetailViewController *detailViewController;

@end
