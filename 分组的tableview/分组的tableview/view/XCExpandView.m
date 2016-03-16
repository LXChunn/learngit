//
//  XCExpandView.m
//  分组的tableview
//
//  Created by Mac OS on 16/3/15.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "XCExpandView.h"
@interface XCExpandView ()
{
    __weak UIScrollView* _scrollView;
    __weak UIView* _imageView;
    CGFloat _expandHeight;
}


@end

@implementation XCExpandView
- (void)dealloc
{
    if(_scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
        _scrollView = nil;
    }
    _imageView = nil;
}
#pragma mark - publicMethod
- (void)expandView:(UITableView *)tableview andImageView:(UIImageView *)imageview
{
    _expandHeight = CGRectGetHeight(imageview.frame);
    
    _scrollView = tableview;
    _imageView = imageview;
    //设置偏移量
    _scrollView.contentInset = UIEdgeInsetsMake(_expandHeight, 0, 0, 0);
    [_scrollView insertSubview:_imageView atIndex:0];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView setContentOffset:CGPointMake(0, 10)];
    
    //view可以伸展
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    
    [_imageView setFrame:CGRectMake(0, -1 * _expandHeight, CGRectGetWidth(_imageView.frame), _expandHeight)];
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (![keyPath isEqual:@"contentOffset"]) {
        return;
    }
    
    CGFloat offsetY = _scrollView.contentOffset.y;
    if(offsetY < _expandHeight * -1) {
        CGRect currentFrame = _imageView.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = -1*offsetY;
        _imageView.frame = currentFrame;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
