//
//  UIScrollView+_DScrollView.h
//  scrollviewCategrey
//
//  Created by dashuios126 on 16/8/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (_DScrollView)
@property(nonatomic,assign)BOOL dScrollView;   // 当前属性设置位置必须位于添加子视图之后
@property(nonatomic,assign)NSUInteger pageNum;
@property(nonatomic,assign)CGFloat rightScale;
@property(nonatomic,assign)CGFloat leftScale;

- (void)make3Dscrollview; // 调用此方法实现3D效果


@end
