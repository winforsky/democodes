//
//  CERangeSlider.m
//  CunstomControllerDemo
//
//  Created by zsp on 2019/8/14.
//  Copyright © 2019 woop. All rights reserved.
//

#import "CERangeSlider.h"
#import <QuartzCore/QuartzCore.h>

#import "CERangeSliderTrackLayer.h"
#import "CERangeSliderKnobLayer.h"

#define BOUND(VALUE, UPPER, LOWER) MIN(MAX(VALUE, LOWER), UPPER)

@interface CERangeSlider () {
    CERangeSliderTrackLayer* _trackLayer;
    CERangeSliderKnobLayer* _upperKnobLayer;
    CERangeSliderKnobLayer* _lowerKnobLayer;
    
    float _knobWidth;
    float _useableTrackLength;
    CGPoint _previousTouchPoint;
}
@end

@implementation CERangeSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        _maximumValue = 10.0f;
        _minimumValue = 0.0f;
        _upperValue = 8.0f;
        _lowerValue = 2.0f;
        
        _trackLayer = [CERangeSliderTrackLayer layer];
        _trackLayer.slider=self;
        _trackLayer.backgroundColor = [UIColor blueColor].CGColor;
        [self.layer addSublayer:_trackLayer];
        
        _upperKnobLayer = [CERangeSliderKnobLayer layer];
        _upperKnobLayer.slider = self;
        _upperKnobLayer.backgroundColor = [UIColor greenColor].CGColor;
        [self.layer addSublayer:_upperKnobLayer];
        
        _lowerKnobLayer = [CERangeSliderKnobLayer layer];
        _lowerKnobLayer.slider = self;
        _lowerKnobLayer.backgroundColor = [UIColor greenColor].CGColor;
        [self.layer addSublayer:_lowerKnobLayer];
        
        [self setLayerFrames];
    }
    return self;
}

- (void)setLayerFrames {
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    
    _trackLayer.frame=CGRectInset(self.bounds, 0, height*0.3);
    
    _knobWidth = height;
    _useableTrackLength = width - _knobWidth;
    
    float upperKnobCentre = [self positionForValue:_upperValue];
    _upperKnobLayer.frame = CGRectMake(upperKnobCentre - _knobWidth*0.5, 0, _knobWidth, _knobWidth);
    
    float lowerKnobCentre = [self positionForValue:_lowerValue];
    _lowerKnobLayer.frame = CGRectMake(lowerKnobCentre - _knobWidth*0.5, 0, _knobWidth, _knobWidth);
    
    [_trackLayer setNeedsDisplay];
    [_upperKnobLayer setNeedsDisplay];
    [_lowerKnobLayer setNeedsDisplay];
}

- (float)positionForValue:(float)value {
    return _useableTrackLength * (value - _minimumValue) / (_maximumValue - _minimumValue) + (_knobWidth * 0.5);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _previousTouchPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(_lowerKnobLayer.frame, _previousTouchPoint)) {
        _lowerKnobLayer.highlighted = YES;
        [_lowerKnobLayer setNeedsDisplay];
    }else if (CGRectContainsPoint(_upperKnobLayer.frame, _previousTouchPoint)) {
        _upperKnobLayer.highlighted = YES;
        [_upperKnobLayer setNeedsDisplay];
    }
    return _upperKnobLayer.highlighted || _lowerKnobLayer.highlighted;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    
    //1、通过拖动的相对距离来计算值的变化
    float delta = touchPoint.x - _previousTouchPoint.x;
    float valueDelta = (_maximumValue - _minimumValue) * delta / _useableTrackLength;
    
    _previousTouchPoint = touchPoint;
    
    //2、更新数值
    if (_lowerKnobLayer.highlighted) {
        _lowerValue += valueDelta;
        _lowerValue = [self boundFor:_lowerValue max:_upperValue min:_minimumValue];
    }
    
    if (_upperKnobLayer.highlighted) {
        _upperValue += valueDelta;
        _upperValue = [self boundFor:_upperValue max:_maximumValue min:_lowerValue];
    }
    
    //3、更新UI的显示状态
    [CATransaction begin];
    
    //This ensures that the changes to the frame for each layer are applied immediately, and not animated.
    [CATransaction setDisableActions:YES];
    
    [self setLayerFrames];
    
    [CATransaction commit];
     
    //通知外部数据发生了变化
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _lowerKnobLayer.highlighted = _upperKnobLayer.highlighted = NO;
    [_lowerKnobLayer setNeedsDisplay];
    [_upperKnobLayer setNeedsDisplay];
}

- (float)boundFor:(CGFloat)value max:(CGFloat)maxValue min:(CGFloat)minValue {
    return MIN(MAX(value, minValue), maxValue);
}

@end
