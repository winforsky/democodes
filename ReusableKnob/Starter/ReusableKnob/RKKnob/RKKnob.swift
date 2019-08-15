/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class RKKnob: UIControl {
  var minimumValue: Float = 0
  var maximumValue: Float = 1
  
  private (set) var value: Float = 0
  
  func setValue(_ toValue: Float, animated: Bool = false) {
    value = min(maximumValue, max(minimumValue, toValue));
    
    let angleRange = endAngle - startAngle
    let valueRange = maximumValue - minimumValue
    let angleValue = CGFloat(toValue - minimumValue) / CGFloat(valueRange) * angleRange + startAngle
    renderer.setPointerAngle(angleValue)
  }
  
  //持续通知外面数据发生了变化
  var isContinuous = false
  
  private let renderer = RKKnobRenderer()
  
  var lineWidth: CGFloat {
    get {
      return renderer.lineWidth
    }
    set {
      renderer.lineWidth = newValue
    }
  }
  
  var startAngle: CGFloat {
    get {
      return renderer.startAngle
    }
    set {
      renderer.startAngle = newValue
    }
  }
  
  var endAngle: CGFloat {
    get {
      return renderer.endAngle
    }
    set {
      renderer.endAngle = newValue
    }
  }
  
  var pointerLength: CGFloat {
    get {
      return renderer.pointerLength
    }
    set {
      renderer.pointerLength = newValue
    }
  }

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    backgroundColor = .brown
    renderer.updateBounds(bounds)
    renderer.color = tintColor
    renderer.setPointerAngle(renderer.startAngle)
    
    layer.addSublayer(renderer.trackLayer)
    layer.addSublayer(renderer.pointLayer)
    
    let gestureRecognizer = RKRotationGestureRecognizer(target: self, action: #selector(RKKnob.hangleGesture(_:)))
    addGestureRecognizer(gestureRecognizer)
  }
  
  
  @objc private func hangleGesture(_ gesture: RKRotationGestureRecognizer) {
    //1
    let midPointAngle = (2 * CGFloat(Double.pi) + startAngle - endAngle) * 0.5 + endAngle
    
    //2
    var boundedAngle = gesture.touchAngle
    
    if boundedAngle > midPointAngle {
      boundedAngle -= 2 * CGFloat(Double.pi)
    }else if boundedAngle < (midPointAngle - 2 * CGFloat(Double.pi)) {
      boundedAngle -= 2 * CGFloat(Double.pi)
    }
    
    //3
    boundedAngle = min(endAngle, max(startAngle, boundedAngle))
    
    //4
    let angleRange = endAngle - startAngle
    let valueRange = maximumValue - minimumValue
    let angleValue = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
    
    //5
    setValue(angleValue)
    
    if isContinuous {
      sendActions(for: .valueChanged)
    } else {
      if gesture.state == .ended || gesture.state == .cancelled {
        sendActions(for: .valueChanged)
      }
    }
  }
}


private class RKKnobRenderer {
  
  var color: UIColor = .blue {
    didSet {
      trackLayer.strokeColor = color.cgColor
      pointLayer.strokeColor = color.cgColor
    }
  }
  
  var lineWidth: CGFloat = 2 {
    didSet {
      trackLayer.lineWidth = lineWidth
      pointLayer.lineWidth = lineWidth
      updateTrackLayerPath()
      updatePointLayerPath()
    }
  }
  
  var startAngle: CGFloat = CGFloat( -Double.pi ) * 11 / 8 {
    didSet {
      updateTrackLayerPath()
    }
  }
  
  var endAngle: CGFloat = CGFloat( Double.pi ) * 3 / 8 {
    didSet {
      updateTrackLayerPath()
    }
  }
  
  var pointerLength: CGFloat = 6 {
    didSet {
      updateTrackLayerPath()
      updatePointLayerPath()
    }
  }
  
  private (set) var pointerAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8
  
  func setPointerAngle(_ toPointAngle: CGFloat, animated: Bool = false) {
 /*
     The transform property of CALayer expects to be passed a CATransform3D, not a CGAffineTransform like UIView. This means that you can perform transformations in three dimensions.
     
     CGAffineTransform uses a 3×3 matrix and CATransform3D uses a 4×4 matrix; the addition of the z-axis requires the extra values. At their core, 3D transformations are simply matrix multiplications. You can read more about matrix multiplication in this Wikipedia article.
 */
    CATransaction.begin()
    
    CATransaction.setDisableActions(true)
    pointLayer.transform = CATransform3DMakeRotation(toPointAngle, 0, 0, 1)
    
    if animated {
      let midAngleValue = (max(toPointAngle, pointerAngle) - min(toPointAngle, pointerAngle)) * 0.5
      let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
      animation.values=[pointerAngle, midAngleValue, toPointAngle]
      animation.keyTimes = [0.0, 0.5, 1.0]
      animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
      pointLayer.add(animation, forKey: nil)
    }
    
    CATransaction.commit()
    
    pointerAngle = toPointAngle;
  }
  
  init() {
    trackLayer.fillColor = UIColor.clear.cgColor
    pointLayer.fillColor = UIColor.clear.cgColor
  }
  
  private func updateTrackLayerPath() {
    let bounds = trackLayer.bounds
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let offset = max(pointerLength, lineWidth * 0.5)
    let radius = min(bounds.width, bounds.height) * 0.5 - offset
    let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    trackLayer.path = ring.cgPath
  }
  
  private func updatePointLayerPath() {
    let bounds = trackLayer.bounds
    let pointer = UIBezierPath()
    pointer.move(to: CGPoint(x: bounds.width - CGFloat(pointerLength) - CGFloat(lineWidth) * 0.5, y: bounds.midY))
    pointer.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
    pointLayer.path = pointer.cgPath
  }
  
  func updateBounds(_ bounds: CGRect) {
    trackLayer.bounds = bounds
    trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    updateTrackLayerPath()
    
    pointLayer.bounds = trackLayer.bounds
    pointLayer.position = trackLayer.position
    updatePointLayerPath()
  }
  
  let trackLayer = CAShapeLayer()
  let pointLayer = CAShapeLayer()
}


/*
 The import is necessary so you can override some gesture recognizer methods later.
 
 Note: You might be wondering why you’re adding all these private classes to Knob.swift rather than the usual one-class-per-file. For this project, it makes it easy to distribute just a single file to anyone who wants to use this simple control.
 */

import UIKit.UIGestureRecognizerSubclass

private class RKRotationGestureRecognizer: UIPanGestureRecognizer {
  private (set) var touchAngle: CGFloat = 0
  
  override init(target: Any?, action: Selector?) {
    super.init(target: target, action: action)
    maximumNumberOfTouches = 1
    minimumNumberOfTouches = 1
  }
  
  /*
   There are three methods of interest when subclassing UIGestureRecognizer: they represent the time that the touches begin, the time they move and the time they end. You’re only interested when the gesture starts and when the user’s finger moves on the screen.
   */
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)
    updateAngle(touches)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    updateAngle(touches)
  }
  
  private func updateAngle(_ touches: Set<UITouch>) {
    guard let touch = touches.first, let view = view else {
      return
    }
    
    let touchPoint = touch.location(in: view)
    touchAngle = angle(for: touchPoint, in: view);
  }
  
  private func angle(for point: CGPoint, in view: UIView)->CGFloat {
    let centerOffset = CGPoint(x: (point.x - view.bounds.midX), y: (point.y - view.bounds.midY))
    return atan2(centerOffset.y, centerOffset.x)
  }
}
