//
//  XPSecondHandViewController.m
//  XPApp
//
//  Created by jy on 15/12/28.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPMoreOptionsViewController.h"
#import "XPMyCollectionViewController.h"
#import "XPMyCommentViewController.h"
#import "XPMyPostViewController.h"
#import "XPSecondHandContentViewController.h"
#import "XPSecondHandViewController.h"
#import "XPTransferOrBuyViewController.h"
#import <UIColor+XPKit.h>

static const CGFloat kTopHeight = 44;

@interface XPSecondHandViewController ()<XPOptionsViewControllerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *DefaultTapView;
@property (weak, nonatomic) IBOutlet UIView *SpecialTapView;
@property (weak, nonatomic) IBOutlet UIButton *specialTransferButton;
@property (weak, nonatomic) IBOutlet UIButton *specialBuyButton;
@property (weak, nonatomic) IBOutlet UIButton *specialOtherButton;
@property (weak, nonatomic) IBOutlet UILabel *specialTransferLine;
@property (weak, nonatomic) IBOutlet UILabel *specialBuyLIne;
@property (weak, nonatomic) IBOutlet UILabel *specialOtherLine;

@property (nonatomic, strong) XPMoreOptionsViewController *moreOptions;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIButton *transferButton;
@property (weak, nonatomic) IBOutlet UILabel *transferLine;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *buyLine;
@end

@implementation XPSecondHandViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    self.SpecialTapView.hidden = YES;
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI
{
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    [self.pageViewController setViewControllers:[self configureViewControllersWinthIndex:0] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, kTopHeight, self.view.frame.size.width, self.view.frame.size.height - kTopHeight);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self updateUIWithIndex:1];
    [self updateUIWithIndex:0];
    switch(_mineType) {
        case MineTypeOfPost: {
            self.navigationItem.title = @"我的发布";
            self.navigationItem.rightBarButtonItem.title = @"";
            self.navigationItem.rightBarButtonItem.image = nil;
            self.SpecialTapView.hidden = NO;
            self.DefaultTapView.hidden = YES;
            break;
        }
            
        case MineTypeOfCollection: {
            self.navigationItem.title = @"我的收藏";
            self.navigationItem.rightBarButtonItem.title = @"";
            self.navigationItem.rightBarButtonItem.image = nil;
            self.SpecialTapView.hidden = NO;
            self.DefaultTapView.hidden = YES;
            break;
        }
            
        case MineTypeOfSecondHand: {
            self.navigationItem.title = @"二手市场";
            break;
        }
            
        case MineTypeOfComment: {
            self.navigationItem.title = @"我的评论";
            self.navigationItem.rightBarButtonItem.title = @"";
            self.navigationItem.rightBarButtonItem.image = nil;
            break;
        }
            
        default: {
        }
            break;
    }
}

#pragma mark - PageViewControllerDelegateAndData Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index;
    index = ((XPSecondHandContentViewController *)viewController).pageIndex;
    [self updateUIWithIndex:index];
    if((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    switch(_mineType) {
        case MineTypeOfComment: {
            return [self commentViewControllerAtIndex:index];
        }
            
        case MineTypeOfPost: {
            return [self postViewControllerAtIndex:index];
        }
            
        case MineTypeOfSecondHand: {
            return [self secondHandViewControllerAtIndex:index];
        }
            
        case MineTypeOfCollection: {
            return [self collectionViewControllerAtIndex:index];
        }
            
        default: {
        }
            break;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index;
    index = ((XPSecondHandContentViewController *)viewController).pageIndex;
    [self updateUIWithIndex:index];
    if(index == NSNotFound) {
        return nil;
    }
    if (self.mineType == MineTypeOfCollection||self.mineType == MineTypeOfPost) {
        index++;
        if (index==3) {
            return nil;
        }
    }else{
        index++;
    if(index == 2) {
        return nil;
        }
    }
    
    switch(_mineType) {
        case MineTypeOfComment: {
            return [self commentViewControllerAtIndex:index];
        }
            
        case MineTypeOfPost: {
            return [self postViewControllerAtIndex:index];
        }
            
        case MineTypeOfSecondHand: {
            return [self secondHandViewControllerAtIndex:index];
        }
            
        case MineTypeOfCollection: {
            return [self collectionViewControllerAtIndex:index];
        }
            
        default: {
        }
            break;
    }
}

#pragma mark - XPOptionsViewControllerDelegate
- (void)optionsViewController:(XPMoreOptionsViewController *)optionsViewController didSelectRow:(NSInteger)row
{
    XPTransferOrBuyViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPTransferOrBuyViewController"];
    if(row == 0) {
        viewController.secondHandGoodsType = SecondHandGoodsTypeOfTransfer;
    } else if(row == 1) {
        viewController.secondHandGoodsType = SecondHandGoodsTypeOfBuy;
    }
    [self pushViewController:viewController];
}

#pragma mark - Event Responds
- (IBAction)addAction:(id)sender
{
    if(_mineType == MineTypeOfSecondHand) {
        _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_transfer_ico", @"secondhand_buy_ico"] titles:@[@"转让", @"求购"]];
        _moreOptions.delegate = self;
        [_moreOptions show];
    }
}

- (IBAction)transferAction:(id)sender
{
    [self updateUIWithIndex:0];
    [self.pageViewController setViewControllers:[self configureViewControllersWinthIndex:0] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)buyAction:(id)sender
{
    [self updateUIWithIndex:1];
    [self.pageViewController setViewControllers:[self configureViewControllersWinthIndex:1] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)other:(id)sender
{
    [self updateUIWithIndex:2];
    [self.pageViewController setViewControllers:[self configureViewControllersWinthIndex:2] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


#pragma mark - Private Methods
- (XPSecondHandContentViewController *)secondHandViewControllerAtIndex:(NSUInteger)index
{
    if(index >= 2) {
        return nil;
    }
    
    XPSecondHandContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPSecondHandContentViewController"];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (XPMyCollectionViewController *)collectionViewControllerAtIndex:(NSUInteger)index
{
    if(index >= 3) {
        return nil;
    }
    
    UIViewController *viewcontroller = [self instantiateInitialViewControllerWithStoryboardName:@"MyCollection"];
    XPMyCollectionViewController *pageContentViewController = (XPMyCollectionViewController *)viewcontroller;
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (XPMyCommentViewController *)commentViewControllerAtIndex:(NSUInteger)index
{
    if(index >= 2) {
        return nil;
    }
    
    UIViewController *viewcontroller = [self instantiateInitialViewControllerWithStoryboardName:@"MyComment"];
    XPMyCommentViewController *pageContentViewController = (XPMyCommentViewController *)viewcontroller;
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (XPMyPostViewController *)postViewControllerAtIndex:(NSUInteger)index
{
    if(index >= 3) {
        return nil;
    }
    
    UIViewController *viewcontroller = [self instantiateInitialViewControllerWithStoryboardName:@"MyPost"];
    XPMyPostViewController *pageContentViewController = (XPMyPostViewController *)viewcontroller;
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (void)updateUIWithIndex:(NSInteger)index
{
    if(index == 0) {
        switch(_mineType) {
            case MineTypeOfCollection: {
                [_transferButton setTitle:@"论坛" forState:UIControlStateNormal];
                [_specialTransferButton setTitle:@"论坛" forState:UIControlStateNormal];
            }
                break;
                
            case MineTypeOfSecondHand: {
                [_transferButton setTitle:@"转让" forState:UIControlStateNormal];
            }
                break;
                
            case MineTypeOfPost: {
                [_transferButton setTitle:@"论坛" forState:UIControlStateNormal];
                [_specialTransferButton setTitle:@"转让" forState:UIControlStateNormal];
            }
                break;
                
            case MineTypeOfComment: {
                [_transferButton setTitle:@"评论我的" forState:UIControlStateNormal];
            }
                break;
                
            default: {
            }
                break;
        }
        [_transferButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        _transferLine.hidden = NO;
        [_buyButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        _buyLine.hidden = YES;
        
        [_specialTransferButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        [_specialBuyButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        [_specialOtherButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        _specialOtherLine.hidden = YES;
        _specialBuyLIne.hidden = YES;
        _specialTransferLine.hidden = NO;
        
    } else if(index == 1) {
        switch(_mineType) {
            case MineTypeOfCollection: {
                [_buyButton setTitle:@"二手" forState:UIControlStateNormal];
                [_specialBuyButton setTitle:@"二手" forState:UIControlStateNormal];
            }
                break;
                
            case MineTypeOfSecondHand: {
                [_buyButton setTitle:@"求购" forState:UIControlStateNormal];
            }
                break;
                
            case MineTypeOfPost: {
                [_buyButton setTitle:@"二手" forState:UIControlStateNormal];
                [_specialBuyButton setTitle:@"二手" forState:UIControlStateNormal];
            }
                break;
                
            case MineTypeOfComment: {
                [_buyButton setTitle:@"我评论的" forState:UIControlStateNormal];
            }
                break;
                
            default: {
            }
                break;
        }
        [_buyButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        _buyLine.hidden = NO;
        [_transferButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        _transferLine.hidden = YES;
        
        [_specialBuyButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        [_specialTransferButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        [_specialOtherButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        _specialOtherLine.hidden = YES;
        _specialBuyLIne.hidden = NO;
        _specialTransferLine.hidden = YES;
    }else{
        switch(_mineType) {
            case MineTypeOfCollection: {
                [_buyButton setTitle:@"二手" forState:UIControlStateNormal];
                [_specialBuyButton setTitle:@"二手" forState:UIControlStateNormal];
            }
                break;
                
            case MineTypeOfSecondHand: {
                [_buyButton setTitle:@"求购" forState:UIControlStateNormal];
            }
                break;
                
            case MineTypeOfPost: {
                [_buyButton setTitle:@"二手" forState:UIControlStateNormal];
                 [_specialBuyButton setTitle:@"二手" forState:UIControlStateNormal];
            }
                break;
                
            case MineTypeOfComment: {
                [_buyButton setTitle:@"我评论的" forState:UIControlStateNormal];
            }
                break;
                
            default: {
            }
                break;
        }
        [_buyButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        _buyLine.hidden = NO;
        [_transferButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        _transferLine.hidden = YES;
        
        [_specialOtherButton setTitleColor:[UIColor colorWithHex:0x2667b5] forState:UIControlStateNormal];
        [_specialTransferButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        [_specialBuyButton setTitleColor:[UIColor colorWithHex:0x474747] forState:UIControlStateNormal];
        _specialOtherLine.hidden = NO;
        _specialBuyLIne.hidden = YES;
        _specialTransferLine.hidden = YES;
    }
}

- (NSArray *)configureViewControllersWinthIndex:(NSInteger)index
{
    NSArray *viewControllers;
    switch(_mineType) {
        case MineTypeOfComment: {
            XPMyCommentViewController *contentViewController = [self commentViewControllerAtIndex:index];
            viewControllers = @[contentViewController];
            return viewControllers;
        }
            
        case MineTypeOfPost: {
            XPMyPostViewController *contentViewController = [self postViewControllerAtIndex:index];
            viewControllers = @[contentViewController];
            return viewControllers;
        }
            
        case MineTypeOfSecondHand: {
            XPSecondHandContentViewController *contentViewController = [self secondHandViewControllerAtIndex:index];
            viewControllers = @[contentViewController];
            return viewControllers;
        }
            
        case MineTypeOfCollection: {
            XPMyCollectionViewController *contentViewController = [self collectionViewControllerAtIndex:index];
            viewControllers = @[contentViewController];
            return viewControllers;
        }
            
        default: {
        }
            break;
    }
}

#pragma mark - Getter & Setter

@end
