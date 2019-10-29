//
//  ManualViewController.swift
//  Flamboyant Flowers
//
//  Created by Joachim Neumann on 13.10.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit
import WebKit

class ManualViewController: UIViewController {

    @IBOutlet weak var webKitView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let pdfLoc = URL(fileURLWithPath: Bundle.main.path(forResource: "manual", ofType: "pdf")!)
        let request = URLRequest(url: pdfLoc)
        webKitView.load(request)

        self.navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.navigationBar.barTintColor = .black
    }

}
