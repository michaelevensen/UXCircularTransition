//
//  CircularButton.swift
//  UXCircularTransition
//
//  Created by Michael Nino Evensen on 05/10/2016.
//  Copyright © 2016 Michael Nino Evensen. All rights reserved.
//

import UIKit

@IBDesignable class CircularButton: UIButton {
    
    @IBInspectable var roundedCircleBackground: Bool = false {
        didSet {
            if self.roundedCircleBackground {
                self.layer.cornerRadius = 0.5 * self.bounds.size.width
                self.clipsToBounds = true
            }
            
            else {
                self.layer.cornerRadius = 0.0
                self.clipsToBounds = false
            }
        }
    }
}
