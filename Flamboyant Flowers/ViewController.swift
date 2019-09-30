//
//  ViewController.swift
//  Flamboyant Flowers
//
//  Created by Joachim Neumann on 30.09.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.transition(with: self.imageView,
                          duration:0.5,
        options: UIView.AnimationOptions.transitionCrossDissolve,
        animations: {
            self.imageView.image = UIImage(contentsOfFile: "black")
        },
        completion: {
            finished in
            exit(0)
        })
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

