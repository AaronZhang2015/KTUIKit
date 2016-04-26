//
//  Slide1ViewController.m
//  KTUIKit
//
//  Created by ZhangMing on 4/26/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "Slide1ViewController.h"

@interface Slide1ViewController ()

@end

@implementation Slide1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    NSLog(@"%s", __FUNCTION__);
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __FUNCTION__);
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __FUNCTION__);
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s", __FUNCTION__);
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%s", __FUNCTION__);
}

@end
