//
//  SmileView.swift
//  Smile
//
//  Created by Derex on 2/5/16.
//  Copyright © 2016 Derex. All rights reserved.
//

import UIKit

protocol FaceViewDateSource: class {
    func smilinessForFaceView(sender: SmileView) -> Double?
}
@IBDesignable
class SmileView: UIView {
    var faceCenter:CGPoint {
        return convertPoint(center, fromView: superview)}   // a variable for face-center
    var faceRadius:CGFloat{
        return min(bounds.size.width, bounds.size.height) / 2 * scale    // variable for face radius
    }
    @IBInspectable
    var color:UIColor = UIColor.blueColor() {didSet{setNeedsDisplay()}}  // variable for line color
    @IBInspectable
    var lineWidth:CGFloat = 3 {didSet{setNeedsDisplay()}}   // varable for line width
    @IBInspectable
    var scale:CGFloat = 0.8{didSet{setNeedsDisplay()}}      // varable for zooming or reducing
   
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)   // draw a cycle
        facePath.lineWidth = lineWidth     // define the line width
        color.set()    // set the color of cycle
        facePath.stroke()   // stroke the cycle
        
        bezierPathForEye(.Left).stroke()   //stroke the left eye
        bezierPathForEye(.Right).stroke()  //stroke the right eye
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0          // give the number for whether happy or unhappy
        let smilePath = bezierPathForSmile(smiliness)  //set the instance of smilness
        smilePath.stroke()           //stroke the line of mouth
        
    }
    func scale(guesture: UIPinchGestureRecognizer) {
        if guesture.state == .Changed {
            scale *= guesture.scale
            guesture.scale = 1
        }
    }
    weak var dataSource : FaceViewDateSource?
    
    private struct Scaling {                                      // define a struct for what the face look like
        static let FaceRadiusToEyeRadiusRatio:CGFloat = 10        // a constant for eye radius
        static let FaceRadiusToEyeOffSetRatio:CGFloat = 3         // a constant for eye offset
        static let FaceRadiusToEyeSeparationRatio:CGFloat = 1.5   // a constant for the size of eye separation
        static let FaceRadiusToMouthWidthRatio:CGFloat = 1        // a constant for the mouth width
        static let FaceRadiusToMouthHeightRatio:CGFloat = 3       // a constant for the mouth height
        static let FaceRadiusToMouthOffSetRatio:CGFloat = 3       // a constant for the mouth offset
        
    }
    private enum Eye {case Left, Right}                           //  define the enumuation include left and right
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath{
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffSet = faceRadius / Scaling.FaceRadiusToEyeOffSetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffSet
        switch whichEye{
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter .x += eyeHorizontalSeparation / 2
        }
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    private func bezierPathForSmile (fractionOfSmile: Double) -> UIBezierPath{
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffSet = faceRadius / Scaling.FaceRadiusToMouthOffSetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2 , y: faceCenter.y + mouthVerticalOffSet)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
}
