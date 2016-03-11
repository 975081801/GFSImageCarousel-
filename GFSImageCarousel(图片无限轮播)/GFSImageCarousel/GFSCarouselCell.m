//
//  GFSCarouselCell.m
//  GFSImageCarousel(图片无限轮播)
//
//  Created by 管复生 on 16/3/11.
//  Copyright © 2016年 GFS. All rights reserved.
//

#import "GFSCarouselCell.h"
@interface GFSCarouselCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation GFSCarouselCell

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
