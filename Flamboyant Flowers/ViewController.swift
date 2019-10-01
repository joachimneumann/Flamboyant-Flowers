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
    
    var imageIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "1")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        imageIndex += 1
        if imageIndex == 15 { imageIndex = 1 }
        UIView.transition(with: self.imageView,
                          duration:1.5,
        options: UIView.AnimationOptions.transitionCrossDissolve,
        animations: {
            self.imageView.image = UIImage(named: "\(self.imageIndex)")
        },
        completion: nil
//{
//            finished in
//            exit(0)
//        }
    )
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

