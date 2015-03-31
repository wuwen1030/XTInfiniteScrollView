//
//  XTInfiniteScrollView.h
//  TuNiuApp
//
//  Created by Ben on 15/3/12.
//  Copyright (c) 2015年 Tuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTInfiniteScrollView;

@protocol XTInfiniteScrollViewDataSource <NSObject>

- (NSUInteger)numberOfImagesInInfiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView;

@optional
- (NSURL *)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView
           urlForImageAtIndex:(NSUInteger)index;

- (UIImage *)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView
     placeholderForImageAtIndex:(NSUInteger)index;

@end

@protocol XTInfiniteScrollViewDelegate <NSObject>

@optional
- (void)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView
     didSelectImageAtIndex:(NSUInteger)index;

- (void)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView
       didShowImageAtIndex:(NSUInteger)index;

@end

@interface XTInfiniteScrollView : UIView

@property (nonatomic, assign) BOOL shouldAutoScroll;
@property (nonatomic, weak) id<XTInfiniteScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<XTInfiniteScrollViewDelegate> delegate;

- (void)reloadData;

@end
