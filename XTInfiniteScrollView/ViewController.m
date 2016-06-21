//
//  ViewController.m
//  XTInfiniteScrollView
//
//  Created by Ben on 15/3/30.
//  Copyright (c) 2015年 X-Team. All rights reserved.
//

#import "ViewController.h"
#import "XTInfiniteScrollView.h"

@interface ViewController () <XTInfiniteScrollViewDataSource, XTInfiniteScrollViewDelegate>

@property (weak, nonatomic) IBOutlet XTInfiniteScrollView *infiniteScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *imageURLs;
@property (strong, nonatomic) NSArray *placeholderImages;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.infiniteScrollView.dataSource = self;
    self.infiniteScrollView.delegate = self;
    self.infiniteScrollView.shouldAutoScroll = YES;
    
    self.imageURLs = @[[NSURL URLWithString:@"http://fmn.rrimg.com/fmn062/xiaozhan/20121011/0945/x_large_14pE_506b000002f71263.jpg"],
                       [NSURL URLWithString:@"http://www.bz55.com/uploads/allimg/121117/1-12111F94403.jpg"],
                       [NSURL URLWithString:@"http://m2.img.srcdd.com/farm5/d/2013/0605/22/1C96B5EE787AD7D938A3979F83AC647C_B800_2400_500_750.PNG"]];
    self.placeholderImages = @[[UIImage imageNamed:@"car"],
                               [UIImage imageNamed:@"car"],
                               [UIImage imageNamed:@"car"]];
    self.pageControl.numberOfPages = self.imageURLs.count;
    [self.infiniteScrollView reloadData];
}

#pragma mark - XTInfiniteScrollViewDataSource

- (NSUInteger)numberOfImagesInInfiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView
{
    return self.imageURLs.count;
}

- (NSURL *)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView urlForImageAtIndex:(NSUInteger)index
{
    return self.imageURLs[index];
}

- (UIImage *)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView placeholderForImageAtIndex:(NSUInteger)index
{
    return self.placeholderImages[index];
}

#pragma mark - XTInfiniteScrollViewDelegate

- (void)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"Select image at index:%ld", (long)index);
}

- (void)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView didShowImageAtIndex:(NSUInteger)index
{
    NSLog(@"Did show image at index:%ld", (long)index);
    self.pageControl.currentPage = index;
}

@end
