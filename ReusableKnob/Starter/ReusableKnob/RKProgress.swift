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

//参考原文来自：https://www.scalablepath.com/blog/creating-ios-custom-views-uikit/

@IBDesignable
class RKProgress: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  var view: UIView!
  
  //1. Create an instance of BorderLayer and store it in a constant called ‘darkBorderLayer’.
  
  var darkBorderLayer: RKBorderLayer!
  var progressLayer: RKBorderLayer!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
//  @IBInspectable
  @IBInspectable var title: String = "" {
    didSet {
      titleLabel.text = title;
    }
  }
  
//  @IBInspectable
  @IBInspectable var subtitle: String = "" {
    didSet {
      subtitleLabel.text = subtitle;
    }
  }
  
  //  @IBInspectable
  @IBInspectable var progress: CGFloat = 0.0 {
    didSet {
      progressLayer.endAngle = RKProgress.radianForValue(progress);
      progressLayer.setNeedsDisplay()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadViewFromNib()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadViewFromNib()
  }

  private func loadViewFromNib() {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
    view.frame=bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)
    self.view = view
    
    commonInit()
  }
  
  private func commonInit() {
    //2. Add ‘darkBorderLayer’to the view’s layer.
    darkBorderLayer = RKBorderLayer()
    darkBorderLayer.lineColor = UIColor.lightGray.cgColor
    darkBorderLayer.startAngle = RKProgress.startAngle //0
    darkBorderLayer.endAngle = RKProgress.endAngle //2.0 * CGFloat.pi
    
    
    
    progressLayer = RKBorderLayer()
    progressLayer.lineColor = UIColor.green.cgColor
    progressLayer.startAngle = RKProgress.startAngle //0
    progressLayer.endAngle = RKProgress.endAngle //CGFloat.pi
    self.layer.addSublayer(darkBorderLayer)
    self.layer.addSublayer(progressLayer)
  }
  
  //3. This will override layoutSubviews(). This method is called when all the sizes have been resolved, the size of your view is going to be its final size. So this is the perfect time to set the size of your layer.
  override func layoutSubviews() {
    super.layoutSubviews()
    darkBorderLayer.frame=bounds
    progressLayer.frame=bounds
    //4. Call setNeedsDisplay() to notify the system that the content of the layer needs to be redrawn.
    darkBorderLayer.setNeedsDisplay()
    progressLayer.setNeedsDisplay()
  }
  
  
  static let startAngle = 3/2 * CGFloat.pi
  
  static let endAngle = 7/2 * CGFloat.pi
  
  internal class func radianForValue(_ value: CGFloat) -> CGFloat {
    let realValue = RKProgress.sanitizeValue(value)
    return (realValue * 4/2 * CGFloat.pi / 100) + RKProgress.startAngle
  }
  
  internal class func sanitizeValue(_ value: CGFloat) -> CGFloat {
    var realValue = value
    if value < 0 {
      realValue = 0
    } else if value > 100 {
      realValue = 100
    }
    return realValue
  }
}


class RKBorderLayer: CALayer {
  var lineColor: CGColor = UIColor.blue.cgColor
  var lineWidth: CGFloat = 2.0
  var startAngle: CGFloat = 0.0
  var endAngle: CGFloat = 2.0 * CGFloat.pi
  
  override func draw(in ctx: CGContext) {
    let center = CGPoint(x: bounds.width*0.5, y: bounds.height*0.5)
    ctx.beginPath()
    
    ctx.setStrokeColor(lineColor)
    ctx.setLineWidth(lineWidth)
    ctx.addArc(center: center,
               radius: bounds.width * 0.5 - lineWidth,
               startAngle: startAngle,
               endAngle: endAngle,
               clockwise: false)
    
    ctx.drawPath(using: .stroke)
  }
}


