//
//  VWWImageVoteCollectionViewCell.m
//  Imgur
//
//  Created by Zakk Hoyt on 5/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWImageVoteCollectionViewCell.h"
#import "UIImageView+WebCache.h"
//#import "VWWImage.h"
#import "VWWGallery.h"
@interface VWWImageVoteCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRight;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@property (weak, nonatomic) IBOutlet UILabel *upsLabel;
@property (weak, nonatomic) IBOutlet UILabel *downsLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;
@property (weak, nonatomic) IBOutlet UILabel *favLabel;


@end

@implementation VWWImageVoteCollectionViewCell

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

//-(void)setImage:(VWWImage *)image{
-(void)setGallery:(VWWGallery *)gallery{
//    _image = image;
    _gallery = gallery;
    
    self.backgroundColor = [UIColor randomColor];
    
    
    self.upsLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gallery.ups];
    self.downsLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gallery.downs];
    self.voteLabel.text = self.gallery.vote;
    self.favLabel.text = self.gallery.favorite ? @"YES" : @"NO";
    if(self.gallery.cover){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://i.imgur.com/%@.jpg", self.gallery.cover]];
        [self.imageView setImageWithURL:url];
    } else {
        [self.imageView setImageWithURL:self.gallery.link];
    }
    
    
    if(self.swipeLeft == nil){
        self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeftHandler:)];
        self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:self.swipeLeft];
    }
    
    if(self.swipeRight == nil){
        self.swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRightHandler:)];
        self.swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:self.swipeRight];
    }

    if(self.doubleTap == nil){
        self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapHandler:)];
        self.doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:self.doubleTap];
    }

}


-(void)swipeLeftHandler:(UISwipeGestureRecognizer*)sender{
    [self.delegate VWWImageVoteCollectionViewCellUserSwipedLeft:self];
}

-(void)swipeRightHandler:(UISwipeGestureRecognizer*)sender{
    [self.delegate VWWImageVoteCollectionViewCellUserSwipedRight:self];
}

-(void)doubleTapHandler:(UISwipeGestureRecognizer*)sender{
    [self.delegate VWWImageVoteCollectionViewCellDoubleTapped:self];
}

@end
