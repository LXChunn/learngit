//
//  XPSecondHandViewController.m
//  XPApp
//
//  Created by jy on 15/12/28.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPSecondHandViewController.h"
#import "XPMoreOptionsViewController.h"
#import "XPSecondHandContentViewController.h"
#import <UIColor+XPKit.h>
#import "XPTransferOrBuyViewController.h"

static const CGFloat kTopHeight = 44;

@interface XPSecondHandViewController ()<XPOptionsViewControllerDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic,strong) XPMoreOptionsViewController *moreOptions;
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIButton *transferButton;
@property (weak, nonatomic) IBOutlet UILabel *transferLine;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *buyLine;
@end

@implementation XPSecondHandViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI
{
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    XPSecondHandContentViewController *contentViewController = [self viewControllerAtIndex:0];
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
    NSUInteger index = ((XPSecondHandContentViewController*) viewController).pageIndex;
    [self updateUIWithIndex:index];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((XPSecondHandContentViewController*) viewController).pageIndex;
    [self updateUIWithIndex:index];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == 2) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - XPOptionsViewControllerDelegate
- (void)optionsViewWithDidSelectRow:(NSInteger)row
{
    XPTransferOrBuyViewController * viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPTransferOrBuyViewController"];
    if (row == 0)
    {
        viewController.secondHandGoodsType = SecondHandGoodsTypeOfTransfer;
    }
    else if (row == 1)
    {
        viewController.secondHandGoodsType = SecondHandGoodsTypeOfBuy;
    }
    [self pushViewController:viewController];
}

#pragma mark - Event Responds
- (IBAction)addAction:(id)sender
{
    _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_transfer_ico",@"secondhand_buy_ico"] titles:@[@"转让",@"求购"]];
    _moreOptions.delegate = self;
    [_moreOptions show];
}

- (IBAction)transferAction:(id)sender
{
    [self updateUIWithIndex:0];
    XPSecondHandContentViewController *contentViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[contentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)buyAction:(id)sender
{
    [self updateUIWithIndex:1];
    XPSecondHandContentViewController *contentViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = @[contentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - Private Methods
- (XPSecondHandContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= 2)
    {
        return nil;
    }
    XPSecondHandContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPSecondHandContentViewController"];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (void)updateUIWithIndex:(NSInteger)index
{
    if (index == 0)
    {
        [_transferButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        _transferLine.hidden = NO;
        [_buyButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        _buyLine.hidden = YES;
    }
    else if(index == 1)
    {
        [_buyButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        _buyLine.hidden = NO;
        [_transferButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        _transferLine.hidden = YES;
    }
}

#pragma mark - Getter & Setter

@end 
