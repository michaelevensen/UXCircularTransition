//
//  PopAnimator.swift
//  UXCircularTransition
//
//  Created by Michael Nino Evensen on 05/10/2016.
//  Copyright © 2016 Michael Nino Evensen. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum PopTransitionMode {
        case Present, Dismiss
    }
    
    var transitionMode: PopTransitionMode = .Present
    
    // View of circle being presented
    var circle: UIView?
    
    // Color of circle, set based on button clicked
    var circleColor: UIColor?
    
    /* Duration */
    let presentDuration = 0.5
    let dismissDuration = 0.3
    
    // Starting point of transition
    var origin = CGPoint.zero
    
    /* MARK: - Required: UIViewControllerAnimatedTransitioning Protocol */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        /* Set the transition duration based on whether it is a presenting transition or a dismiss transition */
        if self.transitionMode == .Present {
            return presentDuration
        } else {
            return dismissDuration
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // The view that acts as the superview for the views involved in the transition.
        let containterView = transitionContext.containerView
        
        if self.transitionMode == .Present {
            
            // NOTE: This is the view (from the view controller) that is being presented / transitioned to
            let presentedView = transitionContext.view(forKey: .to)
            
            // Unwrap
            if let originalCenter = presentedView?.center,
                let originalSize = presentedView?.frame.size {
                
                /*
                 *  This is basically copying the view for the UIButton and making a new view that is going to be used for the transition itself.
                 *  Eg. I am not actually animating the button, but a constructed view based of the original UIButton.
                 */
                
                // Calculate the max size for the circle (to animate to)
                self.circle = UIView(frame: CGRect(origin: originalCenter, size: CGSize(width: 3000, height: 3000)))
                
                // Fully rounded
                self.circle!.layer.cornerRadius = self.circle!.frame.size.height / 2.0
                self.circle!.center = self.origin
                
                // Initially make it very small
                self.circle!.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                // Set BackgroundColor
                self.circle!.backgroundColor = self.circleColor
                
                /*
                *   Here I am adding this constructed UIView (that is to be animated) into the containerView which is the holding View (the view that you animate) for the animation.
                */
                containterView.addSubview(self.circle!)
                
                // Make presentedView very small and transparent
                presentedView?.center = origin
                presentedView?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                // Set background color
                presentedView?.backgroundColor = self.circleColor!
                
                // Add presented view to container view
                containterView.addSubview(presentedView!)
                
                /*
                *   Animate
                */
                UIView.animate(withDuration: self.presentDuration, animations: {
                    
                        // scale up circleview
                        self.circle?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                        // scale up presentedview
                        presentedView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                        // preserve center
                        presentedView?.center = originalCenter
                    
                    }, completion: { (finished) in
                        transitionContext.completeTransition(finished)
                })
            }
        }
        
        else {
            let returningViewController = transitionContext.view(forKey: .from)
            let originalCenter = returningViewController?.center
            let originalSize = returningViewController?.frame.size
            
            self.circle!.frame = CGRect(origin: originalCenter!, size: originalSize!)
            self.circle!.layer.cornerRadius = self.circle!.frame.size.height / 2.0
            self.circle!.center = self.origin
            
            UIView.animate(withDuration: self.dismissDuration, animations: {
                
                self.circle?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningViewController?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningViewController?.center = self.origin
                returningViewController?.alpha = 0
                
                }, completion: { (_) in
                    returningViewController?.removeFromSuperview()
                    self.circle?.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }
}
