//
//  GFSImageCarouselView.m
//  GFSImageCarousel(图片无限轮播)
//
//  Created by 管复生 on 16/3/11.
//  Copyright © 2016年 GFS. All rights reserved.
//

#import "GFSImageCarouselView.h"
#import "GFSCarouselCell.h"

@interface GFSImageCarouselView()<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  装轮播图片的数组
 */
@property(nonatomic,strong)NSArray *imageArray;
/**
 *  轮播view
 */
@property(nonatomic,weak)UICollectionView *carsouselView;
/**
 *  定时器
 */
@property(nonatomic,strong)NSTimer *timer;
/**
 *  翻页
 */
@property(nonatomic,weak)UIPageControl *pageControl;
/**
 *  当前页码
 */
@property(nonatomic,assign)NSUInteger currentPage;
@end
@implementation GFSImageCarouselView
/**
 *  快速初始化创建轮播器
 *
 *  @param frame frame
 *  @param array 图片组
 */
- (instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageArray = array;
        // 初始化设置
        [self setUp];
    }
    return self;
}

#pragma mark- 私有方法

- (void)setUp
{
    // 1 添加轮播view
    UICollectionViewFlowLayout *flowOut = [[UICollectionViewFlowLayout alloc]init];
    // 1.1轮播器cell的尺寸
    CGFloat itemW = self.frame.size.width;
    CGFloat itemH = self.frame.size.height;
    
    flowOut.itemSize = CGSizeMake(itemW, itemH);
    flowOut.minimumInteritemSpacing = 0;
    flowOut.minimumLineSpacing = 0;
    
    flowOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *carousel = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowOut];
    [self addSubview:carousel];
    
    self.carsouselView = carousel;
    
    [self.carsouselView registerNib:[UINib nibWithNibName:@"GFSCarouselCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.carsouselView.dataSource = self;
    self.carsouselView.delegate = self;
    self.carsouselView.showsHorizontalScrollIndicator = NO;
    self.carsouselView.pagingEnabled = YES;
    self.carsouselView.bounces = NO;
    // 默认选中50行
    NSUInteger startPage = 50 * self.imageArray.count;
    self.currentPage = startPage;
    
    [self.carsouselView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    // 2 添加分页
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(itemW * 0.5 - 25, itemH - 20, 50, 20)];
    
    pageControl.numberOfPages = self.imageArray.count;
    pageControl.pageIndicatorTintColor   = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.hidesForSinglePage = YES;
    
    // 如果有需求可以添加 page上的分页点击
//    [pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.pageControl = pageControl;
    [self addSubview:self.pageControl];
   
    
    // 3 添加定时器
    [self startTimer];
}
- (void)pageChanged:(UIPageControl *)pageControl
{
    [self stopTimer];
    //根据页数，调整滚动视图中得图片位置contentOffset
    CGFloat x = pageControl.currentPage * self.bounds.size.width* 50;
    [self.carsouselView setContentOffset:CGPointMake(x, 0) animated:YES];
    [self startTimer];
}
/**
 *  开始计时器
 */
- (void)startTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    self.timer = timer ;
    
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];

}
/**
 *  关闭计时器
 */
- (void)stopTimer
{
    [self.timer invalidate];
    
    self.timer = nil;
}
- (void)nextImage
{
    self.currentPage++;
    
    int index = (int) self.currentPage % self.imageArray.count;
    
    self.pageControl.currentPage = index;
    
    [self.carsouselView setContentOffset:CGPointMake(self.currentPage * self.bounds.size.width, 0) animated:YES];
//    [self pageChanged:self.pageControl];
}

#pragma mark- collection代理和数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count * 100;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFSCarouselCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.image = self.imageArray[indexPath.row%(self.imageArray.count)];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出选中的位置
    int page = (int)indexPath.row % self.imageArray.count;
    if ([self.delegate respondsToSelector:@selector(GFSImageCarouselDidClicked:)]) {
        [self.delegate GFSImageCarouselDidClicked:page];
    }
    
}
#pragma mark- scrollview的代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
/**
 *  滚动就会调用
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 偏移量 计算第几页
    int page = scrollView.contentOffset.x / self.frame.size.width + 0.5;
    
    self.pageControl.currentPage = page % self.imageArray.count;
}
@end
