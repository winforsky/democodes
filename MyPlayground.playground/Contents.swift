//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class CustomView : UIView {
    
    private var headerViewTopConstraint: NSLayoutConstraint?
    
    lazy var addButton: UIButton = {
        let addButton = UIButton(type: .contactAdd)
        addButton.frame = CGRect(x: 265, y: 5, width: 30, height: 30)
        return addButton
    }()
    
    lazy var contentImageView: UIImageView = {
        let contentImageView = UIImageView(frame: CGRect(x: 0, y: 40, width: 300, height: 260))
        contentImageView.image = UIImage(named: "WoodText")
        return contentImageView
    }()
    
    lazy var headerTitleLabel: UILabel = {
        let headerTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        headerTitleLabel.font = UIFont.systemFont(ofSize:22, weight: .medium)
        headerTitleLabel.textAlignment = .center
        return headerTitleLabel
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        headerView.backgroundColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 0.5)
        headerView.layer.shadowColor = UIColor.gray.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        headerView.layer.shadowOpacity = 1
        headerView.layer.shadowRadius = 5
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(addButton)
        
        return headerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .red
        addSubview(contentImageView)
        addSubview(headerView)
        setupAction()
    }
    
    private func setupAction() {
        addButton.addTarget(self, action: #selector(moveHeaderView), for: .touchUpInside)
    }
    
    @objc private func moveHeaderView() {
        //更新headerView的约束
        
        //方法1:手动更新layout并强制更新布局【简单、首选】
        //设置需要更新布局
//        headerViewTopConstraint?.constant += 10
//        setNeedsLayout()
//        没有这一句则约束的改变在下一轮刷新时生效
//        layoutIfNeeded()
        
        //方法2:【性能提升】
//        headerViewTopConstant = headerViewTopConstant + (10 as! CGFont)
    }
    
    private var headerViewTopConstant: CGFont = 0.0 as! CGFont {
        didSet {
            //设置完成之后提示需要更新约束
            setNeedsUpdateConstraints()
//            没有这一句则约束的改变在下一轮刷新时生效
//            updateConstraintsIfNeeded()
        }
    }
    
    override func updateConstraints() {
        //误区，通常认为在这里添加或设置初始的约束,其实不用
        //只有在 1）改变当前约束太慢时 或 2）视图正在产生大量冗余的改变时使用
        
        //方法2:【性能提升】
//        headerViewTopConstraint?.constant = headerViewTopConstant
        super.updateConstraints()
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
        
        let customeView =  CustomView (frame: CGRect(x: 10, y: 10, width: 300, height: 300))
        self.view.addSubview(customeView)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
