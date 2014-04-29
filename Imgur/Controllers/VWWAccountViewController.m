//
//  VWWAccountViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/28/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAccountViewController.h"

@interface VWWAccountViewController ()

@end

@implementation VWWAccountViewController

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Account";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark IBActions

- (IBAction)logOutButtonTouchUpInside:(id)sender {
    [VWWUserDefaults logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
