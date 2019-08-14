//
//  CERangeSliderKnobLayer.h
//  CunstomControllerDemo
//
//  Created by zsp on 2019/8/14.
//  Copyright © 2019 woop. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@class CERangeSlider;

@interface CERangeSliderKnobLayer : CALayer

@property(nonatomic, assign)BOOL highlighted;
@property(nonatomic, weak)CERangeSlider* slider;

@end

NS_ASSUME_NONNULL_END
