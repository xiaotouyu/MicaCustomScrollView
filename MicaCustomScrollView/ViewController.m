//
//  ViewController.m
//  MicaCustomScrollView
//
//  Created by dashuios126 on 16/8/17.
//  Copyright © 2016年 dashuios126. All rights reserved.
//

#import "ViewController.h"
#import "MicaScrollHeaderView.h"
@interface ViewController ()
@property (nonatomic,strong)MicaScrollHeaderView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

     NSMutableArray *array = [@[@"a4.jpg",@"a0.jpg",@"a1.jpg",@"a2.jpg",@"a3.jpg",@"a4.jpg",@"a0.jpg"]mutableCopy];

     _scrollView = [[MicaScrollHeaderView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) arraySource:array];

    _scrollView.pageImage = @"compose_keyboard_dot_normal";
    _scrollView.currentPageImage = @"compose_keyboard_dot_selected";
    //    _scrollView.isPageControl = YES;
    _scrollView.isRound = NO;
    _scrollView.autoPlay = NO;
    [self.view addSubview:_scrollView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
