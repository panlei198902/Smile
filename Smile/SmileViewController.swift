//
//  SmileViewController.swift
//  Smile
//
//  Created by Derex on 2/5/16.
//  Copyright © 2016 Derex. All rights reserved.
//

import UIKit

class SmileViewController: UIViewController, FaceViewDateSource {

    @IBAction func changeAction(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(smileView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: smileView)
            }
        default:break
        }
    }
    
    struct Constants {
        static let HappinessGestureScale: CGFloat = 5
    }
    @IBOutlet weak var smileView: SmileView! {
        didSet {
            smileView.dataSource = self
            smileView.addGestureRecognizer(UIPinchGestureRecognizer(target: smileView, action: #selector(SmileView.scale)))
        }
    }
    var happiness: Int = 75 {
        didSet {
            happiness = min(max(happiness, 0), 100)
        print("hppiness = \(happiness)")
        updateUI()
        }
    }
    private func updateUI(){
        smileView.setNeedsDisplay()
    }
    func smilinessForFaceView(sender: SmileView) -> Double? {
        return Double((happiness - 50) / 50)
    }
}
