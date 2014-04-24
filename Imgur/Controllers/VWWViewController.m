//
//  VWWViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWViewController.h"
#import "VWWImgurController.h"

#import "VWWRESTEngine.h"

@interface VWWViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL hasAppeared;
@property (nonatomic, strong) NSArray *images;
@end

@implementation VWWViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.hasAppeared == NO){
        self.hasAppeared = YES;
        [self authenticateAndGetAccountImages];
    }
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

#pragma mark Private
-(void)authenticateAndGetAccountImages{
    [[VWWImgurController sharedInstance] authorizeWithViewController:self completionBlock:^(BOOL success) {
        if(success){
            [[VWWRESTEngine sharedInstance] getAccountImagesWithCompletionBlock:^(NSArray *images) {
                VWW_LOG_DEBUG(@"Retrieved %ld account images", (long)images.count);
                self.images = [images copy];
                [self.collectionView reloadData];
            } errorBlock:^(NSError *error, NSString *description) {
                VWW_LOG_ERROR(@"Failed to retrieve account images");
                VWW_LOG_TRACE;
            }];
        } else {
            VWW_LOG_ERROR(@"Failed to authenticate");
        }
    }];

}

#pragma mark IBActions

- (IBAction)buttonTouchUpInside:(id)sender {

}


#pragma mark UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)cv {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
