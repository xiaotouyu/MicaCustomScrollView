//
//  MicaScrollHeaderView.h
//  customScrollView
//
//  Created by dashuios126 on 16/8/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MicaScrollHeaderView;
@protocol ScrollHeaderViewDelegate <NSObject>

@optional
/**
 *  点击图片触发(在此处理跳接)
 */
-(void)adView:(MicaScrollHeaderView *)adView didDeselectAdAtNum:(NSInteger)num;

@end
@interface MicaScrollHeaderView : UIView

@property (nonatomic,assign) BOOL isPageControl;
@property (nonatomic,assign) BOOL isRound;
/** 当前显示的pageControl的颜色 */
@property (nonatomic,strong) UIColor *currentPageIndicatorTintColor;
/** 当前未显示的pageControl的颜色 */
@property (nonatomic,strong) UIColor *pageIndicatorTintColor;
/** 自定义pageControl,未显示的图片名 */
@property (nonatomic,copy) NSString *pageImage;
/** 自定义pageControl,当前显示的图片名 */
@property (nonatomic,copy) NSString *currentPageImage;
/** 是否自动播放,默认为YES */
@property (nonatomic,assign) BOOL autoPlay;

@property (nonatomic,weak) id<ScrollHeaderViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame arraySource:(NSMutableArray *)arraySource;

@end

