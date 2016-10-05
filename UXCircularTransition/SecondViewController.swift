//
//  SecondViewController.swift
//  UXCircularTransition
//
//  Created by Michael Nino Evensen on 05/10/2016.
//  Copyright © 2016 Michael Nino Evensen. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /* Dismiss */
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
