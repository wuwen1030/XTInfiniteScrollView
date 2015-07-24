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

You should know which image the users have clicked, when you want to show a detail view. And maybe you will also need a page control to indicate which image is showing.
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
`pod 'XTInfiniteScrollView' ~> '1.0.0'`
