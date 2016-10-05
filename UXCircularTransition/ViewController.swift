//
//  ViewController.swift
//  UXCircularTransition
//
//  Created by Michael Nino Evensen on 04/10/2016.
//  Copyright © 2016 Michael Nino Evensen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    /* Transition */
    let transition = PopAnimator()
    
    /* Selected */
    var selectedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /* MARK: - Required: UIViewControllerTransitioning Protocol */
    
    // Delegate method for presenting view controller
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition.transitionMode = .Present
        
        // The origin of the start of the transition, should be the center of the button. Eg. animate out from the center.
        self.transition.origin = self.selectedButton.center
        self.transition.circleColor = self.selectedButton.backgroundColor!
        
        return self.transition
    }

    // Delegate method for dismissing view controller
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition.transitionMode = .Dismiss
        
        // Where should the animation reverse back to? Center of button.
        self.transition.origin = self.selectedButton.center
        self.transition.circleColor = self.selectedButton.backgroundColor!
        
        return self.transition
    }
    
    /* Handle Tap */
    @IBAction func handleButton(_ sender: UIButton) {
        
        // Store selection
        self.selectedButton = sender
        
        // Perform Segue
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

