//
//  VWWViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWViewController.h"
#import "VWWImgurController.h"
#import "VWWImageCollectionViewCell.h"
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
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.hasAppeared == NO){
        self.hasAppeared = YES;
        [self authenticateAndGetAccount];
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
-(void)authenticateAndGetAccount{
    [[VWWImgurController sharedInstance] authorizeWithViewController:self completionBlock:^(BOOL success) {
        if(success){
            VWW_LOG_DEBUG(@"Logged in successfully. Account info is in user defaults");
            [self requestImages];
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

- (IBAction)buttonTouchUpInside:(id)sender {

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
