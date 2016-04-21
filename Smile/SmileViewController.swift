//
//  SmileViewController.swift
//  Smile
//
//  Created by Derex on 2/5/16.
//  Copyright © 2016 Derex. All rights reserved.
//

import UIKit

class SmileViewController: UIViewController {

    var happiness: Int = 50 {
        didSet {happiness = min(max(happiness, 0), 100)}
    }

}
