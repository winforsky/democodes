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
  
  let darkBorderLayer = RKBorderLayer()
  
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
    self.layer.addSublayer(self.darkBorderLayer)
  }
  
  //3. This will override layoutSubviews(). This method is called when all the sizes have been resolved, the size of your view is going to be its final size. So this is the perfect time to set the size of your layer.
  override func layoutSubviews() {
    super.layoutSubviews()
    darkBorderLayer.frame=bounds
    //4. Call setNeedsDisplay() to notify the system that the content of the layer needs to be redrawn.
    darkBorderLayer.setNeedsDisplay()
  }
}


class RKBorderLayer: CALayer {
  
  override func draw(in ctx: CGContext) {
    let lineWidth: CGFloat = 2.0
    let center = CGPoint(x: bounds.width*0.5, y: bounds.height*0.5)
    
    ctx.beginPath()
    
    ctx.setStrokeColor(UIColor.blue.cgColor)
    ctx.setLineWidth(lineWidth)
    ctx.addArc(center: center,
               radius: bounds.width * 0.5 - lineWidth,
               startAngle: 0,
               endAngle: 2.0 * CGFloat.pi,
               clockwise: false)
    
    ctx.drawPath(using: .stroke)
  }
}
