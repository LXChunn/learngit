//
//  XPMoreOptionsViewController.m
//  XPApp
//
//  Created by jy on 15/12/28.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPMoreOptionsViewController.h"

static const CGFloat xp_optionsViewWidth = 113;
static const CGFloat xp_optionsViewCellHeight = 48;
static const CGFloat xp_optionsViewLeftWidth = 12;
static const CGFloat xp_coverViewTriangleHeight = 16;

@interface XPMoreOptionsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *iconsArray;
@property (nonatomic,strong) NSArray *titlesArray;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIImageView *coverImageView;
@property (nonatomic,strong) UIButton *bgButton;

@end

@implementation XPMoreOptionsViewController

- (instancetype)initWithMoreOptionsWithIcons:(NSArray *)icons titles:(NSArray *)titles
{
    NSAssert(icons, @"图标不许为空");
    NSAssert(titles, @"文字不许为空");
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        _iconsArray = icons;
        _titlesArray = titles;
        [self configureUI];
    }
    return self;
}

- (void)show
{
    [self makeKeyAndVisible];
    [self showAnimaiton];
}

#pragma mark - Private
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.windowLevel = UIWindowLevelAlert;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)configureUI
{
    _bgButton = [[UIButton alloc] init];
    [self addSubview:_bgButton];
    [_bgButton addTarget:self action:@selector(dismissWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    _bgButton.backgroundColor = [UIColor clearColor];
    _bgButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width - xp_optionsViewWidth - xp_optionsViewLeftWidth, 70, xp_optionsViewWidth, xp_optionsViewCellHeight * _titlesArray.count + xp_coverViewTriangleHeight)];
    _coverImageView = [[UIImageView alloc] initWithFrame:self.coverView.bounds];
    UIEdgeInsets insets = UIEdgeInsetsMake(15, 15, 15, 15);
    UIImage * coverImage = [UIImage imageNamed:@"common_popover_background"];
    coverImage = [coverImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.coverImageView.image = coverImage;
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.coverImageView];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, xp_optionsViewWidth, xp_optionsViewCellHeight * _titlesArray.count)];
    self.myTableView.scrollEnabled = NO;
    self.myTableView.userInteractionEnabled = YES;
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorColor = [UIColor clearColor];
    [self.coverView addSubview:self.myTableView];
}

- (void)showAnimaiton
{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.coverView.hidden = NO;
                     }
                     completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                     }];
}

- (void)dismissWithAnimation
{
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.9
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.coverView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                         [self.myTableView removeFromSuperview];
                         [self resignKeyWindow];
                         [self setHidden:YES];
                         [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
                     }];
}

#pragma mark - UITableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UILabel *line = [[UILabel alloc] initWithFrame:(CGRect){10, xp_optionsViewCellHeight - 1, tableView.bounds.size.width - 20, 1}];
        line.backgroundColor = [UIColor whiteColor];
        line.tag = 100;
        [cell addSubview:line];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:(CGRect){15,16,16,16}];
        imageView.image = [UIImage imageNamed:[_iconsArray objectAtIndex:indexPath.row]];
        [cell addSubview:imageView];
        UILabel * label = [[UILabel alloc] initWithFrame:(CGRect){20 , 0 ,xp_optionsViewWidth - 20 , xp_optionsViewCellHeight}];
        label.text = [_titlesArray objectAtIndex:indexPath.row];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
        cell.backgroundColor = [UIColor clearColor];
        UIColor *color = [UIColor colorWithRed:0.176 green:0.502 blue:0.725 alpha:1.000];//通过RGB来定义自己的颜色
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = color;
    }
    if(indexPath.row < _titlesArray.count-1) {
        [[cell viewWithTag:100] setHidden:NO];
    } else {
        [[cell viewWithTag:100] setHidden:YES];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return xp_optionsViewCellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissWithAnimation];
    if(self.delegate && [self.delegate respondsToSelector:@selector(optionsViewWithDidSelectRow:)]) {
        [self.delegate optionsViewWithDidSelectRow:indexPath.row];
    }
}

@end
