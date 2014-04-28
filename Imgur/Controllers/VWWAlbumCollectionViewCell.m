//
//  VWWAlbumCollectionViewCell.m
//  Imgur
//
//  Created by Zakk Hoyt on 4/28/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAlbumCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "VWWAlbum.h"

@interface VWWAlbumCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end

@implementation VWWAlbumCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark Public methods
-(void)setAlbum:(VWWAlbum *)album{
    _album = album;
#if defined(DEBUG)
    self.backgroundColor = [UIColor randomColor];
#endif

    if(self.album.title){
        self.titleLabel.text = self.album.title;
    } else {
        self.titleLabel.text = @"";
    }
    
    NSURL *url = self.album.link;
    [self.imageView setImageWithURL:url];
}

@end
