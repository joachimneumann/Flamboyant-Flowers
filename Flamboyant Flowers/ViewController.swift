//
//  ViewController.swift
//  Flamboyant Flowers
//
//  Created by Joachim Neumann on 30.09.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage(index: imageIndex)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        imageIndex += 1
        if imageIndex == 3 { imageIndex = 1 }
        UIView.transition(with: self.imageView,
                          duration:1.5,
        options: UIView.AnimationOptions.transitionCrossDissolve,
        animations: {
            self.imageView.bounds = self.view.bounds
            self.setImage(index: self.imageIndex)
            let widthRatio = self.imageView.bounds.size.width / (self.imageView.image?.size.width)!
            let heightRatio = self.imageView.bounds.size.height / (self.imageView.image?.size.height)!
            let scale = min(widthRatio, heightRatio)
            let imageHeight = scale *    (self.imageView.image?.size.height)!
            self.imageViewHeightConstraint.constant = imageHeight
            
//            let leftOverHeight = self.view.frame.size.height - imageHeight
//            self.bottomHeightConstraint.constant = leftOverHeight/2-40;
//            self.topHeightConstraint.constant = leftOverHeight/2-40;
            self.view.layoutIfNeeded()
//            let x = 3
        },
        completion: nil
//{
//            finished in
//            exit(0)
//        }
    )
    }
    


    func setImage(index: Int) {
        let image = UIImage(named: "\(index)")
        self.imageView.image = image
//        let c = image?.averageColorTop
//        self.view.backgroundColor = c
//        self.imageView.backgroundColor = c
//        let s = x?.extent.size.height
//        imageViewHeightConstraint.constraints =
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension UIImage {
    var averageColorTop: UIColor? {
        guard let inputImage = self.ciImage ?? CIImage(image: self) else { return nil }
        var limitedRect: CGRect = inputImage.extent
        limitedRect.origin.y = 0.9 * limitedRect.size.height
        limitedRect.size.height *= 0.1
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: limitedRect)])
        else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [CIContextOption.workingColorSpace : kCFNull as Any])
        let outputImageRect = CGRect(x: 0, y: 0, width: 1, height: 1)

        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: outputImageRect, format: CIFormat.RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3] / 255))
    }
    var averageColorBottom: UIColor? {
        guard let inputImage = self.ciImage ?? CIImage(image: self) else { return nil }
        var limitedRect: CGRect = inputImage.extent
        limitedRect.size.height *= 0.1
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: limitedRect)])
        else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [CIContextOption.workingColorSpace : kCFNull as Any])
        let outputImageRect = CGRect(x: 0, y: 0, width: 1, height: 1)

        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: outputImageRect, format: CIFormat.RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3] / 255))
    }
}
