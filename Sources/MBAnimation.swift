//
//  MBAnimation.swift
//  MBMacKit
//
//  Created by xiaojie li on 2024/8/10.
//

import Foundation
import QuartzCore
enum MBKCategory : String {
    case rotation = "transform.rotation"
    case position = "position"
    case positionX = "position.x"
    case positionY = "position.y"
    case bounds = "bounds"
    case scale = "transform.scale"
    case opacity = "opacity"
    case translate = "transform"
}
@objc class MBAnimation : NSObject{
    // MARK: - 方法
    class func mAFrom(category :  MBKCategory) -> CABasicAnimation {
        let ani : CABasicAnimation = CABasicAnimation.init(keyPath: category.rawValue)
        ani.isRemovedOnCompletion = false
        ani.fillMode = .forwards
        ani.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return ani
    }
    class func _ma(ani : CABasicAnimation , from : Any? , by : Any? , to: Any?) {
        ani.fromValue = from
        ani.byValue = by
        ani.toValue = to
    }
}
 // MARK: - move
extension MBAnimation {
    class func maMoveFrom(value : CGPoint? , byValue : CGPoint? = nil, toValue : CGPoint? = nil) -> CABasicAnimation{
        let ani = mAFrom(category: .position)
        _ma(ani: ani , from: value, by: byValue, to: toValue)
        return ani
    }
      class func mbMoveXFrom(value : Float, byValue : Float? = nil , toValue : Float? = nil ) -> CABasicAnimation{
        let ani = mAFrom(category: .positionX)
        _ma(ani: ani , from: value, by: byValue, to: toValue)
        return ani
    }
    class func mbMoveYFrom(value : Float?, byValue : Float? = nil , toValue : Float? = nil) -> CABasicAnimation{
        let ani = mAFrom(category: .positionY)
        _ma(ani: ani , from: value, by: byValue, to: toValue)
        return ani
    }
}
 // MARK: - rotation
extension MBAnimation {
    class func mbRotation(value : Float , byValue : Float? = nil, toValue :Float? = nil) -> CABasicAnimation {
        let ani = mAFrom(category: .rotation)
        _ma(ani: ani , from: value, by: byValue, to: toValue)
        return ani
    }
}
 // MARK: - bounds
extension MBAnimation {
    class func mbBounds(value : Float , byValue : Float? = nil, toValue :Float? = nil) -> CABasicAnimation {
        let ani = mAFrom(category: .bounds)
        _ma(ani: ani , from: value, by: byValue, to: toValue)
        return ani
    }
}
 // MARK: - scale
extension MBAnimation {
    class func mbScale(value : Float , byValue : Float? = nil, toValue :Float? = nil) -> CABasicAnimation {
        let ani = mAFrom(category: .scale)
        _ma(ani: ani , from: value, by: byValue, to: toValue)
        return ani
    }
}
 // MARK: - opcity
extension MBAnimation {
    class func mbFadeOut(value : Float? = nil , byValue : Float? = nil, toValue : Float? = 0.0) -> CABasicAnimation{
        let ani = mAFrom(category: .opacity)
        _ma(ani: ani , from: value, by: byValue, to: toValue)
        return ani
    }
  class func mbFadeIn(value : Float? = nil, byValue : Float? = nil, toValue : Float? = 1.0) -> CABasicAnimation{
        let ani = mAFrom(category: .opacity)
        _ma(ani: ani , from: value, by: byValue, to: toValue)
        return ani
    }

}
 // MARK: - translate
extension MBAnimation {
    class func mbTransform(value : Float? , byValue : Float?, toValue : Float? = 0.0) -> CABasicAnimation{
        let ani = mAFrom(category: .opacity)
        _ma(ani: ani , from: value, by: byValue, to: toValue)
        return ani
    }
    class func mbIdentify(value : Float?, byValue : Float?, toValue : CATransform3D? = CATransform3DIdentity) -> CABasicAnimation{
        let ani = mAFrom(category: .opacity)
        _ma(ani: ani , from: value, by: byValue, to: toValue)
        return ani
    }

}
