//
//  VWWViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWWelcomeViewController.h"
#import "VWWImgurController.h"
#import "VWWImageCollectionViewCell.h"
#import "VWWRESTEngine.h"

static NSString *VWWSegueWelcomeToMaster = @"VWWSegueWelcomeToMaster";

@interface VWWWelcomeViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL hasAppeared;
@property (nonatomic, strong) NSArray *images;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@end

@implementation VWWWelcomeViewController

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.hasAppeared == NO){
        self.hasAppeared = YES;
        
    }
    self.signInButton.hidden = YES;
    
    [[VWWImgurController sharedInstance]verifyStoredAccountWithCompletionBlock:^(BOOL success) {
        if(success){
            [self performSegueWithIdentifier:VWWSegueWelcomeToMaster sender:self];
        } else {
            self.signInButton.hidden = NO;
        }
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private
-(void)authenticateAndGetAccount{
    [[VWWImgurController sharedInstance] authorizeWithViewController:self completionBlock:^(BOOL success) {
        if(success){
            VWW_LOG_DEBUG(@"Logged in successfully. Account info is in user defaults");
            [self performSegueWithIdentifier:VWWSegueWelcomeToMaster sender:self];
//            [self requestImages];
        } else {
            VWW_LOG_ERROR(@"Could not log in");
        }
    }];

}

-(void)requestImages{
    VWWPaginationForm *form = [[VWWPaginationForm alloc]init];
    [[VWWRESTEngine sharedInstance] getImagesWithForm:form completionBlock:^(NSArray *images) {
        self.images = [images copy];
        [self.collectionView reloadData];
        VWW_LOG_DEBUG(@"Retrieved %ld images", (long)images.count);
    } errorBlock:^(NSError *error, NSString *description) {
        VWW_LOG_ERROR(@"Could not retrieve images");
    }];
}

#pragma mark IBActions

- (IBAction)signInButtonTouchUpInside:(id)sender {
    [self authenticateAndGetAccount];
}


#pragma mark UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section {
    return self.images.count;    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)cv {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VWWImageCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VWWImageCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    cell.image = self.images[indexPath.item];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
