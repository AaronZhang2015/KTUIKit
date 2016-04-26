//
//  Slide2ViewController.m
//  KTUIKit
//
//  Created by ZhangMing on 4/26/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "Slide2ViewController.h"

@interface Slide2ViewController ()

@end

@implementation Slide2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
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
