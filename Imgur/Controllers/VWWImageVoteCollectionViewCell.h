//
//  VWWImageVoteCollectionViewCell.h
//  Imgur
//
//  Created by Zakk Hoyt on 5/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VWWImageVoteCollectionViewCell;
@class VWWGallery;

@protocol VWWImageVoteCollectionViewCellDelegate <NSObject>
-(void)VWWImageVoteCollectionViewCellUserSwipedLeft:(VWWImageVoteCollectionViewCell*)sender;
-(void)VWWImageVoteCollectionViewCellUserSwipedRight:(VWWImageVoteCollectionViewCell*)sender;
-(void)VWWImageVoteCollectionViewCellDoubleTapped:(VWWImageVoteCollectionViewCell*)sender;
@end


@interface VWWImageVoteCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) VWWGallery *gallery;
@property (nonatomic, weak) id <VWWImageVoteCollectionViewCellDelegate> delegate;
@end
