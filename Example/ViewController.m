//
//  ViewController.m
//  KTUIKit
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "ViewController.h"
#import "Slide1ViewController.h"
#import "Slide2ViewController.h"
#import "KTSlideView.h"

@interface ViewController ()<KTSlideViewDataSource, KTSlideViewDelegate>

@property (nonatomic, strong) KTSlideView *slideView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.slideView];
    self.slideView.frame = self.view.bounds;
    
    [self.slideView setSelectedIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KTSlideViewDataSource
- (NSUInteger)numberOfViewControllers:(KTSlideView *)slideView
{
    return 2;
}

- (UIViewController *)kt_slideView:(KTSlideView *)slideView viewControllerAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return [[Slide1ViewController alloc] init];
    }
    
    return [[Slide2ViewController alloc] init];
}

#pragma mark - KTSlideViewDelegate
- (void)kt_slideView:(KTSlideView *)slideView didSelectedIndex:(NSUInteger)index
{
    NSLog(@"index = %zd", index);
}

#pragma mark - Getters and Setters
- (KTSlideView *)slideView
{
    if (!_slideView) {
        _slideView = [[KTSlideView alloc] init];
        _slideView.dataSource = self;
        _slideView.delegate = self;
    }
    
    return _slideView;
}

@end
