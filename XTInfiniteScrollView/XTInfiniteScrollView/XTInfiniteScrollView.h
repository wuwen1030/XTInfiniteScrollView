//
//  XTInfiniteScrollView.h
//  X-Team
//
//  Created by Ben on 15/3/12.
//  Copyright (c) 2015年 X-Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTInfiniteScrollView;

@protocol XTInfiniteScrollViewDataSource <NSObject>

/**
 *  Asks the data source for number of images.
 *
 *  @param infiniteScrollView A infinite scroll view which informs the data source.
 *
 *  @return Number of images.
 */
- (NSUInteger)numberOfImagesInInfiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView;

@optional
/**
 *  Asks the data source for URL of image.
 *
 *  @param infiniteScrollView A infinite scroll view which informs the data source.
 *  @param index              Index of the image view.
 *
 *  @return A URL of image.
 */
- (NSURL *)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView
           urlForImageAtIndex:(NSUInteger)index;

/**
 *  Asks the data source for placeholder image.
 *
 *  @param infiniteScrollView A infinite scroll view which informs the data source.
 *  @param index              Index of the image view.
 *
 *  @return A placeholder image.
 */
- (UIImage *)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView
     placeholderForImageAtIndex:(NSUInteger)index;

@end

@protocol XTInfiniteScrollViewDelegate <NSObject>

@optional
/**
 *  Notify the delegate that image was selected.
 *
 *  @param infiniteScrollView A infinite scroll view which informs the delegate.
 *  @param index              Index of the image view.
 */
- (void)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView
     didSelectImageAtIndex:(NSUInteger)index;

/**
 *  Notify the delegate that image is showing.
 *
 *  @param infiniteScrollView A infinite scroll view which informs the delegate.
 *  @param index              Index of the image view.
 */
- (void)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView
       didShowImageAtIndex:(NSUInteger)index;

@end

@interface XTInfiniteScrollView : UIView

/**
 *  Should auto scroll the image views, default is NO.
 */
@property (nonatomic, assign) BOOL shouldAutoScroll;
/**
 *  The auto scroll interval, default is 3, should large than 1.
 */
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;
/**
 *  The data source
 */
@property (nonatomic, weak) id<XTInfiniteScrollViewDataSource> dataSource;
/**
 *  The delegate
 */
@property (nonatomic, weak) id<XTInfiniteScrollViewDelegate> delegate;

/**
 *  Reload data. Should be called once upon data source changed.
 */
- (void)reloadData;

@end
