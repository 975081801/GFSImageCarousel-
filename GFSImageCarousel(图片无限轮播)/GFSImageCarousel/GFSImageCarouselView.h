//
//  GFSImageCarouselView.h
//  GFSImageCarousel(图片无限轮播)
//
//  Created by 管复生 on 16/3/11.
//  Copyright © 2016年 GFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GFSImageCarouselDelegate <NSObject>

@optional
/**
 *  代理方法 传出点击的图片
 *
 */
- (void)GFSImageCarouselDidClicked:(NSUInteger)imageNumber;
@end
@interface GFSImageCarouselView : UIView

@property(nonatomic,weak)id<GFSImageCarouselDelegate> delegate;
/**
 *  快速创建一个图片轮播器
 *
 *  @param frame frame
 *  @param array 图片组
 *
 */
- (instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)array;

@end
