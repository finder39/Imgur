//
//  VWWImagesVoteViewController.m
//  Imgur
//
//  Created by Zakk Hoyt on 5/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWImagesVoteViewController.h"
#import "VWWImageVoteCollectionViewCell.h"
#import "VWWRESTEngine.h"
#import "NSTimer+Blocks.h"

@interface VWWImagesVoteViewController () <VWWImageVoteCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL hasLoaded;

@end

@implementation VWWImagesVoteViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

//    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(self.hasLoaded == NO){
        self.hasLoaded = YES;
        
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadData];
        } completion:^(BOOL finished) {
            [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }];
        
    }
    
    [self.view layoutSubviews];
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


#pragma mark UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section {
    return self.galleries.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)cv {
    return 1;
}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"View" forIndexPath:indexPath];
//    
//    if(indexPath.section == 0){
//    } else if(indexPath.section == 1){
//    }
//    
//    return view;
//}
//

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VWWImageVoteCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VWWImageVoteCollectionViewCell" forIndexPath:indexPath];
    cell.gallery = self.galleries[indexPath.item];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}


#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)scrollToGalleryAtIndexPath:(NSIndexPath*)indexPath{
    [NSTimer scheduledTimerWithTimeInterval:2.0 block:^{
        if(indexPath.item < [self.collectionView numberOfItemsInSection:0]){
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1  inSection:0];
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        } else {
            VWW_LOG_TODO_TASK(@"Get next page of galleries");
        }
    } repeats:NO];
}


#pragma mark VWWImageVoteCollectionViewCellDelegate
-(void)VWWImageVoteCollectionViewCellUserSwipedLeft:(VWWImageVoteCollectionViewCell*)sender{

    VWWGallery *gallery = sender.gallery;
    NSString *identifier = gallery.identifier;
    if([gallery.vote isEqualToString:@""] ||
       gallery.vote == nil){
        gallery.ups++;
    } else if([gallery.vote isEqualToString:@"down"]){
        gallery.ups++;
        gallery.downs--;
    } else if([gallery.vote isEqualToString:@"up"]){
        return;
    }
    gallery.vote = @"up";
    
    sender.gallery = gallery;
    

    [self scrollToGalleryAtIndexPath:sender.indexPath];
    [[VWWRESTEngine sharedInstance] postGalleryVoteWithId:identifier direction:@"up" completionBlock:^(BOOL success) {
        VWW_LOG_INFO(@"Success voted up")
    } errorBlock:^(NSError *error, NSString *description) {
        VWW_LOG_ERROR(@"Failed to upvote the image with id : %@", gallery.identifier);
    }];
    
    
    
}
-(void)VWWImageVoteCollectionViewCellUserSwipedRight:(VWWImageVoteCollectionViewCell*)sender{
    VWWGallery *gallery = sender.gallery;
    NSString *identifier = gallery.identifier;
    if([gallery.vote isEqualToString:@""] ||
       gallery.vote == nil){
        gallery.downs++;
    } else if([gallery.vote isEqualToString:@"up"]){
        gallery.ups--;
        gallery.downs++;
    } else if([gallery.vote isEqualToString:@"down"]){
        return;
    }

    gallery.vote = @"down";
    sender.gallery = gallery;
    
    [self scrollToGalleryAtIndexPath:sender.indexPath];
    
    [[VWWRESTEngine sharedInstance] postGalleryVoteWithId:identifier direction:@"down" completionBlock:^(BOOL success) {
        VWW_LOG_INFO(@"Success voted down")
    } errorBlock:^(NSError *error, NSString *description) {
        VWW_LOG_ERROR(@"Failed to downvote the image with id : %@", gallery.identifier);
    }];

}
-(void)VWWImageVoteCollectionViewCellDoubleTapped:(VWWImageVoteCollectionViewCell*)sender{
    
    VWWGallery *gallery = sender.gallery;
    NSString *identifier = gallery.identifier;
    gallery.favorite = !gallery.favorite;
    sender.gallery = gallery;
    
    [self scrollToGalleryAtIndexPath:sender.indexPath];
    
    [[VWWRESTEngine sharedInstance] postFavoriteWithId:identifier completionBlock:^(BOOL success) {
        VWW_LOG_INFO(@"Success favoriting image");
    } errorBlock:^(NSError *error, NSString *description) {
        VWW_LOG_ERROR(@"Failed to favorite/unfavorite the image with id : %@", gallery.identifier);
    }];
}



@end
