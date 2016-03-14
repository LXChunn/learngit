//
//  XPPropertyBillListViewController.m
//  XPApp
//
//  Created by iiseeuu on 16/1/8.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPPropertyBillListViewController.h"
#import "XPPropertyBillViewController.h"
#import <UIColor+XPKit.h>

static const CGFloat kTopHeight = 44;

@interface XPPropertyBillListViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *willBillButton;
@property (weak, nonatomic) IBOutlet UIButton *doneBillButton;
@property (weak, nonatomic) IBOutlet UILabel *willLine;
@property (weak, nonatomic) IBOutlet UILabel *doneLine;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation XPPropertyBillListViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.title = @"物业缴费";
    [self initUI];
}

- (void)initUI
{
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    XPPropertyBillViewController *contentViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[contentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, kTopHeight, self.view.frame.size.width, self.view.frame.size.height - kTopHeight);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - PageViewControllerDelegateAndData Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((XPPropertyBillViewController *)viewController).pageIndex;
    [self updateUIWithIndex:index];
    if((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((XPPropertyBillViewController *)viewController).pageIndex;
    [self updateUIWithIndex:index];
    if(index == NSNotFound) {
        return nil;
    }
    index++;
    if(index == 2) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - Delegate

#pragma mark - Event Responds

- (IBAction)willBillAction:(id)sender
{
    [self updateUIWithIndex:0];
    XPPropertyBillViewController *contentViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[contentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)doneBillAction:(id)sender
{
    [self updateUIWithIndex:1];
    XPPropertyBillViewController *contentViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = @[contentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - Private Methods
- (XPPropertyBillViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if(index >= 2) {
        return nil;
    }
    
    XPPropertyBillViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPPropertyBillViewController"];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (void)updateUIWithIndex:(NSInteger)index
{
    if(index == 0) {
        [_willBillButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        _willLine.hidden = NO;
        [_doneBillButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        _doneLine.hidden = YES;
    } else if(index == 1) {
        [_doneBillButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        _doneLine.hidden = NO;
        [_willBillButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        _willLine.hidden = YES;
    }
}

#pragma mark - Getter & Setter

@end
