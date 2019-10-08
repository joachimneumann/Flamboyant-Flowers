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
    @IBOutlet weak var dateLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var imageIndex = 1
    var imageHeight:CGFloat = 100
    var contraintConstant:CGFloat = 100
    
    let numberOfFlowers = 12
    let names = [
        1: "Anemone coronaria L.",
        2: "Nigella damascena",
        3: "Astrantia",
        4: "Centaurea Dealbata Willd.",
        5: "Coreopsis Verticillata",
        6: "Hydrangea",
        7: "Linum grandiflorum",
        8: "Echinacea Purpurea ",
        9: "Phacelia Campanularia",
        10: "Albizia",
        11: "Xerochrysum Bracteatum Syn.",
        12: "Monarda Didyma"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userActivity = NSUserActivity(activityType: "com.joachimneuman.flamboyantFlowers")
        userActivity.isEligibleForSearch = true
        userActivity.isEligibleForPrediction = true
        userActivity.title = "show a flamboyant flower"
        
        self.userActivity = userActivity
        
        imageView.backgroundColor = UIColor.black
        topView.backgroundColor = UIColor.black
        bottomView.backgroundColor = UIColor.black
        imageView.image = nil
        timeLabel.isHidden = true
        dateLabel.isHidden = true
        nameLabel.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.becomeFirstResponder()
        let date = Date() // now
        let cal = Calendar.current
        imageIndex = (cal.ordinality(of: .day, in: .year, for: date)!) % numberOfFlowers + 1
    }
    
    //
    // start: quickly blend in
    //
    override func viewDidAppear(_ animated: Bool) {
        UIView.transition(with: self.imageView,
                          duration:0.1,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: {
                            self.setImageAndBackgroundColors(index: self.imageIndex)
                            self.nameLabel.text = self.names[self.imageIndex % 10]
                          },
                          completion: {
                            finished in
                            self.topHeightConstraint.constant =    self.contraintConstant
                            self.bottomHeightConstraint.constant = self.contraintConstant
                          }
                        )
    }

    //
    // hide everything else
    //
    override var prefersHomeIndicatorAutoHidden: Bool { return true }
    override var prefersStatusBarHidden: Bool { return true }

    //
    // detect shake motion
    //
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEvent.EventSubtype.motionShake) {
            imageIndex += 1
            if imageIndex == (numberOfFlowers+1) { imageIndex = 1 }
            nameLabel.text = ""
            let delay = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                self.nameLabel.text = self.names[self.imageIndex]
            }

            view.setNeedsDisplay()
            UIView.transition(with: self.imageView,
                              duration:delay,
                              options: UIView.AnimationOptions.transitionCrossDissolve,
            animations: {
                self.setImageAndBackgroundColors(index: self.imageIndex)
            },
                completion: {
                    finished in
                    self.topHeightConstraint.constant =    self.contraintConstant
                    self.bottomHeightConstraint.constant = self.contraintConstant
                }
            )
        }
    }
    

    @objc func setTimeLabel() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let hourString = String(format: "%02d", hour)
        let minutesString = String(format: "%02d", minutes)
        timeLabel.text = hourString + ":" + minutesString
    }

    func layoutTexts() {
        // 1 Second-Timer for updating the time label
        if UserDefaults.standard.bool(forKey: "enabled_preference_time") {
            let timer = Timer.scheduledTimer(timeInterval: 1, target: self,
            selector: #selector(setTimeLabel), userInfo: nil, repeats: true)
            timer.tolerance = 0.1 // using a bit less power
            setTimeLabel() // in addtition, call it now
            timeLabel.isHidden = false
        } else {
            timeLabel.isHidden = true
        }
        if UserDefaults.standard.bool(forKey: "enabled_preference_date") {
            let dateFormater = DateFormatter()
            dateFormater.setLocalizedDateFormatFromTemplate("EEEE d MMMM")
            dateLabel.text =  dateFormater.string(from: Date())
            dateLabel.isHidden = false
            if UserDefaults.standard.bool(forKey: "enabled_preference_time") {
                dateLabelTopConstraint.constant = timeLabel.frame.maxY
            } else {
                dateLabelTopConstraint.constant = 31 // only show day
            }
        } else {
            dateLabel.isHidden = true
        }
        if UserDefaults.standard.bool(forKey: "enabled_preference_name") {
            nameLabel.isHidden = false
        } else {
            nameLabel.isHidden = true
        }
    }

    var firstTime = true
    //
    // delay the display of the texts for a few seconds
    // (but only at app start)
    //
    @objc func willEnterForeground(_ animated: Bool) {
        if firstTime {
            firstTime = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                UIView.transition(with: self.view,
                                  duration:1.0,
                                  options: UIView.AnimationOptions.transitionCrossDissolve,
                animations: {
                        self.layoutTexts()
                    },
                    completion: {
                        finished in
                    }
                )
            }
        } else {
            self.layoutTexts()
        }
    }

    //
    // tab --> close app
    //
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let mySceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        if mySceneDelegate.startedFromShortCut {
            // hide texts
            UIView.transition(with: self.imageView,
                              duration:0.2,
                              options: UIView.AnimationOptions.transitionCrossDissolve,
            animations: {
                    self.timeLabel.isHidden = true
                    self.dateLabel.isHidden = true
                    self.nameLabel.isHidden = true
                },
                completion: nil
            )
            
            // let flower disappear and close app
            UIView.transition(with: self.imageView,
                              duration:0.4,
                              options: UIView.AnimationOptions.transitionCrossDissolve,
            animations: {
                    self.imageView.image = nil
                    self.imageView.backgroundColor = UIColor.black
                    self.topView.backgroundColor = UIColor.black
                    self.bottomView.backgroundColor = UIColor.black
                },
                completion: {
                    finished in
                        exit(0)
                    }
            )
                
        } // if startedFromShortCut
    }
    

    func setImageAndBackgroundColors(index: Int) {
        let image = UIImage(named: "\(index)")
        imageView.image = image

        let widthRatio = imageView.bounds.size.width / (imageView.image?.size.width)!
        let heightRatio = imageView.bounds.size.height / (imageView.image?.size.height)!
        let scale = min(widthRatio, heightRatio)
        imageHeight = scale * (imageView.image?.size.height)!
        contraintConstant = (imageView.bounds.size.height - imageHeight) / 2
        if let (cTop, cBottom) = image?.averageColors {
            imageView.backgroundColor = cTop
            topView.backgroundColor = cTop
            bottomView.backgroundColor = cBottom
        }
    }

}

extension UIImage {
    var averageColors: (UIColor?, UIColor?) {
        // Calculate the averate color in a small rectabular area in the top left and in the bottom left
        // The small area makes the calculation faster
        guard let inputImage = self.ciImage ?? CIImage(image: self) else { return (nil, nil) }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [CIContextOption.workingColorSpace : kCFNull as Any])
        let outputImageRect = CGRect(x: 0, y: 0, width: 1, height: 1)

        // small top rectangular
        var limitedRect: CGRect = inputImage.extent
        limitedRect.origin.y = 0.95 * limitedRect.size.height
        limitedRect.size.height *= 0.05
        if limitedRect.size.height > 100 { limitedRect.size.height = 100 }
        limitedRect.origin.x = 0.0
        limitedRect.size.width *= 0.05
        if limitedRect.size.width > 100 { limitedRect.size.width = 100 }
        guard let filterTop = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: limitedRect)])
        else { return (nil, nil) }
        guard let outputImageTop = filterTop.outputImage else { return (nil, nil) }
        context.render(outputImageTop, toBitmap: &bitmap, rowBytes: 4, bounds: outputImageRect, format: CIFormat.RGBA8, colorSpace: nil)
        let topColor = UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3] / 255))

        // small bottom rectangular (same size and x position)
        limitedRect.origin.y = 0
        guard let filterBottom = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: limitedRect)])
        else { return (nil, nil) }
        guard let outputImageBottom = filterBottom.outputImage else { return (nil, nil) }
        bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImageBottom, toBitmap: &bitmap, rowBytes: 4, bounds: outputImageRect, format: CIFormat.RGBA8, colorSpace: nil)
        let bottomColor = UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3] / 255))
        
        return (topColor, bottomColor)
    }
}
