//
//  MBTipView.swift
//  MBMacKit
//
//  Created by xiaojie li on 2024/9/5.
//

import Foundation
import AppKit
public struct TipViewKey {
    public enum TipViewAlignment : Hashable {
        case top
        case middle
        case bottom
        
    }
    public var superview : NSView?
    public var aligment : TipViewAlignment? = .top
    init(superview: NSView? = nil, aligment: TipViewAlignment? = .top) {
        self.superview = superview
        self.aligment = aligment
    }
}
public class MBTipView : NSObject {
    static private var tipViewArr : [(String,TipViewKey?)] = []
    static private var tipView : SCTipView?
    static private var currentTipKey : TipViewKey?

    /// 显示方法
    static public func showTitle(_ title : String , positionView : NSView? = nil , position : TipViewKey.TipViewAlignment? = .top ) {
        if tipView == nil || tipView?.superview == nil {
            tipView = SCTipView.showTitle(title)
            if positionView != nil  {
                currentTipKey = TipViewKey(superview: positionView, aligment: position)
            }else{
                currentTipKey = nil
            }
            show(title)
        }else{//存在
            if positionView != nil {
                tipViewArr.append((title , TipViewKey(superview: positionView, aligment: position)))
            }else{
                tipViewArr.append((title , nil))
            }
        }
        
    }

    /// 显示方法
    static private func show(_ title : String ) {
        guard let tip = tipView else { return }
        if self.currentTipKey == nil {//为空 默认 root window 最上方
            if let contentView = NSApplication.shared.keyWindow?.contentView {
                contentView.addSubview(tip)
                tip.wantsLayer = true
                tip.layer?.backgroundColor = NSColor.black.cgColor
                tip.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50).isActive = true
                tip.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true 
                tip.layer?.moveY(from: Float(NSMaxY(contentView.frame) - 50 + tip.fittingSize.height), by: nil, toValue: nil)
    //                self.perform(#selector(showNext), with: self, afterDelay: 4.0)
                self.perform(#selector(showNext), with: self, afterDelay: 4.0, inModes: [.common])
            }
        }else{//to view 不为空
            if  let to = self.currentTipKey?.superview , let toWindow = to.window  {// window 存在
                let position = self.currentTipKey?.aligment ?? .top
                if let contentView = toWindow.contentView {
                    var isNeedAnimation = false
                    if tip.superview == nil {
                        contentView.addSubview(tip)
                        isNeedAnimation = true
                    }
                    tip.wantsLayer = true
                    tip.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.3).cgColor
                    tip.layer?.masksToBounds = true
                    tip.layer?.cornerRadius = 8
                    tip.titleLa.stringValue = title
                    tip.translatesAutoresizingMaskIntoConstraints = false
                     switch position {
                    case .top:
                         tip.removeAllConstraint()
                         NSLayoutConstraint.activate([
                            tip.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
                            tip.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                            tip.heightAnchor.constraint(equalToConstant: tip.stack.fittingSize.height + 27),
                            tip.widthAnchor.constraint(equalToConstant: tip.stack.fittingSize.width + 48)
                         ])
                        break
                    case .middle:
                         tip.removeAllConstraint()
                         NSLayoutConstraint.activate([
                         tip.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                         tip.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                         tip.heightAnchor.constraint(equalToConstant: tip.stack.fittingSize.height + 27),
                         tip.widthAnchor.constraint(equalToConstant: tip.stack.fittingSize.width + 48)
                         ])
                        break
                    case .bottom:
                         tip.removeAllConstraint()
                         NSLayoutConstraint.activate([
                         tip.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                         tip.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: 20),
                         tip.heightAnchor.constraint(equalToConstant: tip.stack.fittingSize.height + 27),
                         tip.widthAnchor.constraint(equalToConstant: tip.stack.fittingSize.width + 48)
                         ])
                        break
                    }
                    tip.superview?.layoutSubtreeIfNeeded()
                    if isNeedAnimation == true {
                         tip.layer?.moveY(from: Float(NSMaxY(tip.frame) + tip.fittingSize.height), by: nil, toValue: nil, duration: 0.1)
                    }
                    self.perform(#selector(showNext), with: self, afterDelay: 4.0, inModes: [.common])
                }else{
                    showNext()
                }
            }else{
                showNext()
            }
        }
    }
    /// dismiss 方法
    @objc static fileprivate func dimiss() {
        guard let tip = tipView else { return  }
        tip.layer?.moveY(from:nil , by: nil, toValue: Float(NSMaxY(tip.frame) + tip.fittingSize.height), duration: 0.1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            tipView?.removeFromSuperview()
            tipView = nil
        })
    }
    /// 更换下一组的方法
    @objc static fileprivate func showNext() {
        if tipViewArr.count <= 0 {
            dimiss()
        }else{
            if let showContent = tipViewArr.first {
                tipViewArr.removeFirst()
                self.currentTipKey = showContent.1
                show(showContent.0)
            }
        }
    }


}


class SCTipView: NSView {
      var imageBgView : NSView!
      var image : NSImageView!
      var titleLa : NSTextField!
      var stack : NSStackView!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    // 自定义初始化
       override init(frame frameRect: NSRect) {
           // 调用父类的指定初始化方法
           super.init(frame: frameRect)
           // 自定义代码
           initView()
           updateConstrians()
           
       }
    func initView(){
        imageBgView = NSView()
        image = NSImageView()
        stack = NSStackView()
        stack.spacing = 8
        titleLa = NSTextField()
        titleLa.isEditable = false
        titleLa.alignment = .center
        titleLa.isBordered = false
        titleLa.isEditable = false
        titleLa.isBezeled = false
        titleLa.isSelectable = false
        titleLa.drawsBackground = false
        titleLa.lineBreakMode = .byWordWrapping
        addSubview(stack)
        stack.addArrangedSubview(imageBgView)
        imageBgView.addSubview(image)
        stack.addArrangedSubview(titleLa)
    }
    func updateConstrians(){
        stack.translatesAutoresizingMaskIntoConstraints = false
        imageBgView.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        titleLa.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 13.5),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13.5),
            stack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
            stack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
            
            imageBgView.widthAnchor.constraint(equalToConstant: 24),
            imageBgView.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
            
            image.centerXAnchor.constraint(equalTo: imageBgView.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: imageBgView.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 24),
            image.heightAnchor.constraint(equalToConstant: 24),
            
            titleLa.topAnchor.constraint(equalTo: stack.topAnchor, constant: 2.5),
            titleLa.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: -2.5),
            titleLa.rightAnchor.constraint(equalTo: stack.rightAnchor, constant: 0),
            titleLa.leftAnchor.constraint(equalTo: imageBgView.rightAnchor, constant: 8)
        ])
        
        layoutSubtreeIfNeeded()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI(){
        wantsLayer = true
        layer?.masksToBounds = true
        layer?.cornerRadius = 12
        layer?.backgroundColor = NSColor.black.withAlphaComponent(0.85).cgColor
        image.image = NSImage(named: "FeedbackTips_hint")
        titleLa.font = NSFont.systemFont(ofSize: 14)
        titleLa.textColor = NSColor.white
    }
    static func showTitle(_ title : String) -> SCTipView{
        let view = SCTipView.init(frame: .init(x: 0, y: 0, width: 284, height: 48))
        view.titleLa.stringValue = title
        view.needsDisplay = true
        view.titleLa.preferredMaxLayoutWidth = 70
        return view
     }
}
