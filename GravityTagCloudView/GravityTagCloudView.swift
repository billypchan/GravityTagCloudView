//
//  GravityTagCloudView.swift
//  GravityTagCloudView
//
//  Created by chan bill on 26/2/2017.
//  Copyright © 2017 chan bill. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

open class GravityTagCloudView : UIView {
    
    var labels : [UILabel]! = []

    /**
     *  [String] or [(String, Float)]
     */
    public var titleWeights = [[String:Any]]()

    public enum LabelSizeType {
        case random
        case weighted
    }
    
    /**
     *  Label size option. Defautls to random.
     */
    public var labelSizeType : LabelSizeType = .random

    /**
     *  Gravity enabled?
     */
    public var isGravity : Bool = true

    /**
     *  Min font size. Defautls to 14.
     */
    public var minFontSize : Float = 14
    
    /**
     *  Max font size. Defaults to 60.
     */
    public var maxFontSize : Float = 60
    
    /**
     *  Random text colors with default list
     */
    public var randomColors = [UIColor.black, UIColor.cyan, UIColor.purple, UIColor.orange, UIColor.red, UIColor.yellow, UIColor.lightGray, UIColor.gray, UIColor.green]
    
    /**
     *  Callback. Index start at 0.
     */
    public var tagClickBlock: ((_ title: String, _ index: Int) -> Void)? = nil
    
    var animator:UIDynamicAnimator? = nil;
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    let itemBehavior = UIDynamicItemBehavior()

    //MARK: -  Core Motion
    
    // For getting device motion updates
    let motionQueue = OperationQueue.main
    let motionManager = CMMotionManager()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var isSetup = false
    func setup(){
        if !isSetup {
        self.isUserInteractionEnabled = true
        motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: motionHandler)
        createAnimatorStuff()
        }
        
        isSetup = true
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    func gravityUpdated(motion: CMDeviceMotion?, error: Error?) {
        let grav : CMAcceleration = motion!.gravity;
        
        let x = CGFloat(grav.x);
        let y = CGFloat(grav.y);
        var p = CGPoint(x: x, y: y)
        
        if error != nil
        {
            NSLog("\(error)")
        }
        
        // Have to correct for orientation.
        let orientation = UIApplication.shared.statusBarOrientation;
        
        if(orientation == UIInterfaceOrientation.landscapeLeft) {
            let t = p.x
            p.x = 0 - p.y
            p.y = t
        } else if (orientation == UIInterfaceOrientation.landscapeRight) {
            let t = p.x
            p.x = p.y
            p.y = 0 - t
        } else if (orientation == UIInterfaceOrientation.portraitUpsideDown) {
            p.x *= -1
            p.y *= -1
        }
        
        let v = CGVector(dx: p.x, dy: -p.y)
        gravity.gravityDirection = v;
        
//        print("\(v)")
    }
    
    lazy var motionHandler : CMDeviceMotionHandler = {
        (motion,error) in
        self.gravityUpdated(motion: motion, error: error)
    }
    
    func randomColor() -> UIColor {
        return self.randomColors[ Int(arc4random_uniform(UInt32(self.randomColors.count))) ]
    }
    
    func sizeRatioFont(_ ratio: Float) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(ratio * (self.maxFontSize - self.minFontSize) + self.minFontSize))
    }
    
    func randomFrame(for label: UILabel) -> CGRect {
        label.sizeToFit()
        let maxWidth: CGFloat = self.bounds.size.width - label.bounds.size.width
        let maxHeight: CGFloat = self.bounds.size.height - label.bounds.size.height
        return CGRect(x: CGFloat(arc4random_uniform(UInt32(maxWidth))),
                      y: CGFloat(arc4random_uniform(UInt32(maxHeight))),
                      width: CGFloat(label.bounds.width), height: CGFloat(label.bounds.height))
    }
    
    
    func frameIntersects(_ frame: CGRect) -> Bool {
        for label: UILabel in self.labels {
            if frame.intersects(label.frame) {
                return true
            }
        }
        return false
    }
    
    func handleGesture(_ gestureRecognizer: UIGestureRecognizer) {
        let label: UILabel? = (gestureRecognizer.view as? UILabel)
        if (self.tagClickBlock != nil) {
            self.tagClickBlock!((label?.text)!, (label?.tag)!)
        }
    }
    
    /**
     *   generate tag cloud
     *   @param offset offset of array, default is 0
     *   @param cleanBeforeGenerate clean all tags before generate, set it to false to allow adding addition tags to exist view
     *   @param labelCreatedHandler block calls when every time a tag label is created
     *   @param completionHandler block calls when generation is done. If finished == false, it means not all items in array titleWeights is inserted in the view. Please ref to numLabelAdded to see the number of tags created
     */
    public func generate(_ offset :Int = 0,
                         cleanBeforeGenerate: Bool = true,
                         labelCreatedHandler: ((_ label: UILabel) -> Void)! = nil,
                         completionHandler: ((_ finished: Bool, _ numLabelAdded: Int) -> Void)! = nil) {
        
        if cleanBeforeGenerate {
        labels.forEach { $0.removeFromSuperview() }
        self.labels.removeAll()
        }

        if self.labelSizeType == .weighted {

            let maxWeight = (titleWeights.max { ($0["weight"]as! Int) < ($1["weight"] as! Int)})?["weight"] as! Int
            let minWeight = (titleWeights.min { ($0["weight"]as! Int) < ($1["weight"] as! Int)})?["weight"] as! Int

            let diff: Int = maxWeight - minWeight

            var cnt = 0
            for i in offset...titleWeights.count {
                let titleWeight = titleWeights[i]
                ///TODO: throw
//                assert((titleWeight is [AnyHashable: Any]))
                let label = UILabel()
                label.tag = i
                label.text = (titleWeight["title"] as! String)
                label.textColor = self.randomColor()
                let delta: Int = (titleWeight["weight"] as! Int) - minWeight
                let ratio: Float = Float(delta) / Float(diff)
                label.font = self.sizeRatioFont(ratio)
                
                var cntTry = 0
                repeat {
                    label.frame = self.randomFrame(for: label)
                    
                    
                    if cntTry > 10000 {
                        completionHandler?(false, cnt)
                        return
                    }
                    cntTry += 1
                } while self.frameIntersects(label.frame)
                
                self.labels.append(label)
                self.addSubview(label)
                let tagGestue = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture))
                label.addGestureRecognizer(tagGestue)
                label.isUserInteractionEnabled = true
                
                if let _  = labelCreatedHandler {
                    labelCreatedHandler(label)
                }
                
                if isGravity {
                    addBoxToBehaviors(label)
                }
                
                cnt += 1
            }

            completionHandler?(true, cnt)
        }
    }

    //MARK: - UIDynamicAllocator
    
    func addBoxToBehaviors(_ box: UIView) {
        gravity.addItem(box)
        collider.addItem(box)
        itemBehavior.addItem(box)
    }

    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView:self);
        
        gravity.gravityDirection = CGVector(dx: 0, dy: 0.8)
        animator?.addBehavior(gravity);
        
        // We're bouncin' off the walls
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
        
        itemBehavior.friction = 0.1;
        itemBehavior.elasticity = 0.9
        animator?.addBehavior(itemBehavior)
    }
}
