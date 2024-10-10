//
//  NSView+MBAnimation.swift
//  MBMacKit
//
//  Created by xiaojie li on 2024/8/11.
//

import Foundation
import AppKit
let kDYAnimationKeyLoading = "com.imobie.DYAnimation.key.loadding"
let kMBRecommondAnimationDuration: CFTimeInterval = 0.35
// MARK: - 动画
extension NSView {
    var  anchorPoint : CGPoint {
        get {
            guard let lay = layer else {
                return .zero
            }
            return lay.anchorPoint
        }
        set{
            guard let lay = layer else {
                return
            }
            let oldOrigin = frame.origin
            lay.anchorPoint = newValue
            let newOrigin = frame.origin
            let transition = CGPoint(x: newOrigin.x - oldOrigin.x, y: newOrigin.y - oldOrigin.y)
            lay.position = CGPoint(x: NSMidX(frame) - transition.x, y: NSMidY(frame) - transition.y)
        }
    }
    func anchorCenter () {
        guard let lay = layer else {
            return
        }
        let  centerAC : CGPoint = CGPoint(x: 0.5, y: 0.5)
        guard CGPointEqualToPoint(lay.anchorPoint, centerAC) == false else {
            return
        }
        let frame = lay.frame
        let center = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        lay.position = center
        lay.anchorPoint = centerAC
    }
    
}
// MARK: - CALayer
extension CALayer {
    func move(from value : CGPoint , by byValue : CGPoint? , toValue : CGPoint? , duration : CFTimeInterval? = kMBRecommondAnimationDuration){
        let ani : CAAnimation = MBAnimation.maMoveFrom(value: value, byValue: byValue, toValue: toValue)
        ani.duration = duration!
        add(ani, forKey: nil)
    }
    func moveX(from value : Float , by byValue : Float? , toValue : Float? , duration : CFTimeInterval? = kMBRecommondAnimationDuration){
        let ani : CAAnimation = MBAnimation.mbMoveXFrom(value: value, byValue: byValue, toValue: toValue)
        ani.duration = duration!
        add(ani, forKey: nil)
    }
    func moveY(from value : Float? , by byValue : Float? , toValue : Float? , duration : CFTimeInterval? = kMBRecommondAnimationDuration){
        let ani : CAAnimation = MBAnimation.mbMoveYFrom(value: value, byValue: byValue, toValue: toValue)
        ani.duration = duration!
        add(ani, forKey: nil)
    }
    func rotate(from value : Float , by byValue : Float? , toValue : Float? , duration : CFTimeInterval? = kMBRecommondAnimationDuration){
        let ani : CAAnimation = MBAnimation.mbRotation(value: value, byValue: byValue, toValue: toValue)
        ani.duration = duration!
        add(ani, forKey: nil)
    }
    func bounds(from value : Float , by byValue : Float? , toValue : Float? , duration : CFTimeInterval? = kMBRecommondAnimationDuration){
        let ani : CAAnimation = MBAnimation.mbBounds(value: value, byValue: byValue, toValue: toValue)
        ani.duration = duration!
        add(ani, forKey: nil)
    }
    func scale(from value : Float , by byValue : Float? , toValue : Float? , duration : CFTimeInterval? = kMBRecommondAnimationDuration){
        let ani : CAAnimation = MBAnimation.mbScale(value: value, byValue: byValue, toValue: toValue)
        ani.duration = duration!
        add(ani, forKey: nil)
    }
    func fadeIn(from value : Float , by byValue : Float? , toValue : Float? , duration : CFTimeInterval? = kMBRecommondAnimationDuration){
        let ani : CAAnimation = MBAnimation.mbFadeIn(value: value, byValue: byValue, toValue: toValue)
        ani.duration = duration!
        add(ani, forKey: nil)
    }
    func fadeOut(from value : Float , by byValue : Float? , toValue : Float? , duration : CFTimeInterval? = kMBRecommondAnimationDuration){
        let ani : CAAnimation = MBAnimation.mbFadeOut(value: value, byValue: byValue, toValue: toValue)
        ani.duration = duration!
        add(ani, forKey: nil)
    }
    func transform(from value : Float , by byValue : Float? , toValue : Float? , duration : CFTimeInterval? = kMBRecommondAnimationDuration){
        let ani : CAAnimation = MBAnimation.mbTransform(value: value, byValue: byValue, toValue: toValue)
        ani.duration = duration!
        add(ani, forKey: nil)
    }
    func identify(from value : Float , by byValue : Float? , toValue : CATransform3D? = CATransform3DIdentity , duration : CFTimeInterval? = kMBRecommondAnimationDuration){
        let ani : CAAnimation = MBAnimation.mbIdentify(value: value, byValue: byValue, toValue: toValue)
        ani.duration = duration!
        add(ani, forKey: nil)
    }
}

extension CALayer {
    func shakeX(){
        let ani = CAKeyframeAnimation(keyPath: MBKCategory.positionX.rawValue)
        let originx = self.position.x
        let value = 10.0
        ani.values = [originx , originx - value , originx , originx + value , originx]
        ani.duration = 0.25
        ani.repeatCount = 2
        ani.fillMode = .forwards
        add(ani, forKey: nil)
    }
    func shakeY(){
        let ani = CAKeyframeAnimation(keyPath: MBKCategory.positionX.rawValue)
        let originy = self.position.y
        let value = 10.0
        ani.values = [originy , originy - value , originy , originy + value , originy]
        ani.duration = 0.25
        ani.repeatCount = 2
        ani.fillMode = .forwards
        add(ani, forKey: nil)
    }
    func trembling(){
        guard self.animation(forKey: kDYAnimationKeyLoading)  == nil else {
            print("animation is exist")
            return
        }
        let ani = CAKeyframeAnimation(keyPath: MBKCategory.rotation.rawValue)
        let value = Double.pi / 50
        ani.values = [0 , -value , 0 , value , 0]
        ani.duration = 0.35
        ani.repeatCount = HUGE
        ani.fillMode = .forwards
        ani.isRemovedOnCompletion = false
        add(ani, forKey: kDYAnimationKeyLoading)
    }
    func rotationLoadding(duration : CFTimeInterval){
        guard self.animation(forKey: kDYAnimationKeyLoading)  == nil else {
            print("animation is exist")
            return
        }
        let ani = CABasicAnimation(keyPath: MBKCategory.rotation.rawValue)
        ani.byValue = -2 * Double.pi
        ani.repeatCount = HUGE
        ani.isRemovedOnCompletion = false
        ani.duration = duration
        add(ani, forKey: kDYAnimationKeyLoading)
    }
    func downLoadLoadding(distant : Float , duration : CFTimeInterval) {
        guard self.animation(forKey: kDYAnimationKeyLoading)  == nil else {
            print("animation is exist")
            return
        }
        let ani = CAAnimationGroup()
        let alAni = CABasicAnimation(keyPath: MBKCategory.opacity.rawValue)
        alAni.toValue = 0
        let moveAni = CABasicAnimation(keyPath: MBKCategory.positionY.rawValue)
        moveAni.byValue = distant
        ani.animations = [alAni , moveAni]
        ani.repeatCount = HUGE
        ani.isRemovedOnCompletion = false
        ani.duration = duration
        add(ani, forKey: kDYAnimationKeyLoading)
    }
    func loaddingWithImages(images : [NSImage] , duration : CFTimeInterval){
        guard self.animation(forKey: kDYAnimationKeyLoading)  == nil else {
            print("animation is exist")
            return
        }
        let ani = CAKeyframeAnimation(keyPath: "contents")
        ani.values = images
        ani.duration = duration
        ani.repeatCount = HUGE
        ani.isRemovedOnCompletion = false
        add(ani, forKey: kDYAnimationKeyLoading)
    }
    func fadeInoutLoadingWith(duration : CFTimeInterval){
        guard self.animation(forKey: kDYAnimationKeyLoading)  == nil else {
            print("animation is exist")
            return
        }
        let ani = MBAnimation.mbFadeOut(value: nil, byValue: nil, toValue: 0.0)
        ani.autoreverses = true
        ani.duration = duration
        ani.repeatCount = HUGE
        ani.isRemovedOnCompletion = false
        add(ani, forKey: kDYAnimationKeyLoading)
    }
    func stopLoadding (){
        guard self.animation(forKey: kDYAnimationKeyLoading)  == nil else {
            print("animation is exist")
            return
        }
        removeAnimation(forKey: kDYAnimationKeyLoading)
    }
    
    func scalePrompt(){
        self.scalePromptFrom(rate: 0.5)
    }
    func scalePromptFrom (rate : Float){
        let ani = CASpringAnimation(keyPath: MBKCategory.scale.rawValue)
        ani.duration = 0.5
        ani.mass = 0.5
        ani.damping = 5
        ani.fromValue = rate
        add(ani, forKey: nil)
    }
    func fallPrompt (){
        let ani = CASpringAnimation(keyPath: MBKCategory.positionY.rawValue)
        ani.duration = 1
        ani.mass = 0.5
        ani.damping = 5
        let originY = position.y
        ani.fromValue = originY + (NSHeight(bounds) / 3)
        add(ani, forKey: nil)
    }
}
