//
//  ViewController.m
//  GFSImageCarousel(图片无限轮播)
//
//  Created by 管复生 on 16/3/11.
//  Copyright © 2016年 GFS. All rights reserved.
//

#import "ViewController.h"
#import "GFSImageCarouselView.h"
@interface ViewController ()<GFSImageCarouselDelegate>
@property(nonatomic,weak)GFSImageCarouselView *carouselView;
@property(nonatomic,strong)NSArray *imageArray;
@end

@implementation ViewController

- (NSArray *)imageArray
{
    if (!_imageArray) {
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i= 1; i<6; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
            if (image) {
                [array addObject:image];
            }
        }
        _imageArray = array;
    }
    return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    GFSImageCarouselView *carousel = [[GFSImageCarouselView alloc]initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 200) andImageArray:self.imageArray];
    carousel.delegate = self;
    self.carouselView = carousel;
    
    [self.view addSubview:self.carouselView];
}
- (void)GFSImageCarouselDidClicked:(NSUInteger)imageNumber
{
    NSLog(@"%ld",imageNumber);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
