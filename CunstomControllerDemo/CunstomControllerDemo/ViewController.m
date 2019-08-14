//
//  ViewController.m
//  CunstomControllerDemo
//
//  Created by zsp on 2019/8/14.
//  Copyright © 2019 woop. All rights reserved.
//

#import "ViewController.h"

#import "CERangeSlider.h"

@interface ViewController ()

@property(nonatomic, strong)CERangeSlider *rangeSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addRangeSlider];
}

- (void)addRangeSlider {
    self.rangeSlider = [[CERangeSlider alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.bounds)-40, 30)];
    [self.rangeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.rangeSlider];
}

- (void)sliderValueChanged:(CERangeSlider*)slider {
    NSLog(@"slider value changed: (%.2f, %.2f)", slider.lowerValue, slider.upperValue);
}
@end
