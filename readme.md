## 原文来自[自定义控件](https://www.raywenderlich.com/2713-how-to-make-a-custom-control)

参考资料

* [uikit](https://developer.apple.com/documentation/uikit)

* [Core Graphics 101 tutorial series](https://www.raywenderlich.com/475829-core-graphics-tutorial-lines-rectangles-and-gradients)

* [How To Make a Custom Control Tutorial: A Reusable Knob](https://www.raywenderlich.com/5294-how-to-make-a-custom-control-tutorial-a-reusable-knob)

UIKit: Construct and manage a graphical, event-driven user interface for your iOS or tvOS app.

## 自定义控件的2种方式

> 方式1、组合现有的UIView来构建新的UIView
> 方式2、重新构建一个新的控件

create it as a custom control.

You could build this range slider by subclassing UIView and creating a bespoke view for visualizing price ranges. That would be fine for the context of your app — but it would be a struggle to port it to other apps.

It’s a much better idea to make this new component generic so that you can reuse it in any context where it’s appropriate. This is the very essence of custom controls.

Custom controls are nothing more than controls that you have created yourself; that is, controls that do not come with the UIKit framework. Custom controls, just like standard controls, should be generic and versatile. As a result, you’ll find there is an active and vibrant community of developers who love to share their custom control creations.



这里讲的是第二种：重新构建一个新的控件

### 第一步是确定如何创建自定义控件

The first decision you need to make when creating a custom control is which existing class to subclass, or extend, in order to make your new control.

Your class must be a UIView subclass in order for it be available in the application’s UI.

### 渲染控件的2种方式：Images vs. CoreGraphics
There are two main ways that you can render controls on-screen:

* Images – create images that represent the various elements of your control
* CoreGraphics – render your control using a combination of layers and CoreGraphics

There are pros and cons to each technique, as outlined below:

* Images — constructing your control using images is probably the simplest option in terms of authoring the control — as long as you can draw! :] If you want your fellow developers to be able to change the look and feel of your control, you would typically expose these images as UIImage properties.

Using images provides the most flexibility to developers who will use your control. Developers can change every single pixel and every detail of your control’s appearance, but this requires good graphic design skills — and it’s difficult to modify the control from code.

* Core Graphics — constructing your control using CoreGraphics means that you have to write the rendering code yourself, which will require a bit more effort. However, this technique allows you to create a more flexible API.

Using Core Graphics, you can parameterize every feature of your control, such as colours, border thickness, and curvature — pretty much every visual element that goes into drawing your control! This approach allows developers who use your control to easily tailor it to their needs.

### 注意事项Note:
Interestingly, Apple tend to opt for using images in their controls. This is most likely because they know the size of each control and don’t tend to want to allow too much customisation. After all, they want all apps to end up with a similar look-and-feel.

### 添加交互逻辑Adding Interactive Logic
The interaction logic needs to store which knob is being dragged, and reflect that in the UI. The control’s layers are a great place to put this logic.

Right-click the CERangeSlider group in the Project Navigator and select New File…. Next, select the iOS\Cocoa Touch\Objective-C class template and add a class called CERangeSliderKnobLayer, making it a subclass of CALayer.

How are you going to track the various touch and release events of your control?

UIControl provides several methods for tracking touches. Subclasses of UIControl can override these methods in order to add their own interaction logic.

### 四种通知方式
There are a number of different patterns that you could implement to provide change notification: NSNotification, Key-Value-Observing (KVO), the delegate pattern, the target-action pattern and many others. There are so many choices!

What to do?

If you look at the UIKit controls, you’ll find they don’t use NSNotification or encourage the use of KVO, so for consistency with UIKit you can exclude those two options. The other two patterns — delegates and target-action patterns — are used extensively in UIKit.

Here’s a detailed analysis of the delegate and the target-action pattern:

* Delegate pattern – With the delegate pattern you provide a protocol which contains a number of methods that are used for a range of notifications. The control has a property, usually named delegate, which accepts any class that implements this protocol. A classic example of this is UITableView which provides the UITableViewDelegate protocol. Note that controls only accept a single delegate instance. A delegate method can take any number of parameters, so you can pass in as much information as you desire to such methods.

* Target-action pattern – The target-action pattern is provided by the UIControl base class. When a change in control state occurs, the target is notified of the action which is described by one of the UIControlEvents enum values. You can provide multiple targets to control actions and while it is possible to create custom events (see UIControlEventApplicationReserved) the number of custom events is limited to 4. Control actions do not have the ability to send any information with the event. So they cannot be used to pass extra information when the event is fired.

The key differences between the two patterns are as follows:

* Multicast — the target-action pattern multicasts its change notifications, while the delegate pattern is bound to a single delegate instance.

* Flexibility — you define the protocols yourself in the delegate pattern, meaning you can control exactly how much information you pass. Target-action provides no way to pass extra information and clients would have to look it up themselves after receiving the event.

Your range slider control doesn’t have a large number of state changes or interactions that you need to provide notifications for. The only things that really change are the upper and lower values of the control.
