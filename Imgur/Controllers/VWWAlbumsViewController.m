//
//  VWWAlbumsViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/28/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAlbumsViewController.h"
#import "VWWAlbumCollectionViewCell.h"
#import "VWWRESTEngine.h"

@interface VWWAlbumsViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableOrderedSet *albums;

@end

@implementation VWWAlbumsViewController

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Albums";
    self.albums = [[NSMutableOrderedSet alloc]init];
    
    // TODO: Add pull to refresh. Clear self.albums on pull.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.albums.count == 0){
        [self requestAlbumsForPage:0 completionBlock:^{
            [self.collectionView reloadData];
        }];
    }
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
-(void)requestAlbumsForPage:(NSUInteger)page completionBlock:(VWWEmptyBlock)completionBlock{
    
    void (^cleanUp)(void) = ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        completionBlock();
    };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    VWWPaginationForm *form = [[VWWPaginationForm alloc]init];

    [[VWWRESTEngine sharedInstance] getAlbumsWithForm:form completionBlock:^(NSArray *albums) {
        [self.albums addObjectsFromArray:albums];
        VWW_LOG_INFO(@"Retrieved %ld albums for a total of %ld", (long)albums.count, (long)self.albums.count);
        cleanUp();
    } errorBlock:^(NSError *error, NSString *description) {
        VWW_LOG_ERROR(@"Could not get albums");
        cleanUp();
    }];
}



#pragma mark UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section {
    return self.albums.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)cv {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VWWAlbumCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VWWAlbumCollectionViewCell" forIndexPath:indexPath];
    VWWAlbum *album = self.albums[indexPath.item];
    cell.album = album;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(VWW_IPHONE_ALBUM_SIZE, VWW_IPHONE_ALBUM_SIZE);
}


#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Go to album images view
    
    VWWAlbum *album = self.albums[indexPath.item];
    [[VWWRESTEngine sharedInstance] getAlbumImagesWithUUID:album.identifier completionBlock:^(NSArray *images) {
        VWW_LOG_DEBUG(@"Returned %ld images for album: %@", (long)images.count, album.identifier);
    } errorBlock:^(NSError *error, NSString *description) {
        VWW_LOG_ERROR(@"Could not get images for album: %@", album.identifier);
    }];
}
    

    
    
@end
