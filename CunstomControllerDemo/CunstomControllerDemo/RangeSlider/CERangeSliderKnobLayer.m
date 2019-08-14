//
//  CERangeSliderKnobLayer.m
//  CunstomControllerDemo
//
//  Created by zsp on 2019/8/14.
//  Copyright © 2019 woop. All rights reserved.
//

#import "CERangeSliderKnobLayer.h"

#import "CERangeSlider.h"

@implementation CERangeSliderKnobLayer

- (void)drawInContext:(CGContextRef)ctx {
    CGRect knobFrame = CGRectInset(self.bounds, 2.0, 2.0);
    
    //1、fill with a subtle shadow
    UIBezierPath *knobPath = [UIBezierPath bezierPathWithRoundedRect:knobFrame cornerRadius:CGRectGetHeight(knobFrame)*self.slider.curvaceousness*0.5];
    CGContextSetFillColorWithColor(ctx, self.slider.knobColor.CGColor);
    CGContextAddPath(ctx, knobPath.CGPath);
    CGContextFillPath(ctx);
    
    //2、outline
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextAddPath(ctx, knobPath.CGPath);
    CGContextStrokePath(ctx);
    
    //3、inner gradient
    CGRect rect = CGRectInset(knobFrame, 2.0, 2.0);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetHeight(rect)*self.slider.curvaceousness*0.5];
    CGGradientRef myGradient;
    CGColorSpaceRef myColorSpace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {
        0.0, 0.0, 0.0, 0.15,//start color
        0.0, 0.0, 0.0, 0.05,//end color
    };
    
    myColorSpace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, num_locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, clipPath.CGPath);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, myGradient, startPoint, endPoint, 0);
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorSpace);
    CGContextRestoreGState(ctx);
    
    if (self.highlighted) {
        //4、fill
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.0 alpha:0.1].CGColor);
        CGContextAddPath(ctx, knobPath.CGPath);
        CGContextFillPath(ctx);
    }
    
}

@end
