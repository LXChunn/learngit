//
//  FaceView.m
//  FaceView
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 YF_S. All rights reserved.
//

#define kScreenW self.bounds.size.width

#import "FaceView.h"

@implementation FaceView{

    NSMutableArray *_dataList;
    
    UIScrollView *_scrollView;
}

//重写init方法
-(instancetype)initWithFrame:(CGRect)frame withReturnBlock:(returnItemNameBlock)block{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        //1.获取数据
        [self loadDatas];
        //加载视图
        [self createUIScrollView:block];
    }
    
    return self;
}

//获取数据
-(void)loadDatas{

    //获取数据路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"emoticons.plist" ofType:nil];
    
    //获取数据
    _dataList = [NSMutableArray arrayWithContentsOfFile:path];
}

//创建scrollView
-(void)createUIScrollView:(returnItemNameBlock)block{

    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor redColor];
    //分页效果
    _scrollView.pagingEnabled = YES;
    
    //把滑动条关闭
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    //创建多少个视图
    NSInteger count = _dataList.count/28 + ((_dataList.count%28)?1:0);
    
    //内容尺寸
    _scrollView.contentSize = CGSizeMake(count*kScreenW, _scrollView.bounds.size.height);
    
    //创建内容视图
    for (int i = 0; i < count; i++) {
        
        FaceViewItem *item = [[FaceViewItem alloc]initWithFrame:CGRectMake(kScreenW * i, 0, kScreenW, _scrollView.bounds.size.height) withReturnBlock:block];
        
        NSArray *itemArr = [_dataList subarrayWithRange:NSMakeRange(i*28, (_dataList.count-i*28)>=28?28:_dataList.count%28)];
        
        item.dataList = itemArr;
        
        //添加到UIScrollView上
        [_scrollView addSubview:item];
    }
    
    //添加到视图上
    [self addSubview:_scrollView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#define kItem 30

#define kSpace (kScreenW-210)/8

//内容视图
@implementation FaceViewItem{

    //放大镜图片
    UIImageView *_magnifierV;
    
    //放大镜中的表情图片
    UIImageView *_itemV;
    
    returnItemNameBlock _copyBlock;
}

//重写init方法
-(instancetype)initWithFrame:(CGRect)frame withReturnBlock:(returnItemNameBlock)block{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        _copyBlock = block;
    }
    
    return self;
}

//重写setDataList方法
-(void)setDataList:(NSArray *)dataList{

    _dataList = dataList;
    
    //系统调用 drawRect方法
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{

    //添加背景视图
    UIImage *bgImg = [UIImage imageNamed:@"emoticon_keyboard_background"];
    
    //画图 区域为本视图的大小
    [bgImg drawInRect:self.bounds];
    
    for (NSInteger i = 0; i < _dataList.count; i++) {
        
        UIImage *imgV = [UIImage imageNamed:[_dataList[i] objectForKey:@"png"]];
        
        [imgV drawInRect:[self itemFrameWithIndex:i]];
    }
}

//通过 点的位置 获取到一个图片的大小
-(CGRect)itemFrameWithIndex:(NSInteger)index{

    //获取到图片的X轴
    int x = index % 7;
    
    //获取到图片的Y轴
    int y = (int)index / 7;
    
    return CGRectMake(x *kItem + (x+1)*kSpace,y*kItem +(y+1)*kSpace , 30, 30);
}

//通过点 获取到第几个图片
-(NSInteger)itemFromPoint:(CGPoint)point{

    //获取到X轴上图片的个数
    int x = (point.x - kSpace)/(kItem+kSpace);
    
    //获取到Y轴上图片行数
    int y = (point.y - kSpace)/(kItem+kSpace);

    //返回有多少个图片
    return x+y*7;
}

//开始触摸时 调用
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    //1. 获取触摸的touch
//    UITouch *touch = [touches anyObject];
//    
//    //2. 获取到点
//    CGPoint point = [touch locationInView:self];
//    
//    //3. 通过点获取到第几个图片
//    NSInteger index = [self itemFromPoint:point];
    
    //调用方法  获取到现在触摸时 获取到的第几个图片
    NSInteger index = [self itemFormTouch:touches];

    if (index > _dataList.count) {
        
        return;
    }
    
    //4.创建放大镜图片
    if (!_magnifierV) {
        
        //初始化图片
        _magnifierV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 92)];
        
        //刚开始隐藏
        _magnifierV.hidden = YES;
        
        //设置背景图片
        _magnifierV.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier"];
        
        //添加
        [self addSubview:_magnifierV];
        
        //4. 初始化表情图片
        _itemV = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 60, 60)];
        
        [_magnifierV addSubview:_itemV];
    }
    
//    //确定放大镜的位置
//    CGRect itemFrame = [self itemFrameWithIndex:index];
//    
//    //通过item的中心点来确定放大镜的位置
//    CGFloat centerX = itemFrame.origin.x + itemFrame.size.width/2;
//    
//    CGFloat centerY = itemFrame.origin.y + itemFrame.size.height/2 - _magnifierV.frame.size.height/2;
//    
//    _magnifierV.center = CGPointMake(centerX, centerY);
    
    //调用方法 确定放大镜的位置
    _magnifierV.center = [self itemFormCenter:index];
    
    _magnifierV.hidden = NO;
    
    _itemV.image = [UIImage imageNamed:[_dataList[index] objectForKey:@"png"]];
}

//触摸移动时调用
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //将scrollView的滑动效果关闭
    ((UIScrollView *)self.superview).scrollEnabled = NO;
    
//    //获取到touch对象
//    UITouch *touch = [touches anyObject];
//    
//    //获取到点
//    CGPoint point = [touch locationInView:self];
//    
//    //通过point获取到 表情图片
//    NSInteger index = [self itemFromPoint:point];
//    
//    //确定放大镜的位置
//    CGRect itemFrame = [self itemFrameWithIndex:index];
//    
//    //确定中心点  X轴 Y轴
//    CGFloat centerX = itemFrame.origin.x + itemFrame.size.width/2;
//    
//    CGFloat centerY = itemFrame.origin.y + itemFrame.size.height/2 - _magnifierV.frame.size.height/2;
//    
//    _magnifierV.center = CGPointMake(centerX, centerY);
    
    //调用方法 获取到当前触摸时的图片
    NSInteger index = [self itemFormTouch:touches];
    
    if (index > _dataList.count) {
        
        return;
    }
    
    //调用方法 确定放大镜的位置
    _magnifierV.center = [self itemFormCenter:index];
    
    _magnifierV.hidden = NO;
    
    _itemV.image = [UIImage imageNamed:[_dataList[index] objectForKey:@"png"]];
}

//结束触摸时调用
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    _magnifierV.hidden = YES;
    
    //将scrollView的滑动效果开启
    ((UIScrollView *)self.superview).scrollEnabled = YES;
    
    //获取到表情的名字
//    //获取到touch对象
//    UITouch *touch = [touches anyObject];
//    
//    //获取到点
//    CGPoint point = [touch locationInView:self];
//    
//    //通过point获取到 表情图片
//    NSInteger index = [self itemFromPoint:point];
    
    //调用方法 获取当前的 表情图片
    NSInteger index = [self itemFormTouch:touches];
    
    if (index > _dataList.count) {
        
        return;
    }
    
    NSString *itemName = [_dataList[index] objectForKey:@"chs"];
    
    _copyBlock(itemName);
}

//获取到 当前触摸时 的第几个图片
-(NSInteger)itemFormTouch:(NSSet<UITouch *> *)touches{

    //1. 获取触摸的touch
    UITouch *touch = [touches anyObject];
    
    //2. 获取到点
    CGPoint point = [touch locationInView:self];
    
    //3. 通过点获取到第几个图片
    NSInteger index = [self itemFromPoint:point];
    
    return index;
}

//获取到 当前触摸时 的中心位置 ---->放大镜的中心位置
-(CGPoint)itemFormCenter:(NSInteger)index{

    //确定放大镜的位置
    CGRect itemFrame = [self itemFrameWithIndex:index];
    
    //确定中心点  X轴 Y轴
    CGFloat centerX = itemFrame.origin.x + itemFrame.size.width/2;
    
    CGFloat centerY = itemFrame.origin.y + itemFrame.size.height/2 - _magnifierV.frame.size.height/2;
    
    return CGPointMake(centerX, centerY);
}

@end
