//
//  SnowFallingView.swift
//  SnowFalling
//
//  Created by pixyzehn on 2/11/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

public let kDefaultFlakeFileName               = "snowflake"
public let kDefaultFlakesCount                 = 200
public let kDefaultFlakeWidth: Float           = 40.0
public let kDefaultFlakeHeight: Float          = 46.0
public let kDefaultMinimumSize: Float          = 0.4
public let kDefaultMaximumSize: Float          = 0.8
public let kDefaultAnimationDurationMin: Float = 6.0
public let kDefaultAnimationDurationMax: Float = 12.0

public class SnowFallingView: UIView {
    
    public var flakesCount = 0
    public var flakeFileName = ""
    public var flakeWidth: Float = 0
    public var flakeHeight: Float = 0
    public var flakeMinimumSize: Float = 0
    public var flakeMaximumSize: Float = 0
    
    public var animationDurationMin: Float = 0
    public var animationDurationMax: Float = 0
    
    public var flakesArray = [UIImageView]()
    public var initialFlakesArray = [UIImageView]()
    
    public var shouldStartFromTop = false
    private var initialSetup = true
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds             = true
        self.flakeFileName        = kDefaultFlakeFileName
        self.flakesCount          = kDefaultFlakesCount
        self.flakeWidth           = kDefaultFlakeWidth
        self.flakeHeight          = kDefaultFlakeHeight
        self.flakeMinimumSize     = kDefaultMinimumSize
        self.flakeMaximumSize     = kDefaultMaximumSize
        self.animationDurationMin = kDefaultAnimationDurationMin
        self.animationDurationMax = kDefaultAnimationDurationMax
        
        backgroundColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func createFlakes(count: Int) -> [UIImageView] {
        var array = [UIImageView]()
        guard let flakeImage = UIImage(named: flakeFileName) else {
            return array
        }
        for _ in 0..<count {
            var vz: Float = 1.0 * Float(arc4random()) / Float(RAND_MAX)
            vz = vz < flakeMinimumSize ? flakeMinimumSize : vz
            vz = vz > flakeMaximumSize ? flakeMaximumSize : vz
            
            let vw = flakeWidth * vz
            let vh = flakeHeight * vz
            
            var vx = Float(frame.size.width) * Float(arc4random()) / Float(RAND_MAX)
            var vy = Float(frame.size.height) * 1.5 * Float(arc4random()) / Float(RAND_MAX)
            
            vy += Float(frame.size.height)
            vx -= vw
            
            let imageView = UIImageView(image: flakeImage)
            imageView.frame = CGRect(x: CGFloat(vx), y: CGFloat(vy), width: CGFloat(vw), height: CGFloat(vh))
            imageView.isUserInteractionEnabled = false
            array.append(imageView)
            addSubview(imageView)
        }
        return array
    }
    
    public func startSnow() {
        if !shouldStartFromTop, initialSetup {
            initialFlakes()
        }
        initialSetup = false
        
        if flakesArray.isEmpty {
            flakesArray = createFlakes(count: flakesCount)
        }
        
        let rotAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotAnimation.repeatCount = Float.infinity
        rotAnimation.autoreverses = false
        rotAnimation.toValue = 6.28318531
        rotAnimation.isRemovedOnCompletion = false
        
        let theAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        theAnimation.repeatCount = Float.infinity
        theAnimation.autoreverses = false
        theAnimation.isRemovedOnCompletion = false
        
        for v in flakesArray {
            var p = v.center
            let startypos = p.y
            let endypos = frame.size.height
            p.y = endypos
            v.center = p
            let timeInterval: Float = (animationDurationMax - animationDurationMin) * Float(arc4random()) / Float(RAND_MAX)
            theAnimation.duration = CFTimeInterval(timeInterval + animationDurationMin)
            theAnimation.fromValue = -startypos
            v.layer.add(theAnimation, forKey: "transform.translation.y")
            
            rotAnimation.duration = CFTimeInterval(timeInterval)
            v.layer.add(rotAnimation, forKey: "transform.rotation.y")
        }
    }
    
    public func initialFlakes() {
        if initialFlakesArray.isEmpty {
            initialFlakesArray = createFlakes(count: 50)
        }
        
        let rotAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotAnimation.repeatCount = Float.infinity
        rotAnimation.autoreverses = false
        rotAnimation.toValue = 6.28318531
        rotAnimation.isRemovedOnCompletion = false
        
        let theAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        theAnimation.autoreverses = false
        theAnimation.isRemovedOnCompletion = false
        theAnimation.delegate = self
        
        for v in initialFlakesArray {
            let startypos = Int(arc4random_uniform(UInt32(frame.size.height)))
            v.center.y = frame.size.height
            let timeInterval: Float = (animationDurationMax - animationDurationMin) * Float(arc4random()) / Float(RAND_MAX)
            theAnimation.duration = CFTimeInterval(timeInterval + animationDurationMin) * 0.5
            theAnimation.fromValue = -startypos
            v.layer.add(theAnimation, forKey: "transform.translation.y")
            
            rotAnimation.duration = CFTimeInterval(timeInterval)
            v.layer.add(rotAnimation, forKey: "transform.rotation.y")
        }
    }
    
    public func stopSnow() {
        for v in flakesArray {
            v.layer.removeAllAnimations()
        }
        flakesArray.removeAll()
    }
}

extension SnowFallingView : CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        for image in initialFlakesArray {
            if anim == image.layer.animation(forKey: "transform.translation.y") {
                image.removeFromSuperview()
                if let index = initialFlakesArray.index(of: image) {
                    initialFlakesArray.remove(at: index)
                }
                return
            }
        }
    }
}


