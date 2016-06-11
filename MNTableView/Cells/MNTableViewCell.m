//
//  MNTableViewCell.m
//  MNTableView
//
//  Created by Ali, Muhammad on 08/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import "MNTableViewCell.h"
#import "MNTableItem.h"
#import "UIImage+MNImageResize.h"

static const CGFloat kContentsPadding = 20.0f;
static const CGFloat kLabelsPadding = 5.0f;
static const CGFloat kOverlayAlpha = 0.5f;
static const CGFloat kSeparatorHeight = 3.0f;
static const CGFloat kParallaxOffset = 20.0f;

@interface MNTableViewCell ()
@property (nonatomic, strong) UILabel *labelUserName;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIImageView *imageViewPhoto;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIImage *cachedImage;
@property (nonatomic, strong) MNTableItem *dataItem;
@end

@implementation MNTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil){
        
        UIImageView *imageViewPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageViewPhoto.contentMode = UIViewContentModeCenter;
        imageViewPhoto.clipsToBounds = YES;
        _imageViewPhoto = imageViewPhoto;
        [self.contentView addSubview:imageViewPhoto];
        
        UIView *overlayView = [[UIView alloc] initWithFrame:CGRectZero];
        overlayView.backgroundColor = [UIColor blackColor];
        overlayView.alpha = kOverlayAlpha;
        _overlayView = overlayView;
        [self.contentView addSubview:overlayView];
        
        UILabel *labelTitle = [UILabel new];
        labelTitle.numberOfLines = 0;
        labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.isAccessibilityElement = YES;
        labelTitle.textColor = [UIColor whiteColor];
        labelTitle.font = [UIFont systemFontOfSize:14.0f];
        _labelTitle = labelTitle;
        [self.contentView addSubview:labelTitle];
        
        UILabel *labelUserName = [UILabel new];
        labelUserName.numberOfLines = 0;
        labelUserName.lineBreakMode = NSLineBreakByWordWrapping;
        labelUserName.textAlignment = NSTextAlignmentLeft;
        labelUserName.isAccessibilityElement = YES;
        labelUserName.textColor = [UIColor whiteColor];
        labelUserName.font = [UIFont boldSystemFontOfSize:22.0];
        _labelUserName = labelUserName;
        [self.contentView addSubview:labelUserName];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        _separatorView = separatorView;
        [self.contentView addSubview:separatorView];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    _overlayView.frame = contentRect;
    
    contentRect.origin.y = contentRect.size.height - kSeparatorHeight;
    contentRect.size.height = kSeparatorHeight;
    _separatorView.frame = contentRect;

    CGFloat xx = kContentsPadding;
    CGFloat yy = xx;
    CGFloat ww = CGRectGetWidth(self.contentView.bounds) - 2.0f*xx;
    CGFloat hh = CGRectGetHeight(_labelUserName.bounds);
    _labelUserName.frame = CGRectMake(xx, yy, ww, hh);
    
    yy += hh + kLabelsPadding;
    hh = CGRectGetHeight(_labelTitle.bounds);
    _labelTitle.frame = CGRectMake(xx, yy, ww, hh);
    
    xx = -kParallaxOffset;
    yy = -kParallaxOffset;
    ww = CGRectGetWidth(self.contentView.bounds) + 2.0f*kParallaxOffset;
    hh = CGRectGetHeight(self.contentView.bounds) + 2.0f*kParallaxOffset;
    _imageViewPhoto.frame = CGRectMake(xx, yy, ww, hh);

}

- (void)reloadCellWithDataItem:(MNTableItem*)item {
    _dataItem = item;
    _labelTitle.text = item.title;
    _labelUserName.text = item.userName;
    _imageViewPhoto.image = nil;
    
    [_labelTitle sizeToFit];
    [_labelUserName sizeToFit];

}
- (void)reloadImage:(UIImage*)image {
    _imageViewPhoto.image = image;
}

- (void)updateBackgroundFrameWithOffset:(CGFloat)offset {
    CGFloat pixelOffset = (1.0f-offset)*2.0f*kParallaxOffset - 2.0f*kParallaxOffset;
    CGRect rect = _imageViewPhoto.frame;
    rect.origin.y = pixelOffset;
    _imageViewPhoto.frame = rect;
}

@end
