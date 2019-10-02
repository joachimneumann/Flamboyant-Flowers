//
//  ViewController.swift
//  Flamboyant Flowers
//
//  Created by Joachim Neumann on 30.09.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageIndex = 1
    var imageHeight:CGFloat = 100
    var contraintConstant:CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = UIColor.black
        topView.backgroundColor = UIColor.black
        bottomView.backgroundColor = UIColor.black
        imageView.image = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.transition(with: self.imageView,
                          duration:0.5,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: {
                            self.setImage(index: self.imageIndex)
                          },
                          completion: {
                            finished in
                            self.topHeightConstraint.constant =    self.contraintConstant
                            self.bottomHeightConstraint.constant = self.contraintConstant
                          }
                        )
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        imageIndex += 1
        if imageIndex == 6 { imageIndex = 1 }
        
        UIView.transition(with: self.imageView,
                          duration:1.0,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
        animations: {
                self.setImage(index: self.imageIndex)
            },
            completion: {
                finished in
                self.topHeightConstraint.constant =    self.contraintConstant
                self.bottomHeightConstraint.constant = self.contraintConstant
            }
        )
    }
    


    func setImage(index: Int) {
        let image = UIImage(named: "\(index)")
        self.imageView.image = image

        let widthRatio = self.imageView.bounds.size.width / (self.imageView.image?.size.width)!
        let heightRatio = self.imageView.bounds.size.height / (self.imageView.image?.size.height)!
        let scale = min(widthRatio, heightRatio)
        imageHeight = scale * (self.imageView.image?.size.height)!
        contraintConstant = (self.imageView.bounds.size.height - self.imageHeight) / 2
        if let (cTop, cBottom) = image?.averageColors {
            imageView.backgroundColor = cTop
            topView.backgroundColor = cTop
            bottomView.backgroundColor = cBottom
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension UIImage {
    var averageColors: (UIColor?, UIColor?) {
        guard let inputImage = self.ciImage ?? CIImage(image: self) else { return (nil, nil) }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [CIContextOption.workingColorSpace : kCFNull as Any])
        let outputImageRect = CGRect(x: 0, y: 0, width: 1, height: 1)

        var limitedRect: CGRect = inputImage.extent
        limitedRect.origin.y = 0.95 * limitedRect.size.height
        limitedRect.size.height *= 0.05
        limitedRect.origin.x = 0.0
        limitedRect.size.width *= 0.05
        guard let filterTop = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: limitedRect)])
        else { return (nil, nil) }
        guard let outputImageTop = filterTop.outputImage else { return (nil, nil) }
        context.render(outputImageTop, toBitmap: &bitmap, rowBytes: 4, bounds: outputImageRect, format: CIFormat.RGBA8, colorSpace: nil)
        let topColor = UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3] / 255))

        
        limitedRect = inputImage.extent
        limitedRect.size.height *= 0.05
        limitedRect.origin.x = 0.0
        limitedRect.size.width *= 0.05
        guard let filterBottom = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: limitedRect)])
        else { return (nil, nil) }
        guard let outputImageBottom = filterBottom.outputImage else { return (nil, nil) }
        bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImageBottom, toBitmap: &bitmap, rowBytes: 4, bounds: outputImageRect, format: CIFormat.RGBA8, colorSpace: nil)
        let bottomColor = UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3] / 255))
        
        return (topColor, bottomColor)
    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
