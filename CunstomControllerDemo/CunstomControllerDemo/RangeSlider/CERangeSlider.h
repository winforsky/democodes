//
//  CERangeSlider.h
//  CunstomControllerDemo
//
//  Created by zsp on 2019/8/14.
//  Copyright © 2019 woop. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CERangeSlider : UIControl

@property(nonatomic, strong)UIColor* trackColor;
@property(nonatomic, strong)UIColor* trackHighlightColor;
@property(nonatomic, strong)UIColor* knobColor;
@property(nonatomic, assign)float curvaceousness;

@property(nonatomic, assign)float maximumValue;
@property(nonatomic, assign)float minimumValue;
@property(nonatomic, assign)float upperValue;
@property(nonatomic, assign)float lowerValue;

- (float)positionForValue:(float)value;

@end

NS_ASSUME_NONNULL_END
