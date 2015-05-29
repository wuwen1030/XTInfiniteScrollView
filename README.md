# XTInfiniteScrollView

![gif](http://i3.tietuku.com/9b43ff25642ff319.gif)
##Initialization
You can either init a inifinite scroll view with code, xib or storyboard.
##Data Source
Data source is very similar to UITableViewDataSource. Implemention of protocols in `XTInfiniteScrollViewDataSource`.

```
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
```
If the showing images are from network, do implement `(UIImage *)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView placeholderForImageAtIndex:(NSUInteger)index`.

##Delegate

You will want to know which image the users have clicked, because you will show a detail view. And maybe you also want a page control to show which image are showing.
```
#pragma mark - XTInfiniteScrollViewDelegate

- (void)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"Select image at index:%ld", (long)index);
}

- (void)infiniteScrollView:(XTInfiniteScrollView *)infiniteScrollView didShowImageAtIndex:(NSUInteger)index
{
    NSLog(@"Did show image at index:%ld", (long)index);
}
```
##PS
Do remeber to import [AFNetworking](https://github.com/AFNetworking/AFNetworking)
##Usage
pod 'XTInfiniteScrollView' ~> '1.0.0'
##TODO
Support autolayout.
