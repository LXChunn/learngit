//
//  XPDetailAnnounceViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/21.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPDetailAnnounceViewController.h"
#import "XPAnnouncementModel.h"
#import <UIImageView+AFNetworking.h>
@interface XPDetailAnnounceViewController ()<UIScrollViewDelegate>
{
    int _page;
}
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;
@property (nonatomic,strong)NSArray *imageUrlArray;
@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation XPDetailAnnounceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _page = 1;
    [self initUI];
    [self createTime];
}

#pragma mark - Life Circle
-(void)initUI
{
    self.detailTitleLabel.text = self.detailModel.title;
    NSString *createtime = [self getTimeStringWithSp:self.detailModel.createdAt];
    self.detailTimeLabel.text =[NSString stringWithFormat:@"发布时间 %@",createtime];
    self.detailContentLabel.text = self.detailModel.content;
    self.imageUrlArray = self.detailModel.picUrls;
    NSLog(@"数组长度：%d",_imageUrlArray.count);
    [self initScrollView];
}

-(NSString*)getTimeStringWithSp:(NSString *)sp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //[formatter setDateFormat:@"MM月dd日"];
    //[formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
//    [formatter setDateFormat:@"yyyy年MM月dd日"];
    [formatter setDateFormat:@"yyyy-MM-dd HH: mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:sp.doubleValue];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


-(void)initScrollView
{
    float width = CGRectGetWidth(self.scrollView.frame);
    float height = CGRectGetHeight(self.scrollView.frame);
    for (int i = 0; i<self.imageUrlArray.count+2; i++)
    { 
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width *i , 0, width+20, height)];
        if (i==self.imageUrlArray.count+1) {
            [imageView setImageWithURL:[NSURL URLWithString:_imageUrlArray[0]]];
        }else if(i==0) {
             [imageView setImageWithURL:[NSURL URLWithString:_imageUrlArray[_imageUrlArray.count-1]]];
        }else{
             [imageView setImageWithURL:[NSURL URLWithString:_imageUrlArray[i-1]]];
        }
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(width *(_imageUrlArray.count+2), 0);
    self.scrollView.delegate = self;
    [self createpageControl];
}

//创建计时器
-(void)createTime
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)runAction
{
    int page = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);;
    [self.scrollView setContentOffset:CGPointMake(++page*CGRectGetWidth(self.scrollView.frame), 0)animated:YES];
}

//设置分页指示器
-(void)createpageControl
{
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.scrollView.frame) + 100, 100, 60)];
    CGPoint center = self.pageControl.center;
    center.x = CGRectGetMidX(self.view.bounds);
    self.pageControl.center = center;
    self.pageControl.numberOfPages = self.imageUrlArray.count;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self.view addSubview:self.pageControl];
}

#pragma mark - Delegate
//减速完成
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self aboutScrollView:scrollView];
}

-(void)aboutScrollView:(UIScrollView *)scrollView
{
    int page =  scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    self.pageControl.currentPage = page - 1;
    
    if (page ==self.imageUrlArray.count+1){
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0)animated:NO];
        
        self.pageControl.currentPage = 0;
    }
    if (page ==0){
        [self.scrollView setContentOffset:CGPointMake((self.imageUrlArray.count)*CGRectGetWidth(scrollView.frame), 0)animated:NO];
        
        self.pageControl.currentPage = self.imageUrlArray.count-1;
    }
}

//滑动动画结束
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int page =  scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    self.pageControl.currentPage = page - 1;
    
    if (page ==self.imageUrlArray.count+1){
        //希望回到第0页
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0)animated:NO];
        self.pageControl.currentPage = 0;
    }
    
    if (page ==0){
        [self.scrollView setContentOffset:CGPointMake(2*CGRectGetWidth(scrollView.frame), 0)animated:NO];
        self.pageControl.currentPage = self.imageUrlArray.count;
    }
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
