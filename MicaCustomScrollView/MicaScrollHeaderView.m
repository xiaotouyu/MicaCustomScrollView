//
//  MicaScrollHeaderView.m
//  customScrollView
//
//  Created by dashuios126 on 16/8/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MicaScrollHeaderView.h"

#import "UIScrollView+_DScrollView.h"

@interface MicaScrollHeaderView()<UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *arraySource;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UIPageControl *pageControl;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,assign)NSInteger lastPage;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,weak) UIView *pageView;

@property (nonatomic,weak) UILabel *currentLabel;


@end

@implementation MicaScrollHeaderView


-(instancetype)initWithFrame:(CGRect)frame arraySource:(NSMutableArray *)arraySource{

    if (self=[super initWithFrame:frame]) {

        _currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageIndicatorTintColor = [UIColor lightGrayColor];
        _autoPlay = YES;
        _arraySource=arraySource;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createScrollView];

        });
    }
    return self;
}

- (void)createScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    [self addSubview:_scrollView];

    if (_arraySource.count == 0 || _arraySource == nil) {
        return;
    }

    if (_arraySource.count == 1) {
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        imageV.tag = 100;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [imageV addGestureRecognizer:tap];

        imageV.userInteractionEnabled = YES;
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        /**
         图片是从网络上加载的
         注意此时数组中存的应该是图片正确的下载网址否则不可用
         if ([_arraySource[i] hasPrefix:@"http://"]) {
         [_imageV sd_setImageWithURL:[NSURL URLWithString:array.firstObject]];
         }
         */
        //本地图片加载的方法
        imageV.image = [UIImage imageNamed:_arraySource.firstObject];

        [_scrollView addSubview:imageV];
        return;
    }

    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*(_arraySource.count), CGRectGetHeight(self.bounds));

    for (int i = 0 ; i<_arraySource.count; i++) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)*i, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        imageV.tag = 100*i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [imageV addGestureRecognizer:tap];

        imageV.userInteractionEnabled = YES;
        imageV.contentMode = UIViewContentModeScaleAspectFit;


        /**
         图片是从网络上加载的
         注意此时数组中存的应该是图片正确的下载网址否则不可用
         if ([_arraySource[i] hasPrefix:@"http://"]) {
         [_imageV sd_setImageWithURL:[NSURL URLWithString:array[i]]];
         }
         */
        //本地图片加载的方法
        imageV.image = [UIImage imageNamed:_arraySource[i]];

        [_scrollView addSubview:imageV];

    }
    [_scrollView make3Dscrollview];

    [self createPageControl];
    _lastPage = _arraySource.count - 1;
    [self createRightRount];
    if (_autoPlay) {
        [self timerOn];
    }
}
/**
 *  以pageControl显示图片个数
 */
- (void)createPageControl{

    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.center.x-100, CGRectGetHeight(self.bounds) - 40, 200, 30)];
    _pageControl.numberOfPages = _arraySource.count-2;
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventTouchUpInside];
    _pageControl.hidden = _isPageControl;

    [_pageControl setValue:[UIImage imageNamed:_pageImage] forKeyPath:@"pageImage"];
    [_pageControl setValue:[UIImage imageNamed:_currentPageImage] forKeyPath:@"currentPageImage"];
    [self addSubview:_pageControl];
}
/**
 *  pageControl隐藏,以数字的形式显示图片个数
 */
- (void)createRightRount{

    UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 50, CGRectGetHeight(self.bounds) - 40, 30, 30)];
    pageView.backgroundColor = [UIColor lightGrayColor];
    pageView.alpha = 0.5;
    pageView.layer.cornerRadius = 15;
    pageView.layer.masksToBounds = YES;
    pageView.hidden = _isRound;
    [self addSubview:pageView];

    UILabel *currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7.5, 30, 15)];
    currentLabel.text = [NSString stringWithFormat:@"1/%ld",_arraySource.count - 2];
    currentLabel.textColor = [UIColor whiteColor];
    currentLabel.font = [UIFont systemFontOfSize:9];
    currentLabel.textAlignment = NSTextAlignmentCenter;
    currentLabel.hidden = _isRound;
    [pageView addSubview:currentLabel];
    self.currentLabel = currentLabel;
}

//该方法是添加的tap事件当点击不同的图片会执行不同的命令
- (void)tap:(UITapGestureRecognizer*)tap{

    NSLog(@"%ld",tap.view.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(adView:didDeselectAdAtNum:)]) {

        [self.delegate adView:self didDeselectAdAtNum:tap.view.tag];
    }

}
#pragma mark -定时器方法
- (void)onTimer
{
    int index = _scrollView.contentOffset.x/CGRectGetWidth(self.bounds);
    index++;
    NSLog(@"%d",index);
    if (index == _lastPage) {
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*_lastPage, 0) animated:YES];

        _scrollView.contentOffset = CGPointMake(0, 0);
        _pageControl.currentPage = 0;
        self.currentLabel.text = [NSString stringWithFormat:@"1/%ld",_arraySource.count - 2];

    }else{
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*index, 0) animated:YES];
        _pageControl.currentPage = _scrollView.contentOffset.x/CGRectGetWidth(self.bounds);
        self.currentLabel.text = [NSString stringWithFormat:@"%d/%ld",index,_arraySource.count - 2];
    }
}

#pragma mark -UIPageControl绑定方法
- (void)pageControlClick:(UIPageControl *)sender{
    [_scrollView setContentOffset:CGPointMake((sender.currentPage+1)*CGRectGetWidth(self.bounds), 0) animated:YES];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{

    [self timerOff];
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/CGRectGetWidth(self.bounds);
    index++;

    NSLog(@"%d",index);
    if (scrollView.contentOffset.x/CGRectGetWidth(self.bounds) == _lastPage) {
        //当显示第7个位置的图片时(第1张图片) _pageControl对应应该显示第0页 滑动视图对应应该移动偏移量到第2个位置的图片(第1张图片)
        _pageControl.currentPage = 0;
        self.currentPage = 1;
        self.currentLabel.text = [NSString stringWithFormat:@"1/%ld",_arraySource.count - 2];
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
    }else if(scrollView.contentOffset.x/CGRectGetWidth(self.bounds) == 0){
        _pageControl.currentPage = _lastPage-2;
        self.currentPage = _lastPage - 1;
        self.currentLabel.text = [NSString stringWithFormat:@"1/%ld",_arraySource.count - 2];
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*(_lastPage-1), 0)];
    }else{
        _pageControl.currentPage = scrollView.contentOffset.x/CGRectGetWidth(self.bounds)-1;
        self.currentPage = scrollView.contentOffset.x/CGRectGetWidth(self.bounds);
        self.currentLabel.text = [NSString stringWithFormat:@"%d/%ld",index - 1,_arraySource.count - 2];
    }
    if (_autoPlay) {
        [self timerOn];
    }
}

//开启定时器
-(void)timerOn{

    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}


//关闭定时器
-(void)timerOff{
    
    [_timer invalidate];
    _timer = nil;
}


@end
