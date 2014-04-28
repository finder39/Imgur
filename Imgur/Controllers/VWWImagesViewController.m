//
//  VWWImagesViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/25/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWImagesViewController.h"
#import "VWWImageCollectionViewCell.h"
#import "VWWRESTEngine.h"

@interface VWWImagesViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableOrderedSet *images;
@end

@implementation VWWImagesViewController

#pragma mark UIViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Images";
    self.images = [[NSMutableOrderedSet alloc]init];
    
    // TODO: Add pull to refresh. Clear self.images on pull.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.images.count == 0){
        [self requestImagesForPage:0 completionBlock:^{
            [self.collectionView reloadData];
        }];
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


#pragma mark IBActions


#pragma mark Private methods
-(void)requestImagesForPage:(NSUInteger)page completionBlock:(VWWEmptyBlock)completionBlock{
    
    void (^cleanUp)(void) = ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        completionBlock();
    };
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    VWWPaginationForm *form = [[VWWPaginationForm alloc]init];
    
    [[VWWRESTEngine sharedInstance] getImagesWithForm:form completionBlock:^(NSArray *images) {
        // NSSet doesn't allow duplicates
        [self.images addObjectsFromArray:images];
        VWW_LOG_INFO(@"Retrieved %ld images for a totol of %ld", (long)images.count, (long)self.images.count);
        cleanUp();
    } errorBlock:^(NSError *error, NSString *description) {
        VWW_LOG_ERROR(@"Could not get images");
        cleanUp();
    }];
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
    VWWImage *image = self.images[indexPath.item];
    cell.image = image;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(VWW_IPHONE_IMAGE_SIZE, VWW_IPHONE_IMAGE_SIZE);
}


#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Go to full screen view
}


@end
