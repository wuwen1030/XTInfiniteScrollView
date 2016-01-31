//
//  XTInfiniteScrollView.m
//  X-Team
//
//  Created by Ben on 15/3/12.
//  Copyright (c) 2015年 X-Team. All rights reserved.
//

#import "XTInfiniteScrollView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static const NSTimeInterval kAutoScrollInterval = 3;

const int privateContext = 0;

@interface XTInfiniteScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSTimer *scrollTimer;
@property (nonatomic, strong) NSMutableArray *currentDisplay;

@end

@implementation XTInfiniteScrollView

#pragma mark - Init & dealloc

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentPage"];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self addGestureRecognizer:tap];
    
    [self addObserver:self forKeyPath:@"currentPage" options:0 context:(void *)&privateContext];
}

- (void)reloadScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.totalPage == 0)
    {
        self.currentPage = 0;
        return;
    }
    
    [self setCurrentDisplayWithCurrentPage:self.currentPage];
    
    NSInteger imageCount = self.totalPage > 1 ? 3 : 1;
    
    for (int i = 0; i < imageCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(self.bounds), 0,
                                                                               CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSURL *imageUrl = nil;
        UIImage *placeholderImage = nil;
        
        NSInteger index = [self.currentDisplay[i] integerValue];
        if ([self.dataSource respondsToSelector:@selector(infiniteScrollView:urlForImageAtIndex:)])
        {
            imageUrl = [self.dataSource infiniteScrollView:self urlForImageAtIndex:index];
        }
        if ([self.dataSource respondsToSelector:@selector(infiniteScrollView:placeholderForImageAtIndex:)])
        {
            placeholderImage = [self.dataSource infiniteScrollView:self placeholderForImageAtIndex:index];
        }
        
        if (!imageUrl)
        {
            imageView.image = placeholderImage;
        }
        else
        {
            [imageView setImageWithURL:imageUrl
                      placeholderImage:placeholderImage];
        }
        
        [self.scrollView addSubview:imageView];
    }
    _scrollView.contentSize = CGSizeMake(imageCount*CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    if (imageCount > 1)
    {
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self reloadData];
}

#pragma mark - Display

- (void)reloadData
{
    if ([self.dataSource respondsToSelector:@selector(numberOfImagesInInfiniteScrollView:)])
    {
        self.totalPage = [self.dataSource numberOfImagesInInfiniteScrollView:self];
    }
    
    self.currentPage = 0;
    [self.currentDisplay removeAllObjects];
    
    [self reloadScrollView];
}

- (void)setCurrentDisplayWithCurrentPage:(NSInteger)currentPage
{
    if (self.currentDisplay == nil)
    {
        self.currentDisplay = [NSMutableArray array];
    }
    [self.currentDisplay removeAllObjects];
    
    NSInteger previous = [self validPage:currentPage - 1];
    NSInteger next = [self validPage:currentPage + 1];
    
    if (previous < self.totalPage)
    {
        [self.currentDisplay addObject:@(previous)];
    }
    if (currentPage < self.totalPage)
    {
        [self.currentDisplay addObject:@(currentPage)];
    }
    if (next < self.totalPage)
    {
        [self.currentDisplay addObject:@(next)];
    }
}

- (NSInteger)validPage:(NSInteger)page
{
    if (page == -1)
    {
        return self.totalPage - 1;
    }
    
    if (page == self.totalPage)
    {
        return 0;
    }
    
    return page;
}

- (void)autoScroll
{
    if (self.totalPage > 1)
    {
        [self.scrollView setContentOffset:CGPointMake(2 * CGRectGetWidth(self.bounds), 0) animated:YES];
    }
    else
    {
        self.shouldAutoScroll = NO;
    }
}

#pragma mark - Events

- (void)tapped
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(infiniteScrollView:didSelectImageAtIndex:)])
    {
        [self.delegate infiniteScrollView:self didSelectImageAtIndex:self.currentPage];
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat floatPage = scrollView.contentOffset.x / CGRectGetWidth(self.bounds);
    
    if (floatPage >= 2)
    {
        self.currentPage = [self validPage:self.currentPage + 1];
        [self reloadScrollView];
    }
    
    if (floatPage <= 0)
    {
        self.currentPage = [self validPage:self.currentPage - 1];
        [self reloadScrollView];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self disableAutoScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self enableAutoScroll];
}

#pragma mark - Control

- (void)enableAutoScroll
{
    if (self.shouldAutoScroll && !self.scrollTimer)
    {
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:kAutoScrollInterval
                                                            target:self
                                                          selector:@selector(autoScroll)
                                                          userInfo:nil
                                                           repeats:YES];
    }
}

- (void)disableAutoScroll
{
    if (self.scrollTimer )
    {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

- (void)setShouldAutoScroll:(BOOL)shouldAutoScroll
{
    _shouldAutoScroll = shouldAutoScroll;
    
    if (shouldAutoScroll)
    {
        [self enableAutoScroll];
    }
    else
    {
        [self disableAutoScroll];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"currentPage"]
        || object != self
        || context != &privateContext)
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didShowImageAtIndex:)])
    {
        [self.delegate infiniteScrollView:self didShowImageAtIndex:self.currentPage];
    }
}


@end
