//
//  XPAlertController.m
//  XPApp
//
//  Created by xinpinghuang on 12/25/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "XPAlertController.h"

static const CGFloat xp_AlertCellHeiht = 48;
static const CGFloat xp_AlertSpace = 7;
static const CGFloat xp_AlertCancelButtonHeight = 48;

@interface XPAlertController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *actionActivities;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *interateView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation XPAlertController

- (instancetype)initWithActivity:(NSArray *)activitys
{
    NSAssert(activitys, @"操作表不许为空");
    if(self = [self initWithFrame:[UIScreen mainScreen].bounds]) {
        _actionActivities = activitys;
        [self configAllUI];
    }
    
    return self;
}

- (void)show
{
    [self makeKeyAndVisible];
    [self showAnimaiton];
}

#pragma mark - Private Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.windowLevel = UIWindowLevelAlert;
        // 这里，不能设置UIWindow的alpha属性，会影响里面的子view的透明度，这里我们用一张透明的图片
        // 设置背影半透明
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)configAllUI
{
    [self configInteratieView];
    
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){0, self.bounds.size.height-_actionActivities.count * xp_AlertCellHeiht-xp_AlertSpace-xp_AlertCancelButtonHeight, self.bounds.size.width, _actionActivities.count * xp_AlertCellHeiht+xp_AlertSpace+xp_AlertCancelButtonHeight}];
    self.containerView.backgroundColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    [self addSubview:self.containerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){0, self.containerView.bounds.size.height-_actionActivities.count * xp_AlertCellHeiht-xp_AlertSpace-xp_AlertCancelButtonHeight, self.bounds.size.width, _actionActivities.count * xp_AlertCellHeiht}];
    self.tableView.scrollEnabled = NO;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.containerView addSubview:self.tableView];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:(CGRect){0, self.containerView.bounds.size.height - xp_AlertCancelButtonHeight, self.bounds.size.width, xp_AlertCancelButtonHeight}];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    self.cancelButton.opaque = NO;
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.containerView addSubview:self.cancelButton];
}

- (void)configInteratieView
{
    self.interateView = [[UIView alloc] initWithFrame:self.bounds];
    [self.interateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClick:)]];
    self.interateView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [self addSubview:self.interateView];
}

- (void)showAnimaiton
{
    self.hidden = NO;
    CGFloat y = self.containerView.frame.origin.y;
    self.containerView.frame = (CGRect){0, self.bounds.size.height, self.containerView.bounds.size};
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.containerView.frame = (CGRect){0, y, self.containerView.bounds.size};
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
                         self.containerView.frame = (CGRect){0, self.bounds.size.height, self.containerView.bounds.size};
                         self.interateView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                         [self.cancelButton removeFromSuperview];
                         [self.tableView removeFromSuperview];
                         [self.containerView removeFromSuperview];
                         [self.interateView removeFromSuperview];
                         [self resignKeyWindow];
                         [self setHidden:YES];
                         [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
                     }];
}

- (void)cancelButtonClick:(id)sender
{
    [self dismissWithAnimation];
    if(self.delegate && [self.delegate respondsToSelector:@selector(alertControllerDidCanceled:)]) {
        [self.delegate alertControllerDidCanceled:self];
    }
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _actionActivities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return xp_AlertCellHeiht;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UILabel *line = [[UILabel alloc] initWithFrame:(CGRect){0, cell.bounds.size.height-1, tableView.bounds.size.width, 1}];
        line.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        line.tag = 900;
        [cell addSubview:line];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = _actionActivities[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.backgroundColor = [UIColor whiteColor];
    if(indexPath.row < _actionActivities.count-1) {
        [[cell viewWithTag:900] setHidden:NO];
    } else {
        [[cell viewWithTag:900] setHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissWithAnimation];
    if(self.delegate && [self.delegate respondsToSelector:@selector(alertController:didSelectRow:)]) {
        [self.delegate alertController:self didSelectRow:indexPath.row];
    }
}

@end
