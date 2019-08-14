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

@property(nonatomic, assign)float maximumValue;
@property(nonatomic, assign)float minimumValue;
@property(nonatomic, assign)float upperValue;
@property(nonatomic, assign)float lowerValue;

@end

NS_ASSUME_NONNULL_END
