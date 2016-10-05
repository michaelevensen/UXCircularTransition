//
//  ViewController.swift
//  UXCircularTransition
//
//  Created by Michael Nino Evensen on 04/10/2016.
//  Copyright © 2016 Michael Nino Evensen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    /* Transition */
    let transition = PopAnimator()
    
    /* Selected */
    var selectedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.firstButton.layer.cornerRadius = self.firstButton.frame.size.width / 2
        self.secondButton.layer.cornerRadius = self.secondButton.frame.size.width / 2
        self.thirdButton.layer.cornerRadius = self.thirdButton.frame.size.width / 2
        self.fourthButton.layer.cornerRadius = self.fourthButton.frame.size.width / 2
    }
    
    // Delegate method for presenting view controller
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // Transition Mode
        self.transition.transitionMode = .Present
        
        // Convert center point to parent coordinate space.
        let convertedCenter = self.selectedButton.convert(self.selectedButton.center, to: self.selectedButton.superview)
        
        // The origin of the start of the transition, should be the center of the button. Eg. animate out from the center.
        self.transition.origin = convertedCenter
        self.transition.circleColor = self.selectedButton.backgroundColor!
        
        return self.transition
    }

    // Delegate method for dismissing view controller
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // Transition Mode
        self.transition.transitionMode = .Dismiss
        
        // Convert center point to parent coordinate space.
        let convertedCenter = self.selectedButton.convert(self.selectedButton.center, to: self.selectedButton.superview)
        
        // Where should the animation reverse back to? Center of button.
        self.transition.origin = convertedCenter
        self.transition.circleColor = self.selectedButton.backgroundColor!
        
        return self.transition
    }
    
    /* Handle Tap */
    @IBAction func handleButton(_ sender: UIButton) {
        
        // Store selection
        self.selectedButton = sender
        
        // Perform segue
        self.performSegue(withIdentifier: "SecondViewControllerSegue", sender: sender)
    }
    
    // Set delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? SecondViewController {
            
            // Set transition delegate and modal presentation style
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
        }
    }
}

